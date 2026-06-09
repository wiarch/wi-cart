<?php

namespace App\Providers;

use App\Models\ListItem;
use App\Models\ShoppingList;
use Illuminate\Support\Facades\Route;
use Illuminate\Support\Facades\View;
use Illuminate\Support\ServiceProvider;

class AppServiceProvider extends ServiceProvider
{
    public function register(): void
    {
        //
    }

    public function boot(): void
    {
        Route::bind('list', fn (string $value) => ShoppingList::findOrFail($value));
        Route::bind('item', fn (string $value) => ListItem::findOrFail($value));

        View::composer('layouts.app', function ($view) {
            if (auth()->check()) {
                $view->with([
                    'catalogCategories' => auth()->user()->categories()->orderBy('name')->get(),
                    'catalogUnits' => auth()->user()->units()->orderBy('name')->get(),
                    'catalogStores' => auth()->user()->stores()->orderBy('name')->get(),
                ]);
            }
        });
    }
}
