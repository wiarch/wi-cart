<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;
use App\Traits\ValidateFormTrait;
use App\Traits\CharIdTrait;
use App\Traits\RuleArrayTrait;
use Illuminate\Support\Str;

class RodeoController extends Controller
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

            $regions = DB::connection('mysql_admin')->table('regions')->select('id', 'name')->get();

            $services = DB::connection('mysql_admin')->table('services')->select('id', 'name', 'description')->get();

            $animalBreeds = DB::connection('mysql_admin')->table('animal_breeds')->select('id', 'name')->get();

            return view('rodeos.index', compact('fields', 'regions', 'services', 'animalBreeds'));
        } catch (\Throwable $th) {
            Log::error('RodeoController - index -> Error: ' . $th->getMessage());
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
            Log::error('RodeoController - create -> Error: ' . $th->getMessage());
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
            Log::error('RodeoController - show -> Error: ' . $th->getMessage());
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
            $data = DB::connection('mysql_admin')->table('rodeos')->where('id', $id)->first();

            $fields = DB::connection('mysql_admin')
                ->table('fields')
                ->where('user_id', session()->get('user')->id)
                ->select('id', 'name')
                ->get();

            $batches = DB::connection('mysql_admin')->table('batches')->where('field_id', $data->field_id)->select('id', 'name')->get();

            $regions = DB::connection('mysql_admin')->table('regions')->select('id', 'name')->get();

            $services = DB::connection('mysql_admin')->table('services')->select('id', 'name', 'description')->get();

            $animalBreeds = DB::connection('mysql_admin')->table('animal_breeds')->select('id', 'name')->get();

            $div = '#edit_modal_content_rodeo';

            return response()->json([
                'html' => view('rodeos.partials.modals.components.edit', compact('data', 'fields', 'batches', 'regions', 'services', 'animalBreeds'))->render(),
                'div' => $div,
            ]);
        } catch (\Throwable $th) {
            Log::error('RodeoController - edit -> Error: ' . $th->getMessage());
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
            // Definición de reglas de validación para los nuevos arrays
            $validation = [...$this->rulesArray('rodeo', ['required', 'string', 'max:100'], 'Nombre del rodeo', true, count($request->input('rodeo', []))), ...$this->rulesArray('field', ['required', 'string', 'max:100', 'not_in:null'], 'Campo', true, count($request->input('field', []))), ...$this->rulesArray('batch', ['required', 'string', 'max:100', 'not_in:null', 'not_in:0', 'distinct'], 'Lote', true, count($request->input('batch', []))), ...$this->rulesArray('region', ['required', 'string', 'max:100', 'not_in:null'], 'Región', true, count($request->input('region', []))), ...$this->rulesArray('service', ['required', 'string', 'max:100', 'not_in:null'], 'Servicio', true, count($request->input('service', []))), ...$this->rulesArray('animal_breed', ['required', 'string', 'max:100', 'not_in:null'], 'Raza animal', true, count($request->input('animal_breed', [])))];

            // Validar la entrada con el trait personalizado
            if ($response = $this->validateFormInput($request, $validation, 'Rodeo no registrado')) {
                return $response;
            }

            $userId = session()->get('user')->id;
            $rodeos = $request->rodeo ?? [];
            $total = count($rodeos);

            for ($i = 0; $i < $total; $i++) {
                $name = trim($request->rodeo[$i] ?? null);

                // Verificar nombre único por usuario
                $existsName = DB::connection('mysql_admin')->table('rodeos')->where('user_id', $userId)->where('name', $name)->exists();

                if ($existsName) {
                    return response()->json([
                        'title' => 'Rodeo no registrado',
                        'error' => "Ya existe un rodeo con el nombre '{$name}' para este usuario.",
                    ]);
                }

                // Generar slug base
                $slug = Str::slug($name);

                // Asegurar que el slug sea único para este usuario
                $originalSlug = $slug;
                $counter = 1;
                while (DB::connection('mysql_admin')->table('rodeos')->where('user_id', $userId)->where('slug', $slug)->exists()) {
                    $slug = $originalSlug . '-' . $counter;
                    $counter++;
                }

                $values = [
                    'id' => $this->generateUniqueCharId('rodeos', 'id', 'mysql_admin'),
                    'name' => $name,
                    'slug' => $slug,
                    'field_id' => $request->field[$i] ?? null,
                    'batch_id' => $request->batch[$i] ?? null,
                    'region_id' => $request->region[$i] ?? null,
                    'service_id' => $request->service[$i] ?? null,
                    'animal_breed_id' => $request->animal_breed[$i] ?? null,
                    'user_id' => $userId,
                    'created_at' => now(),
                ];

                DB::connection('mysql_admin')->table('rodeos')->insert($values);

                // Actualizar batch con rodeo
                DB::connection('mysql_admin')
                    ->table('batches')
                    ->where('id', $request->batch[$i] ?? null)
                    ->update([
                        'rodeo_id' => $values['id'],
                    ]);
            }

            return response()->json([
                'title' => 'Rodeos Guardados',
                'text' => 'Los rodeos fueron guardados correctamente.',
                'reload' => false,
            ]);
        } catch (\Throwable $th) {
            Log::error('RodeoController - store -> Error: ' . $th->getMessage());
            return response()->view('layouts.partials.misc.error_500', ['exception' => $th], 500);
        }
    }
    /**
     * Funcion para actualizar.
     */

    public function update(Request $request, $id)
    {
        try {
            // Definición de reglas de validación para los campos editados
            $validation = [...$this->rulesArray('edit_rodeo', ['required', 'string', 'max:100'], 'Nombre del rodeo', false), ...$this->rulesArray('edit_field', ['required', 'string', 'max:100'], 'Campo', false), ...$this->rulesArray('edit_batch', ['required', 'string', 'max:100'], 'Lote', false), ...$this->rulesArray('edit_region', ['required', 'string', 'max:100'], 'Región', false), ...$this->rulesArray('edit_service', ['required', 'string', 'max:100'], 'Servicio', false), ...$this->rulesArray('edit_animal_breed', ['required', 'string', 'max:100'], 'Raza animal', false)];

            // Validar la entrada con el trait personalizado
            if ($response = $this->validateFormInput($request, $validation, 'Rodeo no actualizado')) {
                return $response;
            }

            $userId = session()->get('user')->id;
            $name = trim($request->edit_rodeo);

            // Validar nombre único por usuario
            $existsName = DB::connection('mysql_admin')->table('rodeos')->where('user_id', $userId)->where('name', $name)->where('id', '<>', $id)->exists();

            if ($existsName) {
                return response()->json([
                    'title' => 'Rodeo no actualizado',
                    'error' => "Ya existe un rodeo con el nombre '{$name}' para este usuario.",
                    'reload' => false,
                ]);
            }

            // Generar slug base
            $slug = Str::slug($name);

            // Asegurar que el slug sea único por usuario, ignorando el registro actual
            $originalSlug = $slug;
            $counter = 1;
            while (DB::connection('mysql_admin')->table('rodeos')->where('user_id', $userId)->where('slug', $slug)->where('id', '<>', $id)->exists()) {
                $slug = $originalSlug . '-' . $counter;
                $counter++;
            }

            // Preparar datos para actualización
            $values = [
                'name' => $name,
                'slug' => $slug,
                'field_id' => $request->edit_field,
                'batch_id' => $request->edit_batch,
                'region_id' => $request->edit_region,
                'service_id' => $request->edit_service,
                'animal_breed_id' => $request->edit_animal_breed,
                'updated_at' => now(),
            ];

            // Actualizar registro en la tabla rodeos
            DB::connection('mysql_admin')->table('rodeos')->where('id', $id)->update($values);

            DB::connection('mysql_admin')->transaction(function () use ($request, $id) {
                // Desvincular el lote antiguo del rodeo
                DB::connection('mysql_admin')
                    ->table('batches')
                    ->where('rodeo_id', $id)
                    ->update(['rodeo_id' => null]);

                // Asignar el nuevo lote al rodeo
                DB::connection('mysql_admin')
                    ->table('batches')
                    ->where('id', $request->edit_batch)
                    ->update(['rodeo_id' => $id]);
            });

            return response()->json([
                'title' => 'Rodeo Actualizado',
                'text' => 'El rodeo fue actualizado correctamente.',
                'reload' => false,
            ]);
        } catch (\Throwable $th) {
            Log::error('RodeoController - update -> Error: ' . $th->getMessage());
            return response()->view('layouts.partials.misc.error_500', ['exception' => $th], 500);
        }
    }


    /**
     * Función para eliminar un campo por su ID.
     */
    public function destroy($id)
    {
        try {
            $deleted = DB::connection('mysql_admin')->table('rodeos')->where('id', $id)->delete();

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
                'title' => 'Campo eliminado',
                'text' => 'El registro fue eliminado correctamente.',
                'reload' => false,
            ]);
        } catch (\Throwable $th) {
            Log::error('RodeoController - destroy -> Error: ' . $th->getMessage());
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
