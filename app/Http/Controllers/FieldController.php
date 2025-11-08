<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;
use App\Traits\ValidateFormTrait;
use App\Traits\CharIdTrait;
use App\Traits\RuleArrayTrait;
use Illuminate\Support\Str;

class FieldController extends Controller
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
            return view('fields.index');
        } catch (\Throwable $th) {
            Log::error('FieldController - index -> Error: ' . $th->getMessage());
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
            Log::error('FieldController - create -> Error: ' . $th->getMessage());
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
            Log::error('FieldController - show -> Error: ' . $th->getMessage());
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
            $data = DB::connection('mysql_admin')->table('fields')->where('id', $id)->first();

            $div = '#edit_modal_content_field';

            return response()->json([
                'html' => view('fields.partials.modals.components.edit', compact('data'))->render(),
                'div' => $div,
            ]);
        } catch (\Throwable $th) {
            Log::error('FieldController - edit -> Error: ' . $th->getMessage());
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
            $validation = [...$this->rulesArray('field', ['required', 'string', 'max:100'], 'Nombre del campo', true, count($request->input('field', []))), ...$this->rulesArray('location', ['required', 'string', 'max:255'], 'Ubicación', true, count($request->input('location', [])))];

            // Valida con tu trait
            if ($response = $this->validateFormInput($request, $validation, 'Campo no registrado')) {
                return $response;
            }

            $userId = session()->get('user')->id;
            $fields = $request->field ?? [];
            $total = count($fields);

            for ($i = 0; $i < $total; $i++) {
                $name = trim($request->field[$i] ?? '');
                $location = $request->location[$i] ?? null;

                if (!$name) {
                    return response()->json([
                        'title' => 'Campo no creado',
                        'error' => 'El nombre del campo no puede estar vacío.',
                    ]);
                }

                // Revisar si ya existe un campo con ese nombre para el usuario
                $existsName = DB::connection('mysql_admin')->table('fields')->where('user_id', $userId)->where('name', $name)->exists();

                if ($existsName) {
                    return response()->json([
                        'title' => 'Campo no creado',
                        'error' => "Ya existe un campo con el nombre '{$name}' para este usuario.",
                    ]);
                }

                // Generar slug
                $slug = Str::slug($name);

                // Revisar si el slug ya existe para este usuario
                $existsSlug = DB::connection('mysql_admin')->table('fields')->where('user_id', $userId)->where('slug', $slug)->exists();

                if ($existsSlug) {
                    return response()->json([
                        'title' => 'Campo no creado',
                        'error' => "El slug '{$slug}' generado para el campo ya existe para este usuario.",
                    ]);
                }

                $values = [
                    'id' => $this->generateUniqueCharId('fields', 'id', 'mysql_admin'),
                    'name' => $name,
                    'slug' => $slug,
                    'location' => $location,
                    'coordinate' => $request->coordinate[$i] ?? null,
                    'user_id' => $userId,
                    'created_at' => now(),
                ];

                DB::connection('mysql_admin')->table('fields')->insert($values);
            }

            return response()->json([
                'title' => 'Campos Guardados',
                'text' => 'Los campos fueron guardados correctamente.',
                'reload' => false,
            ]);
        } catch (\Throwable $th) {
            Log::error('FieldController - store -> Error: ' . $th->getMessage());
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
            $validation = [...$this->rulesArray('edit_name', ['required', 'string', 'max:100'], 'Nombre del campo', false), ...$this->rulesArray('edit_location', ['required', 'string', 'max:255'], 'Ubicación', false)];

            // Validar la entrada con el trait
            if ($response = $this->validateFormInput($request, $validation, 'Campo no actualizado')) {
                return $response;
            }

            $userId = session()->get('user')->id;
            $name = trim($request->edit_name);
            $location = $request->edit_location;

            // Revisar si ya existe un campo con ese nombre para el usuario, excluyendo el actual
            $existsName = DB::connection('mysql_admin')->table('fields')->where('user_id', $userId)->where('name', $name)->where('id', '<>', $id)->exists();

            if ($existsName) {
                return response()->json([
                    'title' => 'Campo no actualizado',
                    'error' => "Ya existe un campo con el nombre '{$name}' para este usuario.",
                ]);
            }

            // Generar slug
            $slug = Str::slug($name);

            // Revisar si el slug ya existe para este usuario, excluyendo el actual
            $existsSlug = DB::connection('mysql_admin')->table('fields')->where('user_id', $userId)->where('slug', $slug)->where('id', '<>', $id)->exists();

            if ($existsSlug) {
                return response()->json([
                    'title' => 'Campo no actualizado',
                    'error' => "El slug '{$slug}' generado para el campo ya existe para este usuario.",
                ]);
            }

            // Valores a actualizar
            $values = [
                'name' => $name,
                'slug' => $slug,
                'location' => $location,
                'coordinate' => $request->edit_coordinate,
                'updated_at' => now(),
            ];

            DB::connection('mysql_admin')->table('fields')->where('id', $id)->update($values);

            return response()->json([
                'title' => 'Campo Actualizado',
                'text' => 'El campo fue actualizado correctamente.',
                'reload' => false,
            ]);
        } catch (\Throwable $th) {
            Log::error('FieldController - update -> Error: ' . $th->getMessage());
            return response()->view('layouts.partials.misc.error_500', ['exception' => $th], 500);
        }
    }

    /**
     * Función para eliminar un campo por su ID.
     */
    public function destroy($id)
    {
        try {
            $deleted = DB::connection('mysql_admin')->table('fields')->where('id', $id)->delete();

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
            Log::error('FieldController - destroy -> Error: ' . $th->getMessage());
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
