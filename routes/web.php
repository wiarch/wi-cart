<?php

use Illuminate\Support\Facades\Route;
use Illuminate\Support\Facades\Auth;

use App\Http\Controllers\CategoryController;
use App\Http\Controllers\UnitController;
use App\Http\Controllers\StoreController;

Route::get('/', function () {
    if (Auth::check()) {
        return redirect()->route('dashboard');
    }
    return redirect()->route('login');
});

Route::middleware(['auth', 'verified'])->group(function () {
    Route::get('/dashboard', function () {
        return view('dashboard');
    })->name('dashboard');

    Route::get('/categories-data', [CategoryController::class, 'getData'])->name('categories.data');
    Route::get('/units-data', [UnitController::class, 'getData'])->name('units.data');
    Route::get('/stores-data', [StoreController::class, 'getData'])->name('stores.data');

    Route::resource('categories', CategoryController::class);
    Route::resource('units', UnitController::class);
    Route::resource('stores', StoreController::class);

    Route::get('/settings', function () {
        return view('settings');
    })->name('settings');
});

require __DIR__.'/auth.php';
