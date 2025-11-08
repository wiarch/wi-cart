<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;
use App\Traits\ValidateFormTrait;
use App\Traits\CharIdTrait;
use App\Traits\RuleArrayTrait;
use Illuminate\Support\Str;

class TerminationController extends Controller
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

            $rodeos = DB::connection('mysql_admin')
                ->table('rodeos')
                ->where('user_id', session()->get('user')->id)
                ->select('id', 'name')
                ->get();

            $foods = DB::connection('mysql_admin')
                ->table('rearing_finishing_bases')
                ->select('id', 'detail')
                ->get();

            return view('terminations.index', compact('rodeos', 'foods'));
        } catch (\Throwable $th) {
            Log::error('TerminationController - index -> Error: ' . $th->getMessage());
            return response()->view(
                'layouts.partials.misc.error_500',
                [
                    'exception' => $th,
                ],
                500,
            );
        }
    }

    /**
     * Muestra la vista.
     */
    public function create()
    {
        try {
        } catch (\Throwable $th) {
            Log::error('TerminationController - create -> Error: ' . $th->getMessage());
            return response()->view(
                'layouts.partials.misc.error_500',
                [
                    'exception' => $th,
                ],
                500,
            );
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
            Log::error('TerminationController - show -> Error: ' . $th->getMessage());
            return response()->view(
                'layouts.partials.misc.error_500',
                [
                    'exception' => $th,
                ],
                500,
            );
        }
    }

    /**
     * Muestra la vista.
     */
    public function edit($id)
    {
        try {
            $data = DB::table('terminations')->where('id', $id)->first();

            $div = '#edit_modal_content_termination';

            return response()->json([
                'html' => view('terminations.partials.modals.components.edit', compact('data'))->render(),
                'div' => $div,
            ]);
        } catch (\Throwable $th) {
            Log::error('TerminationController - edit -> Error: ' . $th->getMessage());
            return response()->view(
                'layouts.partials.misc.error_500',
                [
                    'exception' => $th,
                ],
                500,
            );
        }
    }

    /**
     * Funcion para crear.
     */
    public function store(Request $request)
    {
        try {
            // Validación base (usando tu trait)
            $validation = [
                ...$this->rulesArray('reason_name', ['required', 'string'], 'Nombre de alimentación', false),
                ...$this->rulesArray('type', ['required'], 'Tipo', false),
                ...$this->rulesArray('date', ['required'], 'Fecha', false),
                ...$this->rulesArray('cms', ['required'], 'CMS', false),
                ...$this->rulesArray('pv', ['required'], 'PV', false),
                ...$this->rulesArray('gdp', ['required'], 'GPD en KG', false),
                ...$this->rulesArray('animals', ['required'], 'Animales', false),
                ...$this->rulesArray('days', ['required'], 'Dias', false),
            ];

            if ($response = $this->validateFormInput($request, $validation, 'Registro no creado')) {
                return $response;
            }

            $userId = session()->get('user')->id;

            // Insertar registro
            DB::table('terminations')->insert([
                'id' => $this->generateUniqueCharId('terminations', 'id'),
                'user_id' => $userId,
                'reason_name' => $request->reason_name,
                'type' => $request->type,
                'date' => $request->date,
                'cms' => $request->cms,
                'pv' => $request->pv,
                'gdp' => $request->gdp,
                'animals' => $request->animals,
                'days' => $request->days,
                'created_at' => now(),
                'updated_at' => now(),
            ]);

            return response()->json([
                'title' => 'Registro creado',
                'text' => 'El registro fue guardado correctamente.',
                'reload' => false,
            ]);
        } catch (\Throwable $th) {
            Log::error('TerminationController - store -> Error: ' . $th->getMessage());
            return response()->json([
                'title' => 'Error',
                'error' => $th->getMessage(),
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
                ...$this->rulesArray('edit_reason_name', ['required', 'string'], 'Nombre de alimentación', false),
                ...$this->rulesArray('edit_type', ['required'], 'Tipo', false),
                ...$this->rulesArray('edit_date', ['required'], 'Fecha', false),
                ...$this->rulesArray('edit_cms', ['required'], 'CMS', false),
                ...$this->rulesArray('edit_pv', ['required'], 'PV', false),
                ...$this->rulesArray('edit_gdp', ['required'], 'GPD en KG', false),
                ...$this->rulesArray('edit_animals', ['required'], 'Animales', false),
                ...$this->rulesArray('edit_days', ['required'], 'Dias', false)
            ];

            // Validar la entrada con el trait
            if ($response = $this->validateFormInput($request, $validation, 'Registro no actualizado')) {
                return $response;
            }

            // Valores a actualizar
            $values = [
                'reason_name' => $request->edit_reason_name,
                'type' => $request->edit_type,
                'date' => $request->edit_date,
                'cms' => $request->edit_cms,
                'pv' => $request->edit_pv,
                'gdp' => $request->edit_gdp,
                'animals' => $request->edit_animals,
                'days' => $request->edit_days,
                'updated_at' => now(),
            ];

            DB::table('terminations')->where('id', $id)->update($values);

            return response()->json([
                'title' => 'Registro Actualizado',
                'text' => 'El registro fue actualizado correctamente.',
                'reload' => false,
            ]);
        } catch (\Throwable $th) {
            Log::error('TerminationController - update -> Error: ' . $th->getMessage());
            return response()->view('layouts.partials.misc55.error_500', ['exception' => $th], 500);
        }
    }

    /**
     * Función para eliminar un registro por su ID.
     */
    public function destroy($id)
    {
        try {
            $deleted = DB::table('terminations')->where('id', $id)->delete();

            if (!$deleted) {
                return response()->json(
                    [
                        'title' => 'Error',
                        'error' => 'No se encontró el registro o ya fue eliminado.',
                    ],
                    404,
                );
            }

            return response()->json([
                'title' => 'Ración eliminado',
                'text' => 'El registro fue eliminado correctamente.',
                'reload' => false,
            ]);
        } catch (\Throwable $th) {
            Log::error('TerminationController - destroy -> Error: ' . $th->getMessage());
            return response()->view(
                'layouts.partials.misc.error_500',
                [
                    'exception' => $th,
                ],
                500,
            );
        }
    }
}
