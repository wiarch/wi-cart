<?php

namespace App\Http\Controllers;

use App\Models\Category;
use App\Models\ListItem;
use App\Models\Product;
use App\Models\ShoppingList;
use App\Models\Store;
use App\Models\Unit;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class SearchController extends Controller
{
    public function __invoke(Request $request): JsonResponse
    {
        $query = trim((string) $request->query('q', ''));

        if ($query === '') {
            return response()->json(['data' => []]);
        }

        $userId = $request->user()->id;
        $like = '%'.addcslashes($query, '%_\\').'%';
        $results = [];
        $limit = 5;

        $sources = [
            [
                'rows' => ShoppingList::query()
                    ->where('user_id', $userId)
                    ->where('name', 'like', $like)
                    ->withCount('items')
                    ->orderBy('name')
                    ->limit($limit)
                    ->get(),
                'label' => 'LISTA',
                'icon' => 'fa-list-check',
                'badge' => 'purple',
                'url' => fn () => route('lists.index'),
                'subtitle' => fn ($row) => ($row->status === 'active' ? 'Activa' : 'Archivada').' · '.$row->items_count.' artículos',
            ],
            [
                'rows' => Product::query()
                    ->where('user_id', $userId)
                    ->where('name', 'like', $like)
                    ->with(['category', 'store'])
                    ->orderBy('name')
                    ->limit($limit)
                    ->get(),
                'label' => 'PRODUCTO',
                'icon' => 'fa-box',
                'badge' => 'blue',
                'url' => fn () => route('products.index'),
                'subtitle' => fn ($row) => collect([
                    $row->category?->name,
                    $row->store?->name,
                    $row->price !== null ? number_format((float) $row->price, 2) : null,
                ])->filter()->implode(' · ') ?: 'Sin detalles',
            ],
            [
                'rows' => Store::query()
                    ->where('user_id', $userId)
                    ->where('name', 'like', $like)
                    ->orderBy('name')
                    ->limit($limit)
                    ->get(),
                'label' => 'NEGOCIO',
                'icon' => 'fa-store',
                'badge' => 'purple',
                'url' => fn () => route('stores.index'),
                'subtitle' => fn () => 'Negocio guardado',
            ],
            [
                'rows' => Category::query()
                    ->where('user_id', $userId)
                    ->where('name', 'like', $like)
                    ->orderBy('name')
                    ->limit($limit)
                    ->get(),
                'label' => 'CATEGORÍA',
                'icon' => 'fa-tags',
                'badge' => 'green',
                'url' => fn () => route('categories.index'),
                'subtitle' => fn () => 'Categoría de productos',
            ],
            [
                'rows' => Unit::query()
                    ->where('user_id', $userId)
                    ->where('name', 'like', $like)
                    ->orderBy('name')
                    ->limit($limit)
                    ->get(),
                'label' => 'UNIDAD',
                'icon' => 'fa-scale-balanced',
                'badge' => 'orange',
                'url' => fn () => route('units.index'),
                'subtitle' => fn () => 'Unidad de medida',
            ],
            [
                'rows' => ListItem::query()
                    ->where('name', 'like', $like)
                    ->whereHas('shoppingList', fn ($q) => $q->where('user_id', $userId))
                    ->with('shoppingList')
                    ->orderBy('name')
                    ->limit($limit)
                    ->get(),
                'label' => 'ARTÍCULO',
                'icon' => 'fa-cart-shopping',
                'badge' => 'teal',
                'url' => fn () => route('lists.index'),
                'subtitle' => fn ($row) => 'Lista: '.$row->shoppingList?->name,
            ],
        ];

        foreach ($sources as $source) {
            foreach ($source['rows'] as $row) {
                if (count($results) >= $limit) {
                    break 2;
                }

                $results[] = [
                    'type' => $source['label'],
                    'icon' => $source['icon'],
                    'badge' => $source['badge'],
                    'title' => $row->name,
                    'subtitle' => $source['subtitle']($row),
                    'url' => $source['url']($row),
                ];
            }
        }

        return response()->json(['data' => $results]);
    }
}
