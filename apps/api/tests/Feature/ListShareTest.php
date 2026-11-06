<?php

namespace Tests\Feature;

use App\Models\Category;
use App\Models\ListItem;
use App\Models\Product;
use App\Models\ShoppingList;
use App\Models\Store;
use App\Models\Unit;
use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class ListShareTest extends TestCase
{
    use RefreshDatabase;

    public function test_share_copies_list_to_username(): void
    {
        $owner = User::factory()->create(['username' => 'ana']);
        $other = User::factory()->create(['username' => 'luis']);
        $token = $owner->createToken('test')->plainTextToken;
        $now = now();

        $store = Store::create([
            'id' => 'aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa',
            'user_id' => $owner->id,
            'name' => 'Mercado',
            'client_updated_at' => $now,
        ]);
        $category = Category::create([
            'id' => 'bbbbbbbb-bbbb-4bbb-8bbb-bbbbbbbbbbbb',
            'user_id' => $owner->id,
            'name' => 'Verdura',
            'client_updated_at' => $now,
        ]);
        $unit = Unit::create([
            'id' => 'cccccccc-cccc-4ccc-8ccc-cccccccccccc',
            'user_id' => $owner->id,
            'name' => 'Kilogramo',
            'abbreviation' => 'kg',
            'client_updated_at' => $now,
        ]);
        $product = Product::create([
            'id' => 'dddddddd-dddd-4ddd-8ddd-dddddddddddd',
            'user_id' => $owner->id,
            'name' => 'Tomate',
            'category_id' => $category->id,
            'unit_id' => $unit->id,
            'base_price' => 1.5,
            'client_updated_at' => $now,
        ]);
        $list = ShoppingList::create([
            'id' => 'eeeeeeee-eeee-4eee-8eee-eeeeeeeeeeee',
            'user_id' => $owner->id,
            'name' => 'Compra',
            'status' => 'active',
            'store_id' => $store->id,
            'client_updated_at' => $now,
        ]);
        ListItem::create([
            'id' => 'ffffffff-ffff-4fff-8fff-ffffffffffff',
            'user_id' => $owner->id,
            'shopping_list_id' => $list->id,
            'product_id' => $product->id,
            'unit_id' => $unit->id,
            'name' => 'Tomate',
            'qty_planned' => 2,
            'unit_price' => 1.5,
            'status' => 'pending',
            'client_updated_at' => $now,
        ]);

        $res = $this->withToken($token)->postJson("/api/lists/{$list->id}/share", [
            'username' => '@Luis',
        ]);

        $res->assertOk()->assertJsonPath('list_name', 'Compra');
        $this->assertSame(1, ShoppingList::where('user_id', $owner->id)->count());
        $copy = ShoppingList::where('user_id', $other->id)->first();
        $this->assertNotNull($copy);
        $this->assertSame('Compra', $copy->name);
        $this->assertNotSame($list->id, $copy->id);
        $this->assertSame(1, ListItem::where('shopping_list_id', $copy->id)->count());
        $this->assertSame(1, Product::where('user_id', $other->id)->where('name', 'Tomate')->count());
        $this->assertSame(1, Store::where('user_id', $other->id)->where('name', 'Mercado')->count());
        $this->assertSame('dddddddd-dddd-4ddd-8ddd-dddddddddddd', $product->fresh()->id);
    }

    public function test_unknown_username_is_rejected(): void
    {
        $owner = User::factory()->create(['username' => 'ana']);
        $token = $owner->createToken('test')->plainTextToken;
        $list = ShoppingList::create([
            'id' => 'eeeeeeee-eeee-4eee-8eee-eeeeeeeeeeee',
            'user_id' => $owner->id,
            'name' => 'Compra',
            'status' => 'active',
            'client_updated_at' => now(),
        ]);

        $this->withToken($token)->postJson("/api/lists/{$list->id}/share", [
            'username' => 'nadie',
        ])->assertStatus(422);
    }
}
