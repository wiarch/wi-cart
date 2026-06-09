<?php

use App\Http\Controllers\AnalyticsController;
use App\Http\Controllers\CategoryController;
use App\Http\Controllers\DashboardController;
use App\Http\Controllers\ListItemController;
use App\Http\Controllers\ProductController;
use App\Http\Controllers\SearchController;
use App\Http\Controllers\SettingsController;
use App\Http\Controllers\ShoppingListController;
use App\Http\Controllers\StoreController;
use App\Http\Controllers\UnitController;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Route;

Route::get('/', function () {
    if (Auth::check()) {
        return redirect()->route('dashboard');
    }

    return redirect()->route('login');
});

Route::middleware(['auth', 'verified'])->group(function () {
    Route::get('/dashboard', [DashboardController::class, 'index'])->name('dashboard');
    Route::get('/search', SearchController::class)->name('search');
    Route::get('/analytics', [AnalyticsController::class, 'index'])->name('analytics.index');

    Route::get('/lists-data', [ShoppingListController::class, 'getData'])->name('lists.data');
    Route::resource('lists', ShoppingListController::class)->except(['create', 'edit']);

    Route::get('/lists/{list}/items', [ListItemController::class, 'index'])->name('lists.items.index');
    Route::post('/lists/{list}/items', [ListItemController::class, 'store'])->name('lists.items.store');
    Route::put('/lists/{list}/items/{item}', [ListItemController::class, 'update'])->name('lists.items.update');
    Route::delete('/lists/{list}/items/{item}', [ListItemController::class, 'destroy'])->name('lists.items.destroy');

    Route::get('/products-data', [ProductController::class, 'getData'])->name('products.data');
    Route::resource('products', ProductController::class)->except(['create', 'edit']);

    Route::get('/categories-data', [CategoryController::class, 'getData'])->name('categories.data');
    Route::resource('categories', CategoryController::class)->except(['create', 'edit']);

    Route::get('/units-data', [UnitController::class, 'getData'])->name('units.data');
    Route::resource('units', UnitController::class)->except(['create', 'edit']);

    Route::get('/stores-data', [StoreController::class, 'getData'])->name('stores.data');
    Route::resource('stores', StoreController::class)->except(['create', 'edit']);

    Route::get('/settings', [SettingsController::class, 'index'])->name('settings');
    Route::put('/settings/profile', [SettingsController::class, 'updateProfile'])->name('settings.profile');
});

require __DIR__.'/auth.php';
