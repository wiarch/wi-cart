<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Api\AuthController;
use App\Http\Controllers\Api\DatatablesController;
use App\Http\Controllers\Api\EventController;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Aquí se definen las rutas de la API para autenticación y acceso a datos.
| Se agrupan por prefijos y middleware para mayor claridad y seguridad.
|
*/

/**
 * RUTAS DE AUTENTICACIÓN
 * Prefijo: /auth
 */
Route::prefix('auth')->group(function () {
    // Login de usuario vía API
    Route::post('login', [AuthController::class, 'login'])->name('app.login');
});

Route::middleware('auth.api')
    ->group(function () {
        Route::get('data/user', [DatatablesController::class, 'getData'])->name('data.user');
        Route::post('deaths', [EventController::class, 'deaths']);
        Route::post('feedings', [EventController::class, 'feedings']);
        Route::post('sanitary', [EventController::class, 'sanitary']);
    });
