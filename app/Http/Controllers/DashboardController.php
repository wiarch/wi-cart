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

class DashboardController extends Controller
{
    public function index(Request $request): View
    {
        $userId = $request->user()->id;
        $status = $request->get('status');

        $listsQuery = ShoppingList::query()->where('user_id', $userId);
        if (in_array($status, ['active', 'archived'], true)) {
            $listsQuery->where('status', $status);
        }

        $stats = [
            'active_lists' => ShoppingList::where('user_id', $userId)->where('status', 'active')->count(),
            'archived_lists' => ShoppingList::where('user_id', $userId)->where('status', 'archived')->count(),
            'pending_items' => ListItem::whereHas('shoppingList', fn ($q) => $q->where('user_id', $userId))
                ->where('is_checked', false)->count(),
            'stores' => Store::where('user_id', $userId)->count(),
            'categories' => Category::where('user_id', $userId)->count(),
            'units' => Unit::where('user_id', $userId)->count(),
            'products' => Product::where('user_id', $userId)->count(),
            'budget' => ListItem::whereHas('shoppingList', fn ($q) => $q->where('user_id', $userId))
                ->where('is_checked', false)
                ->selectRaw('COALESCE(SUM(price * quantity), 0) as total')
                ->value('total'),
        ];

        $recentLists = (clone $listsQuery)
            ->withCount(['items', 'items as pending_items_count' => fn ($q) => $q->where('is_checked', false)])
            ->latest('updated_at')
            ->take(5)
            ->get();

        return view('dashboard', compact('stats', 'recentLists', 'status'));
    }
}
