<?php

use Illuminate\Support\Facades\Route;

// ==============================
// CONTROLADORES PRINCIPALES
// ==============================
use App\Http\Controllers\Auth\LoginController;
use App\Http\Controllers\Auth\RegisterController;
use App\Http\Controllers\HomeController;
use App\Http\Controllers\DashboardController;
use App\Http\Controllers\BatchController;
use App\Http\Controllers\FieldController;
use App\Http\Controllers\RodeoController;
use App\Http\Controllers\StockController;
use App\Http\Controllers\GrazingController;
use App\Http\Controllers\EventController;
use App\Http\Controllers\VeterinarySuppliesController;
use App\Http\Controllers\HerdWeighigsController;
use App\Http\Controllers\ReasonController;
use App\Http\Controllers\TerminationController;

// ==============================
// CONTROLADORES AJAX
// ==============================
use App\Http\Controllers\Ajax\AjaxController;
use App\Http\Controllers\Ajax\AjaxDatatablesController;
use App\Http\Controllers\Ajax\AjaxSelectController;
use App\Http\Controllers\SupplieController;
use Egulias\EmailValidator\Result\Reason\Reason;

// =====================================================
// RUTAS BÁSICAS Y DE UTILIDAD
// =====================================================

// Endpoint temporal de ejemplo para Select2 vacío
Route::get('select2', function () {
    return [
        [
            'id' => 0,
            'name' => 'Sin Datos',
        ],
    ];
})->name('select2');

// Página principal (home)
Route::get('/', [HomeController::class, 'index'])->name('home');


// =====================================================
// AUTENTICACIÓN Y REGISTRO
// =====================================================

// Mostrar formulario de inicio de sesión
Route::get('auth', [LoginController::class, 'showLoginForm'])->name('auth.form');

// Iniciar sesión
Route::post('login', [LoginController::class, 'login'])->name('login');

// Verificación de cuenta
Route::get('login/verify/{email}', [LoginController::class, 'verify'])->name('login.verify');
Route::get('login/verify/resend/{email}', [LoginController::class, 'resend'])->name('login.verify.resend');

// Cerrar sesión
Route::get('logout', [LoginController::class, 'logout'])->name('logout');

// Registro de usuarios
Route::post('register', [RegisterController::class, 'register'])->name('register');


// =====================================================
// ÁREA PRIVADA (DASHBOARD) - REQUIERE AUTENTICACIÓN
// =====================================================

Route::middleware('auth.verify')
    ->prefix('dashboard')
    ->group(function () {

        // Panel principal
        Route::get('/client', [DashboardController::class, 'dashboard'])->name('dashboard');

        // Recursos principales
        Route::resource('batches', BatchController::class);
        Route::resource('fields', FieldController::class);
        Route::resource('rodeos', RodeoController::class);
        Route::resource('stocks', StockController::class);
        Route::resource('grazings', GrazingController::class);
        Route::resource('supplies', SupplieController::class);
        Route::resource('veterinary-supplies', VeterinarySuppliesController::class);
                Route::resource('herd-weighings', HerdWeighigsController::class)->only(['index']);
        Route::resource('reasons', ReasonController::class);
        Route::resource('terminations', TerminationController::class);

        // =====================
        // STOCKS (Operaciones)
        // =====================
        Route::get('transfer/stock/{id?}', [StockController::class, 'transfer'])->name('stocks.transfer');
        Route::get('transfer-all/stock', [StockController::class, 'transferAll'])->name('stocks.transfer.all');
        Route::put('move/stock/{id?}', [StockController::class, 'move'])->name('stocks.move');
        Route::get('export-stocks', [StockController::class, 'exportStocks'])->name('stocks.export');
        Route::post('import-stocks', [StockController::class, 'importStocks'])->name('stocks.import');
        Route::get('stocks-reunion', [StockController::class, 'stocksReunion'])->name('stocks-reunion.index');

        // =====================
        // EVENTOS
        // =====================
        Route::resource('events', EventController::class);

        // Logs de eventos
        Route::get('events/logs/list', [EventController::class, 'logs'])->name('events.logs.list');
        Route::get('events/logs/list/{id}', [EventController::class, 'logsShow'])->name('events.logs.list.show');

        // Tipos de eventos
        Route::get('events/reproductions/list', [EventController::class, 'reproductions'])->name('events.reproductions.list');
        Route::get('export-reproductions', [EventController::class, 'exportReproductions'])->name('reproductions.export');
        Route::post('import-reproductions', [EventController::class, 'importReproductions'])->name('reproductions.import');
        Route::get('events/sanitary/list', [EventController::class, 'sanitary'])->name('events.sanitary.list');
        Route::get('events/deaths/list', [EventController::class, 'deaths'])->name('events.deaths.list');
        Route::get('events/feedings/list', [EventController::class, 'feedings'])->name('events.feedings.list');

        // =====================
        // BATCHES (Lotes)
        // =====================
        Route::get('supplies/get/batches', [SupplieController::class, 'getBatches'])->name('supplies.get.batches');
    });


// =====================================================
// RUTAS AJAX (Petición directa desde JS)
// =====================================================

Route::prefix('ajax')->group(function () {

    // Obtener datos relacionados (según usuario o entidad)
    Route::get('get/fields/{id}', [AjaxController::class, 'getFields'])->name('ajax.get.fields.user');
    Route::get('get/rodeos/{id}', [AjaxController::class, 'getRodeos'])->name('ajax.get.rodeos.user');
    Route::get('get/stocks/{id}', [AjaxController::class, 'getStocks'])->name('ajax.get.stocks.user');
    Route::get('get/batches/{id}', [AjaxController::class, 'getBatches'])->name('ajax.get.batches.user');
    Route::get('get/forage_resources/{id}', [AjaxController::class, 'getForageResources'])->name('ajax.get.forage_resources.region');
    // unificado
    Route::get('get/regions', [AjaxController::class, 'getRegions'])->name('ajax.get.regions');

    // Catálogos generales
    Route::get('get/animal_breeds', [AjaxController::class, 'getAnimalBreeds'])->name('ajax.get.animal_breeds');
    Route::get('get/services', [AjaxController::class, 'getServices'])->name('ajax.get.services');
});


// =====================================================
// RUTAS AJAX PARA DATATABLES
// =====================================================

Route::prefix('ajax/datatables')->group(function () {

    // Recursos base (según usuario)
    Route::get('get/batches/user', [AjaxDatatablesController::class, 'getBatchesUser'])->name('ajax.datatables.batches.user');
    Route::get('get/fields/user', [AjaxDatatablesController::class, 'getFieldsUser'])->name('ajax.datatables.fields.user');
    Route::get('get/rodeos/user', [AjaxDatatablesController::class, 'getRodeosUser'])->name('ajax.datatables.rodeos.user');
    Route::get('get/stocks/user', [AjaxDatatablesController::class, 'getStocksUser'])->name('ajax.datatables.stocks.user');
    Route::get('get/grazings/user', [AjaxDatatablesController::class, 'getGrazingsUser'])->name('ajax.datatables.grazings.user');
    Route::get('get/stocks-reunion/user', [AjaxDatatablesController::class, 'getStocksReunionUser'])->name('ajax.datatables.stocks-reunion.user');
        Route::get('get/herd-weighings/user', [AjaxDatatablesController::class, 'getHerdWeighingsUser'])->name('ajax.datatables.herd_weighings.user');
    Route::get('get/reasons/user', [AjaxDatatablesController::class, 'getReasonsUser'])->name('ajax.datatables.reasons.user');
    Route::get('get/terminations/user', [AjaxDatatablesController::class, 'getTerminationsUser'])->name('ajax.datatables.terminations.user');

    Route::get('get/supplies/user', [AjaxDatatablesController::class, 'getSuppliesUser'])->name('ajax.datatables.supplies.user');
    Route::get('get/veterinary-supplies/user', [AjaxDatatablesController::class, 'getVeterinarySuppliesUser'])->name('ajax.datatables.veterinary_supplies.user');

    // Logs
    Route::get('get/logs/module', [AjaxDatatablesController::class, 'getLogsModule'])->name('ajax.datatables.events.logs.module');

    // Tipos de eventos
    Route::get('get/reproduction', [AjaxDatatablesController::class, 'getReproduction'])->name('ajax.datatables.events.reproductions');
    Route::get('get/sanitary', [AjaxDatatablesController::class, 'getSanitary'])->name('ajax.datatables.events.sanitary');
    Route::get('get/deaths', [AjaxDatatablesController::class, 'getDeaths'])->name('ajax.datatables.events.deaths');
    Route::get('get/feedings', [AjaxDatatablesController::class, 'getFeedings'])->name('ajax.datatables.events.feedings');
});


// =====================================================
// RUTAS AJAX PARA SELECT2 (BÚSQUEDAS DINÁMICAS)
// =====================================================

Route::prefix('ajax/select')->group(function () {

    // Rodeos y stocks dinámicos
    Route::get('search/rodeos/user', [AjaxSelectController::class, 'searchRodeos'])->name('ajax.select.rodeos.user');
    Route::get('search/stocks/user', [AjaxSelectController::class, 'searchStocks'])->name('ajax.select.stocks.user');
    Route::get('search/stocks/rodeos/{id}', [AjaxSelectController::class, 'searchStocksRodeos'])->name('ajax.select.stocks.rodeo');
    Route::get('search/treatment-codes', [AjaxSelectController::class, 'searchTreatmentCodes'])->name('ajax.select.treatment_codes');
});
