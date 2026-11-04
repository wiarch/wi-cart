<?php

namespace Tests\Feature;

use App\Models\ListItem;
use App\Models\Product;
use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class SyncTest extends TestCase
{
    use RefreshDatabase;

    public function test_push_upsert_and_pull(): void
    {
        $user = User::factory()->create();
        $token = $user->createToken('test')->plainTextToken;
        $id = '11111111-1111-4111-8111-111111111111';

        $push = $this->withToken($token)->postJson('/api/sync/push', [
            'device_id' => 'device-1',
            'mutations' => [[
                'entity' => 'products',
                'id' => $id,
                'op' => 'upsert',
                'client_updated_at' => now()->toISOString(),
                'payload' => [
                    'name' => 'Arroz',
                    'base_price' => 2.5,
                ],
            ]],
        ]);

        $push->assertOk()->assertJsonPath('applied.0.id', $id);
        $this->assertDatabaseHas('products', ['id' => $id, 'name' => 'Arroz']);

        $pull = $this->withToken($token)->getJson('/api/sync/pull');
        $pull->assertOk();
        $this->assertNotEmpty($pull->json('changes.products'));
        $this->assertNotNull($pull->json('server_time'));
    }

    public function test_lww_rejects_stale_mutation(): void
    {
        $user = User::factory()->create();
        $token = $user->createToken('test')->plainTextToken;
        $id = '22222222-2222-4222-8222-222222222222';

        Product::create([
            'id' => $id,
            'user_id' => $user->id,
            'name' => 'Nuevo',
            'client_updated_at' => now(),
        ]);

        $res = $this->withToken($token)->postJson('/api/sync/push', [
            'mutations' => [[
                'entity' => 'products',
                'id' => $id,
                'op' => 'upsert',
                'client_updated_at' => now()->subHour()->toISOString(),
                'payload' => ['name' => 'Viejo'],
            ]],
        ]);

        $res->assertOk();
        $this->assertSame('lww_keep_server', $res->json('rejected.0.reason'));
        $this->assertDatabaseHas('products', ['id' => $id, 'name' => 'Nuevo']);
    }

    public function test_delete_tombstone_for_missing_list_item(): void
    {
        $user = User::factory()->create();
        $token = $user->createToken('test')->plainTextToken;
        $id = '33333333-3333-4333-8333-333333333333';

        $res = $this->withToken($token)->postJson('/api/sync/push', [
            'mutations' => [[
                'entity' => 'list_items',
                'id' => $id,
                'op' => 'delete',
                'client_updated_at' => now()->toISOString(),
            ]],
        ]);

        $res->assertOk()->assertJsonPath('applied.0.id', $id);
        $this->assertDatabaseHas('list_items', [
            'id' => $id,
            'shopping_list_id' => '00000000-0000-4000-8000-000000000000',
        ]);
        $this->assertNotNull(ListItem::withTrashed()->find($id)?->deleted_at);
    }

    public function test_pull_includes_soft_deleted_and_new_fields(): void
    {
        $user = User::factory()->create();
        $token = $user->createToken('test')->plainTextToken;
        $listId = '44444444-4444-4444-8444-444444444444';
        $histId = '55555555-5555-4555-8555-555555555555';

        $this->withToken($token)->postJson('/api/sync/push', [
            'mutations' => [
                [
                    'entity' => 'categories',
                    'id' => '66666666-6666-4666-8666-666666666666',
                    'op' => 'upsert',
                    'client_updated_at' => now()->toISOString(),
                    'payload' => [
                        'name' => 'Lácteos',
                        'icon' => 'dairy',
                        'color' => '#1565C0',
                    ],
                ],
                [
                    'entity' => 'shopping_lists',
                    'id' => $listId,
                    'op' => 'upsert',
                    'client_updated_at' => now()->toISOString(),
                    'payload' => [
                        'name' => 'Semana',
                        'status' => 'completed',
                        'store_location' => 'Mercadona',
                    ],
                ],
                [
                    'entity' => 'purchase_histories',
                    'id' => $histId,
                    'op' => 'upsert',
                    'client_updated_at' => now()->toISOString(),
                    'payload' => [
                        'shopping_list_id' => $listId,
                        'store_location' => 'Mercadona',
                        'purchased_at' => now()->toISOString(),
                        'total' => 12.5,
                    ],
                ],
            ],
        ])->assertOk();

        $pull = $this->withToken($token)->getJson('/api/sync/pull');
        $pull->assertOk();
        $cats = collect($pull->json('changes.categories'));
        $this->assertTrue($cats->contains(fn ($c) => ($c['icon'] ?? null) === 'dairy'));
        $lists = collect($pull->json('changes.shopping_lists'));
        $this->assertTrue($lists->contains(fn ($l) => ($l['store_location'] ?? null) === 'Mercadona'));
    }

    public function test_pull_cursor_uses_gte_since(): void
    {
        $user = User::factory()->create();
        $token = $user->createToken('test')->plainTextToken;
        $id = '77777777-7777-4777-8777-777777777777';

        $this->withToken($token)->postJson('/api/sync/push', [
            'mutations' => [[
                'entity' => 'products',
                'id' => $id,
                'op' => 'upsert',
                'client_updated_at' => now()->toISOString(),
                'payload' => ['name' => 'Leche'],
            ]],
        ])->assertOk();

        $product = Product::findOrFail($id);
        $since = $product->updated_at->toISOString();

        $pull = $this->withToken($token)->getJson('/api/sync/pull?since='.urlencode($since));
        $pull->assertOk();
        $ids = collect($pull->json('changes.products'))->pluck('id');
        $this->assertTrue($ids->contains($id));
    }
}
