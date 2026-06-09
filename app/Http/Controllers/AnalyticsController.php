<?php

namespace App\Http\Controllers;

use App\Models\Category;
use App\Models\ListItem;
use App\Models\Product;
use App\Models\ShoppingList;
use App\Models\Store;
use App\Models\Unit;
use Illuminate\Http\Request;
use Illuminate\View\View;

class AnalyticsController extends Controller
{
    public function index(Request $request): View
    {
        $userId = $request->user()->id;

        $stats = [
            'total_lists' => ShoppingList::where('user_id', $userId)->count(),
            'total_items' => ListItem::whereHas('shoppingList', fn ($q) => $q->where('user_id', $userId))->count(),
            'checked_items' => ListItem::whereHas('shoppingList', fn ($q) => $q->where('user_id', $userId))->where('is_checked', true)->count(),
            'pending_items' => ListItem::whereHas('shoppingList', fn ($q) => $q->where('user_id', $userId))->where('is_checked', false)->count(),
            'estimated_total' => ListItem::whereHas('shoppingList', fn ($q) => $q->where('user_id', $userId))
                ->selectRaw('COALESCE(SUM(price * quantity), 0) as total')->value('total'),
            'products' => Product::where('user_id', $userId)->count(),
            'categories' => Category::where('user_id', $userId)->count(),
            'stores' => Store::where('user_id', $userId)->count(),
            'units' => Unit::where('user_id', $userId)->count(),
        ];

        $topCategories = ListItem::query()
            ->whereHas('shoppingList', fn ($q) => $q->where('user_id', $userId))
            ->whereNotNull('category_id')
            ->selectRaw('category_id, COUNT(*) as total')
            ->groupBy('category_id')
            ->with('category')
            ->orderByDesc('total')
            ->take(5)
            ->get();

        $recentActivity = ShoppingList::where('user_id', $userId)
            ->withCount('items')
            ->latest('updated_at')
            ->take(6)
            ->get();

        return view('analytics.index', compact('stats', 'topCategories', 'recentActivity'));
    }
}
