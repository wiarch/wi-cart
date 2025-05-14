<?php

use Illuminate\Support\Facades\Route;
use Illuminate\Support\Facades\Auth;
use App\Http\Controllers\settings\SettingController;

Route::get('/', function () {

    if (Auth::check()) {
        return redirect()->route('dashboard');
    }
    return view('auth.login');
})->name('home');

Route::get('dashboard', function () {
    return view('dashboard');
})->middleware(['auth', 'verified'])->name('dashboard');


// Route::get('profile', [SettingController::class, 'edit'])
//     ->middleware(['auth', 'verified'])
//     ->name('profile');

require __DIR__.'/settings.php';
require __DIR__.'/auth.php';
