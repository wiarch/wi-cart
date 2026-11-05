<?php

namespace App\Services;

use App\Models\Category;
use App\Models\ListItem;
use App\Models\Product;
use App\Models\PurchaseHistory;
use App\Models\PurchaseHistoryItem;
use App\Models\ShoppingList;
use App\Models\Store;
use App\Models\Unit;
use App\Models\User;
use Carbon\Carbon;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Facades\DB;
use Illuminate\Validation\ValidationException;

class SyncService
{
    /** @var array<string, class-string<Model>> */
    public const ENTITY_MAP = [
        'categories' => Category::class,
        'units' => Unit::class,
        'products' => Product::class,
        'stores' => Store::class,
        'shopping_lists' => ShoppingList::class,
        'list_items' => ListItem::class,
        'purchase_histories' => PurchaseHistory::class,
        'purchase_history_items' => PurchaseHistoryItem::class,
    ];

    /** @var array<string, list<string>> */
    private const FILLABLE = [
        'categories' => ['name', 'icon', 'color'],
        'units' => ['name', 'abbreviation'],
        'products' => [
            'name', 'description', 'category_id', 'unit_id',
            'base_price', 'image_path', 'image_pending',
        ],
        'stores' => ['name', 'location', 'icon', 'notes'],
        'shopping_lists' => ['name', 'status', 'notes', 'icon', 'store_id', 'store_location'],
        'list_items' => [
            'shopping_list_id', 'product_id', 'unit_id', 'unit_abbr', 'name',
            'qty_planned', 'qty_bought', 'unit_price', 'status', 'notes',
        ],
        'purchase_histories' => [
            'shopping_list_id', 'store_location', 'purchased_at', 'total',
        ],
        'purchase_history_items' => [
            'purchase_history_id', 'product_id', 'name', 'unit_abbr',
            'quantity', 'unit_price', 'line_total',
        ],
    ];

    /**
     * @param  list<array{entity:string,id:string,op:string,payload?:array,client_updated_at:string}>  $mutations
     * @return array{applied: list<array>, rejected: list<array>}
     */
    public function push(User $user, ?string $deviceId, array $mutations): array
    {
        $applied = [];
        $rejected = [];

        DB::transaction(function () use ($user, $deviceId, $mutations, &$applied, &$rejected) {
            foreach ($mutations as $mutation) {
                $entity = $mutation['entity'] ?? null;
                $id = $mutation['id'] ?? null;
                $op = $mutation['op'] ?? null;
                $clientUpdatedAt = $mutation['client_updated_at'] ?? null;

                if (! is_string($entity) || ! isset(self::ENTITY_MAP[$entity])) {
                    $rejected[] = ['id' => $id, 'reason' => 'unknown_entity'];
                    continue;
                }

                $op = $this->normalizeOp(is_string($op) ? $op : null);
                if (! is_string($id) || $op === null || ! $clientUpdatedAt) {
                    $rejected[] = ['id' => $id, 'reason' => 'invalid_mutation'];
                    continue;
                }

                $incomingAt = Carbon::parse($clientUpdatedAt);
                /** @var class-string<Model> $modelClass */
                $modelClass = self::ENTITY_MAP[$entity];

                /** @var Model|null $existing */
                $existing = $modelClass::withTrashed()
                    ->where('user_id', $user->id)
                    ->where('id', $id)
                    ->first();

                if ($existing && $existing->client_updated_at && $existing->client_updated_at->gt($incomingAt)) {
                    $rejected[] = [
                        'id' => $id,
                        'entity' => $entity,
                        'reason' => 'lww_keep_server',
                        'server' => $existing->toArray(),
                    ];
                    continue;
                }

                if ($op === 'delete') {
                    if (! $existing) {
                        $row = $modelClass::make([
                            'id' => $id,
                            'user_id' => $user->id,
                            'device_id' => $deviceId,
                            'client_updated_at' => $incomingAt,
                        ]);
                        foreach (self::FILLABLE[$entity] as $field) {
                            if (! isset($row->{$field})) {
                                $row->{$field} = $this->tombstoneDefault($field);
                            }
                        }
                        $row->deleted_at = now();
                        $row->save();
                        $existing = $row->fresh();
                    } else {
                        $existing->forceFill([
                            'device_id' => $deviceId,
                            'client_updated_at' => $incomingAt,
                        ]);
                        $existing->deleted_at = now();
                        $existing->save();
                    }

                    $applied[] = [
                        'id' => $id,
                        'entity' => $entity,
                        'op' => 'delete',
                        'row' => $existing->fresh()->toArray(),
                    ];
                    continue;
                }

                $payload = is_array($mutation['payload'] ?? null) ? $mutation['payload'] : [];
                $data = [
                    'id' => $id,
                    'user_id' => $user->id,
                    'device_id' => $deviceId,
                    'client_updated_at' => $incomingAt,
                ];
                foreach (self::FILLABLE[$entity] as $field) {
                    if (array_key_exists($field, $payload)) {
                        $data[$field] = $payload[$field];
                    }
                }

                if ($existing) {
                    $existing->fill($data);
                    $existing->deleted_at = null;
                    $existing->save();
                    $row = $existing->fresh();
                } else {
                    $row = $modelClass::create($data);
                }

                $applied[] = [
                    'id' => $id,
                    'entity' => $entity,
                    'op' => 'upsert',
                    'row' => $row->toArray(),
                ];
            }
        });

        return compact('applied', 'rejected');
    }

    /**
     * @return array{server_time: Carbon, changes: array<string, list<array>>}
     */
    public function pull(User $user, ?Carbon $since): array
    {
        // Capture cursor BEFORE queries so concurrent writes after this
        // timestamp are included in the next pull.
        $serverTime = now();
        $changes = [];

        foreach (self::ENTITY_MAP as $entity => $modelClass) {
            $query = $modelClass::withTrashed()->where('user_id', $user->id);
            if ($since) {
                $query->where('updated_at', '>=', $since);
            }
            $changes[$entity] = $query->orderBy('updated_at')->get()->map->toArray()->all();
        }

        return [
            'server_time' => $serverTime,
            'changes' => $changes,
        ];
    }

    /**
     * Map wire ops to internal upsert|delete.
     * Accepts: create, update, upsert → upsert; delete → delete.
     */
    public function normalizeOp(?string $op): ?string
    {
        return match (strtolower((string) $op)) {
            'create', 'update', 'upsert' => 'upsert',
            'delete' => 'delete',
            default => null,
        };
    }

    private function tombstoneDefault(string $field): mixed
    {
        return match ($field) {
            'name' => '',
            'status' => 'pending',
            'qty_planned', 'quantity', 'total' => 0,
            'purchased_at' => now(),
            'image_pending' => false,
            // NOT NULL FK-like columns for tombstone-only rows
            'shopping_list_id', 'purchase_history_id' => '00000000-0000-4000-8000-000000000000',
            default => null,
        };
    }

    public function assertKnownEntities(array $mutations): void
    {
        foreach ($mutations as $i => $mutation) {
            if (! isset(self::ENTITY_MAP[$mutation['entity'] ?? ''])) {
                throw ValidationException::withMessages([
                    "mutations.$i.entity" => 'Unknown sync entity.',
                ]);
            }
        }
    }
}
