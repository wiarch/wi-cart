<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\Session;

// PLANTILLA PARA LOS CONTROLADORES NO BORRAR
class ResoureceController extends Controller
{
    /**
     * Muestra una lista.
     */
    public function index()
    {
        try {

            dd('test');

        } catch (\Throwable $th) {
            Log::error('index - ResoureceController -> Error: ' . $th);
            abort(403, "Ocurrio un error. Contacte con el administrador");
        }
    }

    /**
     * Muestra la vista.
     */
    public function create()
    {
        try {

            dd('test');

        } catch (\Throwable $th) {
            Log::error('create - ResoureceController -> Error: ' . $th);
            abort(403, "Ocurrio un error. Contacte con el administrador");
        }
    }

    /**
     * Muestra la vista.
     */
    public function show($id)
    {
        try {

            dd('test');

        } catch (\Throwable $th) {
            Log::error('show - ResoureceController -> Error: ' . $th);
            abort(403, "Ocurrio un error. Contacte con el administrador");
        }
    }

    /**
     * Muestra la vista.
     */
    public function edit($id)
    {
        try {

            dd('test');

        } catch (\Throwable $th) {
            Log::error('edit - ResoureceController -> Error: ' . $th);
            abort(403, "Ocurrio un error. Contacte con el administrador");
        }
    }

    /**
     * Funcion para crear.
     */
    public function store(Request $request)
    {
        try {

            dd('test');

        } catch (\Throwable $th) {
            Log::error('store - ResoureceController -> Error: ' . $th);
            abort(403, "Ocurrio un error. Contacte con el administrador");
        }
    }

    /**
     * Funcion para actualizar.
     */
    public function update(Request $request, $id)
    {
        try {

            dd('test');

        } catch (\Throwable $th) {
            Log::error('update - ResoureceController -> Error: ' . $th);
            abort(403, "Ocurrio un error. Contacte con el administrador");
        }
    }

    /**
     * Funcion para eliminar.
     */
    public function destroy($id)
    {
        try {

            dd('test');

        } catch (\Throwable $th) {
            Log::error('destroy - ResoureceController -> Error: ' . $th);
            abort(403, "Ocurrio un error. Contacte con el administrador");
        }
    }
}