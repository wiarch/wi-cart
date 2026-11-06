<?php

namespace App\Services;

use App\Models\Category;
use App\Models\ListItem;
use App\Models\Product;
use App\Models\ShoppingList;
use App\Models\Store;
use App\Models\Unit;
use App\Models\User;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;
use Illuminate\Validation\ValidationException;

class ListShareService
{
    /**
     * Copy one list (and the store, products, categories and units it needs)
     * onto another account. New ids, so the sender's sync stays untouched.
     * shortcut: each share inserts fresh copies, no match by name.
     */
    public function share(User $from, string $listId, string $username): ShoppingList
    {
        $username = Str::lower(ltrim(trim($username), '@'));
        $to = User::query()->whereRaw('lower(username) = ?', [$username])->first();
        if ($to === null) {
            throw ValidationException::withMessages([
                'username' => ['No hay un usuario con ese nombre.'],
            ]);
        }
        if ($to->id === $from->id) {
            throw ValidationException::withMessages([
                'username' => ['No puedes compartir la lista contigo.'],
            ]);
        }

        $list = ShoppingList::query()
            ->where('user_id', $from->id)
            ->whereKey($listId)
            ->first();
        if ($list === null) {
            abort(404);
        }

        return DB::transaction(function () use ($from, $to, $list) {
            $now = now();
            $newStoreId = $this->copyStore($from, $to, $list->store_id, $now);

            $items = ListItem::query()
                ->where('user_id', $from->id)
                ->where('shopping_list_id', $list->id)
                ->get();

            $productIds = [];
            $unitIds = [];
            $categoryIds = [];
            foreach ($items as $item) {
                $this->copyUnit($from, $to, $item->unit_id, $unitIds, $now);
                $this->copyProduct($from, $to, $item->product_id, $productIds, $unitIds, $categoryIds, $now);
            }

            $copy = ShoppingList::create([
                'id' => (string) Str::uuid(),
                'user_id' => $to->id,
                'name' => $list->name,
                'status' => 'active',
                'notes' => $list->notes,
                'icon' => $list->icon,
                'store_id' => $newStoreId,
                'store_location' => $list->store_location,
                'client_updated_at' => $now,
            ]);

            foreach ($items as $item) {
                ListItem::create([
                    'id' => (string) Str::uuid(),
                    'user_id' => $to->id,
                    'shopping_list_id' => $copy->id,
                    'product_id' => $productIds[$item->product_id] ?? null,
                    'unit_id' => $unitIds[$item->unit_id] ?? null,
                    'unit_abbr' => $item->unit_abbr,
                    'name' => $item->name,
                    'qty_planned' => $item->qty_planned,
                    'qty_bought' => $item->qty_bought,
                    'unit_price' => $item->unit_price,
                    'status' => $item->status,
                    'notes' => $item->notes,
                    'client_updated_at' => $now,
                ]);
            }

            return $copy;
        });
    }

    /** Copy the store and every list that belongs to it. */
    public function shareStore(User $from, string $storeId, string $username): Store
    {
        $username = Str::lower(ltrim(trim($username), '@'));
        $to = User::query()->whereRaw('lower(username) = ?', [$username])->first();
        if ($to === null) {
            throw ValidationException::withMessages([
                'username' => ['No hay un usuario con ese nombre.'],
            ]);
        }
        if ($to->id === $from->id) {
            throw ValidationException::withMessages([
                'username' => ['No puedes compartir la tienda contigo.'],
            ]);
        }

        $store = Store::query()->where('user_id', $from->id)->whereKey($storeId)->first();
        if ($store === null) {
            abort(404);
        }

        return DB::transaction(function () use ($from, $to, $store) {
            $now = now();
            $newStoreId = $this->copyStore($from, $to, $store->id, $now);
            $lists = ShoppingList::query()
                ->where('user_id', $from->id)
                ->where('store_id', $store->id)
                ->get();
            $productIds = [];
            $unitIds = [];
            $categoryIds = [];
            foreach ($lists as $list) {
                $this->copyList($from, $to, $list, $newStoreId, $now, $productIds, $unitIds, $categoryIds);
            }

            return Store::query()->whereKey($newStoreId)->firstOrFail();
        });
    }

    /**
     * @param  array<string, string>  $productIds
     * @param  array<string, string>  $unitIds
     * @param  array<string, string>  $categoryIds
     */
    private function copyList(User $from, User $to, ShoppingList $list, ?string $storeId, $now, array &$productIds, array &$unitIds, array &$categoryIds): void
    {
        $items = ListItem::query()
            ->where('user_id', $from->id)
            ->where('shopping_list_id', $list->id)
            ->get();
        foreach ($items as $item) {
            $this->copyUnit($from, $to, $item->unit_id, $unitIds, $now);
            $this->copyProduct($from, $to, $item->product_id, $productIds, $unitIds, $categoryIds, $now);
        }
        $copy = ShoppingList::create([
            'id' => (string) Str::uuid(),
            'user_id' => $to->id,
            'name' => $list->name,
            'status' => 'active',
            'notes' => $list->notes,
            'icon' => $list->icon,
            'store_id' => $storeId,
            'store_location' => $list->store_location,
            'client_updated_at' => $now,
        ]);
        foreach ($items as $item) {
            ListItem::create([
                'id' => (string) Str::uuid(),
                'user_id' => $to->id,
                'shopping_list_id' => $copy->id,
                'product_id' => $productIds[$item->product_id] ?? null,
                'unit_id' => $unitIds[$item->unit_id] ?? null,
                'unit_abbr' => $item->unit_abbr,
                'name' => $item->name,
                'qty_planned' => $item->qty_planned,
                'qty_bought' => $item->qty_bought,
                'unit_price' => $item->unit_price,
                'status' => $item->status,
                'notes' => $item->notes,
                'client_updated_at' => $now,
            ]);
        }
    }

    /** @param  array<string, string>  $unitIds */
    private function copyStore(User $from, User $to, ?string $storeId, $now): ?string
    {
        if ($storeId === null) {
            return null;
        }
        $store = Store::query()->where('user_id', $from->id)->whereKey($storeId)->first();
        if ($store === null) {
            return null;
        }
        $id = (string) Str::uuid();
        Store::create([
            'id' => $id,
            'user_id' => $to->id,
            'name' => $store->name,
            'location' => $store->location,
            'icon' => $store->icon,
            'notes' => $store->notes,
            'client_updated_at' => $now,
        ]);

        return $id;
    }

    /**
     * @param  array<string, string>  $productIds
     * @param  array<string, string>  $unitIds
     * @param  array<string, string>  $categoryIds
     */
    private function copyProduct(User $from, User $to, ?string $productId, array &$productIds, array &$unitIds, array &$categoryIds, $now): void
    {
        if ($productId === null || isset($productIds[$productId])) {
            return;
        }
        $product = Product::query()->where('user_id', $from->id)->whereKey($productId)->first();
        if ($product === null) {
            return;
        }
        $categoryId = $this->copyCategory($from, $to, $product->category_id, $categoryIds, $now);
        $this->copyUnit($from, $to, $product->unit_id, $unitIds, $now);
        $id = (string) Str::uuid();
        Product::create([
            'id' => $id,
            'user_id' => $to->id,
            'name' => $product->name,
            'description' => $product->description,
            'category_id' => $categoryId,
            'unit_id' => $unitIds[$product->unit_id] ?? null,
            'base_price' => $product->base_price,
            'image_path' => $product->image_path,
            'image_pending' => false,
            'client_updated_at' => $now,
        ]);
        $productIds[$productId] = $id;
    }

    /** @param  array<string, string>  $categoryIds */
    private function copyCategory(User $from, User $to, ?string $categoryId, array &$categoryIds, $now): ?string
    {
        if ($categoryId === null) {
            return null;
        }
        if (isset($categoryIds[$categoryId])) {
            return $categoryIds[$categoryId];
        }
        $category = Category::query()->where('user_id', $from->id)->whereKey($categoryId)->first();
        if ($category === null) {
            return null;
        }
        $id = (string) Str::uuid();
        Category::create([
            'id' => $id,
            'user_id' => $to->id,
            'name' => $category->name,
            'icon' => $category->icon,
            'color' => $category->color,
            'client_updated_at' => $now,
        ]);
        $categoryIds[$categoryId] = $id;

        return $id;
    }

    /** @param  array<string, string>  $unitIds */
    private function copyUnit(User $from, User $to, ?string $unitId, array &$unitIds, $now): void
    {
        if ($unitId === null || isset($unitIds[$unitId])) {
            return;
        }
        $unit = Unit::query()->where('user_id', $from->id)->whereKey($unitId)->first();
        if ($unit === null) {
            return;
        }
        $id = (string) Str::uuid();
        Unit::create([
            'id' => $id,
            'user_id' => $to->id,
            'name' => $unit->name,
            'abbreviation' => $unit->abbreviation,
            'client_updated_at' => $now,
        ]);
        $unitIds[$unitId] = $id;
    }
}
