<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;
use App\Traits\ValidateFormTrait;
use App\Traits\CharIdTrait;
use App\Traits\RuleArrayTrait;


class BatchController extends Controller
{

    use ValidateFormTrait;
    use CharIdTrait;
    use RuleArrayTrait;

    /**
     * Muestra una lista.
     */
    public function index()
    {
        try {

            $fields = DB::connection('mysql_admin')
                ->table('fields')
                ->where('user_id', session()->get('user')->id)
                ->select('id', 'name')
                ->get();

            return view('batches.index', compact('fields'));
        } catch (\Throwable $th) {
            Log::error('BatchController - index -> Error: ' . $th->getMessage());
            return response()->view('layouts.partials.misc.error_500', [
                'exception' => $th
            ], 500);
        }
    }

    /**
     * Muestra la vista.
     */
    public function create()
    {
        try {
        } catch (\Throwable $th) {
            Log::error('BatchController - create -> Error: ' . $th->getMessage());
            return response()->view('layouts.partials.misc.error_500', [
                'exception' => $th
            ], 500);
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
            Log::error('BatchController - show -> Error: ' . $th->getMessage());
            return response()->view('layouts.partials.misc.error_500', [
                'exception' => $th
            ], 500);
        }
    }

    /**
     * Muestra la vista.
     */
    public function edit($id)
    {
        try {

            $data = DB::connection('mysql_admin')->table('batches')
                ->where('id', $id)
                ->first();

            $fields = DB::connection('mysql_admin')
                ->table('fields')
                ->where('user_id', session()->get('user')->id)
                ->select('id', 'name')
                ->get();

            $div = "#edit_modal_content_batch";

            return response()->json([
                'html' => view('batches.partials.modals.components.edit', compact('data', 'fields'))->render(),
                'div' => $div,
            ]);
        } catch (\Throwable $th) {
            Log::error('BatchController - edit -> Error: ' . $th->getMessage());
            return response()->view('layouts.partials.misc.error_500', [
                'exception' => $th
            ], 500);
        }
    }

    /**
     * Funcion para crear.
     */
    public function store(Request $request)
    {
        try {

            $validation = [
                ...$this->rulesArray('field_id', ['required'], 'Campo', false),
                ...$this->rulesArray('batch', ['required', 'string', 'max:100'], 'Nombre del lote', true, count($request->input('batch', []))),
                ...$this->rulesArray('surface', ['required', 'string', 'max:100'], 'Superficie', true, count($request->input('surface', []))),
            ];

            // Valida con tu trait
            if ($response = $this->validateFormInput($request, $validation, 'Lotes no registrado')) {
                return $response; // Aquí si falla retorna JSON con error, o redirige si adaptas trait
            }

            $batches = $request->batch ?? [];
            $total = count($batches);

            for ($i = 0; $i < $total; $i++) {
                $values = [
                    'id' => $this->generateUniqueCharId('batches', 'id', 'mysql_admin'),
                    'name' => $request->batch[$i] ?? null,
                    'surface' => $request->surface[$i] ?? null,
                    'field_id' => $request->field_id,
                    'user_id' => session()->get('user')->id,
                    'created_at' => now(),
                ];

                DB::connection('mysql_admin')->table('batches')->insert($values);
            }

            return response()->json([
                'title' => 'Lotes Guardados',
                'text' => 'Los lotes fueron guardados correctamente.',
                'reload' => false,
            ]);
        } catch (\Throwable $th) {
            Log::error('BatchController - store -> Error: ' . $th->getMessage());
            return response()->view('layouts.partials.misc.error_500', [
                'exception' => $th
            ], 500);
        }
    }

    /**
     * Funcion para actualizar.
     */
    public function update(Request $request, $id)
    {
        try {

            $validation = [
                ...$this->rulesArray('field', ['required'], 'Campo', false),
                ...$this->rulesArray('edit_batch', ['required', 'string', 'max:100'], 'Lote', false),
                ...$this->rulesArray('edit_surface', ['required', 'string', 'max:100'], 'Superficie', false),
            ];


            // Valida con tu trait
            if ($response = $this->validateFormInput($request, $validation, 'Lote no actualizado')) {
                return $response; // Aquí si falla retorna JSON con error, o redirige si adaptas trait
            }

            // Para un único registro (update simple)
            $values = [
                'name' => $request->edit_batch,
                'surface' => $request->edit_surface,
                'field_id' => $request->field,
                'updated_at' => now(),
            ];

            DB::connection('mysql_admin')->table('batches')
                ->where('id', $id)
                ->update($values);

            return response()->json([
                'title' => 'Lote Actualizado',
                'text' => 'El lote fue actualizado correctamente.',
                'reload' => false,
            ]);
        } catch (\Throwable $th) {
            Log::error('BatchController - update -> Error: ' . $th->getMessage());
            return response()->view('layouts.partials.misc.error_500', [
                'exception' => $th
            ], 500);
        }
    }

    /**
     * Función para eliminar un lote por su ID.
     */
    public function destroy($id)
    {
        try {
            $deleted = DB::connection('mysql_admin')->table('batches')->where('id', $id)->delete();

            if (!$deleted) {
                return response()->json([
                    'title' => 'Error',
                    'error' => 'No se encontró el registro o ya fue eliminado.',
                ], 404);
            }

            return response()->json([
                'title' => 'Lote eliminado',
                'text' => 'El registro fue eliminado correctamente.',
                'reload' => false,
            ]);
        } catch (\Throwable $th) {
            Log::error('BatchController - destroy -> Error: ' . $th->getMessage());
            return response()->view('layouts.partials.misc.error_500', [
                'exception' => $th
            ], 500);
        }
    }
}
