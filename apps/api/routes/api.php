<?php

use App\Http\Controllers\AuthController;
use App\Http\Controllers\ListShareController;
use App\Http\Controllers\ProductImageController;
use App\Http\Controllers\SyncController;
use Illuminate\Support\Facades\Route;

Route::post('/auth/google', [AuthController::class, 'google']);

Route::middleware('auth:sanctum')->group(function () {
    Route::post('/logout', [AuthController::class, 'logout']);
    Route::get('/me', [AuthController::class, 'me']);

    Route::post('/sync', [SyncController::class, 'sync']);
    Route::post('/sync/push', [SyncController::class, 'push']);
    Route::get('/sync/pull', [SyncController::class, 'pull']);

    Route::post('/uploads/product-image', [ProductImageController::class, 'store']);
    Route::post('/lists/{listId}/share', [ListShareController::class, 'store']);
    Route::post('/stores/{storeId}/share', [ListShareController::class, 'shareStore']);
});
