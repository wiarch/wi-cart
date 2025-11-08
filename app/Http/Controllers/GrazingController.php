<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;
use App\Traits\ValidateFormTrait;
use App\Traits\CharIdTrait;
use App\Traits\RuleArrayTrait;

class GrazingController extends Controller
{
    use ValidateFormTrait;
    use CharIdTrait;
    use RuleArrayTrait;

    protected $DB_admin;

    public function __construct()
    {
        // Se ejecuta al instanciar el controlador
        $this->DB_admin = config('database.connections.mysql_admin.database');
    }

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

            $regions = DB::connection('mysql_admin')->table('regions')->select('id', 'name')->get();

            $type_grazings = DB::connection('mysql_admin')->table('type_grazings')->select('id', 'name', 'value')->get();


            return view('grazings.index', compact('rodeos', 'regions', 'type_grazings'));
        } catch (\Throwable $th) {
            Log::error('GrazingController - index -> Error: ' . $th->getMessage());
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
            dd('test');
        } catch (\Throwable $th) {
            Log::error('GrazingController - create -> Error: ' . $th->getMessage());
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
            Log::error('GrazingController - show -> Error: ' . $th->getMessage());
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
     * Edita un evento según su tipo.
     */
    public function edit($id)
    {
        // try {
        $data = DB::table('grazings')->where('id', $id)->first();

        $type_grazings = DB::connection('mysql_admin')->table('type_grazings')->select('id', 'name', 'value')->get();

        $div = '#edit_modal_content_grazing';

        return response()->json([
            'html' => view('grazings.partials.modals.components.edit', compact('data', 'type_grazings'))->render(),
            'div' => $div,
        ]);
        // } catch (\Throwable $th) {
        //     Log::error('GrazingController - edit -> Error: ' . $th->getMessage());
        //     return response()->view(
        //         'layouts.partials.misc.error_500',
        //         [
        //             'exception' => $th,
        //         ],
        //         500,
        //     );
        // }
    }

    /**
     * Funcion para crear.
     */
    public function store(Request $request)
    {
        try {
            // Validación de campos individuales
            $validation = [
                ...$this->rulesArray('rodeo_id', ['required'], 'Rodeo', false),
                ...$this->rulesArray('region_id', ['required'], 'Región', false),
                ...$this->rulesArray('forage_resource_id', ['required'], 'Base de recurso', false),
                ...$this->rulesArray('input_date', ['required', 'date'], 'Fecha de Entrada', false),
                ...$this->rulesArray('output_date', ['nullable', 'date', 'after_or_equal:input_date'], 'Fecha de Salida', false),
            ];

            // Validar entrada
            if ($response = $this->validateFormInput($request, $validation, 'Pastoreo no registrado')) {
                return $response;
            }

            $values = [
                'id' => $this->generateUniqueCharId('grazings', 'id'),
                'user_id' => session()->get('user')->id,
                'rodeo_id' => $request->rodeo_id,
                'region_id' => $request->region_id,
                'forage_resource_id' => $request->forage_resource_id,
                'grazing_id' => $request->grazing_id,
                'input_date' => $request->input_date ?? null,
                'output_date' => $request->output_date ?? null,
                'created_at' => now(),
                'updated_at' => now(),
            ];

            DB::table('grazings')->insert($values);

            return response()->json([
                'title' => 'Pastoreo Guardado',
                'text' => 'El registro de pastoreo fue creado correctamente.',
                'reload' => false,
            ]);
        } catch (\Throwable $th) {
            Log::error('GrazingController - store -> Error: ' . $th->getMessage());
            return response()->view('layouts.partials.misc.error_500', ['exception' => $th], 500);
        }
    }


    /**
     * Actualiza un evento según su tipo.
     */
    public function update(Request $request, $id)
    {
        try {
            $validation = [
                ...$this->rulesArray('grazing_id', ['required'], 'Tipo de Pastoreo', false),
                ...$this->rulesArray('input_date', ['required', 'date'], 'Fecha de Entrada', false),
                ...$this->rulesArray('output_date', ['nullable', 'date', 'after_or_equal:input_date'], 'Fecha de Salida', false),
            ];

            // Validar la entrada con el trait
            if ($response = $this->validateFormInput($request, $validation, 'Pastoreo no actualizado')) {
                return $response;
            }

            // Valores a actualizar
            $values = [
                'grazing_id' => $request->grazing_id,
                'input_date' => $request->input_date,
                'output_date' => $request->output_date,
                'updated_at' => now(),
            ];

            DB::table('grazings')->where('id', $id)->update($values);

            return response()->json([
                'title' => 'Pastoreo Actualizado',
                'text' => 'El pastoreo fue actualizado correctamente.',
                'reload' => false,
            ]);
        } catch (\Throwable $th) {
            Log::error('GrazingController - update -> Error: ' . $th->getMessage());
            return response()->view('layouts.partials.misc.error_500', ['exception' => $th], 500);
        }
    }


    /**
     * Función para eliminar un campo por su ID.
     */
    public function destroy($id)
    {
        try {
            $deleted = DB::table('grazings')->where('id', $id)->delete();

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
                'title' => 'Pastoreo eliminado',
                'text' => 'El registro fue eliminado correctamente.',
                'reload' => false,
            ]);
        } catch (\Throwable $th) {
            Log::error('GrazingController - destroy -> Error: ' . $th->getMessage());
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
