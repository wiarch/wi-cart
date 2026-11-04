<?php

use Illuminate\Support\Facades\Route;

Route::get('/', function () {
    return response()->json([
        'app' => 'wi-cart-api',
        'status' => 'ok',
    ]);
});
