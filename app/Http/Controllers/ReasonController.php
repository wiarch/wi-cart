<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;
use App\Traits\ValidateFormTrait;
use App\Traits\CharIdTrait;
use App\Traits\RuleArrayTrait;
use Illuminate\Support\Str;

class ReasonController extends Controller
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

            return view('reasons.index', compact('rodeos', 'foods'));
        } catch (\Throwable $th) {
            Log::error('ReasonController - index -> Error: ' . $th->getMessage());
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
            Log::error('ReasonController - create -> Error: ' . $th->getMessage());
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
            Log::error('ReasonController - show -> Error: ' . $th->getMessage());
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
            $data = DB::table('reasons')->where('id', $id)->first();

            $rodeos = DB::connection('mysql_admin')
                ->table('rodeos')
                ->where('user_id', session()->get('user')->id)
                ->select('id', 'name')
                ->get();

            $foods = DB::connection('mysql_admin')
                ->table('rearing_finishing_bases')
                ->select('id', 'detail')
                ->get();

            $div = '#edit_modal_content_reason';

            return response()->json([
                'html' => view('reasons.partials.modals.components.edit', compact('data', 'rodeos', 'foods'))->render(),
                'div' => $div,
            ]);
        } catch (\Throwable $th) {
            Log::error('ReasonController - edit -> Error: ' . $th->getMessage());
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
                ...$this->rulesArray('detail', ['required', 'string'], 'Detalle de la ración', false),
                ...$this->rulesArray('reason_value', ['required', 'numeric'], 'Porción', false),
                ...$this->rulesArray('rodeo_id', ['required'], 'Rodeo', false),
                ...$this->rulesArray('food_id', ['required'], 'Alimentación', false),

            ];

            if ($response = $this->validateFormInput($request, $validation, 'Ración no registrada')) {
                return $response;
            }

            $userId = session()->get('user')->id;

            // Insertar registro
            DB::table('reasons')->insert([
                'id' => $this->generateUniqueCharId('reasons', 'id'),
                'user_id' => $userId,
                'rodeo_id' => $request->rodeo_id,
                'rearing_finishing_bases_id' => $request->food_id,
                'detail' => $request->detail,
                'reason_value' => $request->reason_value,
                'created_at' => now(),
            ]);

            return response()->json([
                'title' => 'Ración registrada',
                'text' => 'La ración fue guardada correctamente.',
                'reload' => false,
            ]);
        } catch (\Throwable $th) {
            Log::error('RationController - store -> Error: ' . $th->getMessage());
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
                ...$this->rulesArray('edit_detail', ['required'], 'Detalle', false),
                ...$this->rulesArray('edit_reason_value', ['required'], 'Porción', false)
            ];

            // Validar la entrada con el trait
            if ($response = $this->validateFormInput($request, $validation, 'Ración no actualizado')) {
                return $response;
            }

            // Valores a actualizar
            $values = [
                'rodeo_id' => $request->edit_rodeo_id,
                'rearing_finishing_bases_id' => $request->edit_food_id,
                'detail' => $request->edit_detail,
                'reason_value' => $request->edit_reason_value,
                'updated_at' => now(),
            ];

            DB::table('reasons')->where('id', $id)->update($values);

            return response()->json([
                'title' => 'Ración Actualizado',
                'text' => 'El registro fue actualizado correctamente.',
                'reload' => false,
            ]);
        } catch (\Throwable $th) {
            Log::error('ReasonController - update -> Error: ' . $th->getMessage());
            return response()->view('layouts.partials.misc55.error_500', ['exception' => $th], 500);
        }
    }

    /**
     * Función para eliminar un registro por su ID.
     */
    public function destroy($id)
    {
        try {
            $deleted = DB::table('reasons')->where('id', $id)->delete();

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
            Log::error('ReasonController - destroy -> Error: ' . $th->getMessage());
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
