<?php

namespace App\Http\Controllers;

use Illuminate\Support\Str;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;
use App\Traits\ValidateFormTrait;
use App\Traits\CharIdTrait;
use App\Traits\RuleArrayTrait;
use App\Traits\LogTrait;
use App\Services\ExcelService;

class StockController extends Controller
{
    use ValidateFormTrait;
    use CharIdTrait;
    use RuleArrayTrait;
    use LogTrait;

    protected $excel;

    public function __construct(ExcelService $excel)
    {
        $this->excel = $excel;
    }

    // EXPORTAR STOCKS
    public function exportStocks(Request $request)
    {
        $query = DB::connection('mysql_admin')
            ->table('stocks')
            ->leftJoin('fields', 'fields.id', '=', 'stocks.field_id')
            ->leftJoin('rodeos', 'rodeos.id', '=', 'stocks.rodeo_id')
            ->leftJoin('type_animals', 'type_animals.id', '=', 'stocks.type_animal_id')
            ->select(
                // 'stocks.index',
                'stocks.index_idv',
                'stocks.index_eid',
                'fields.name as field_name',
                'rodeos.name as rodeo_name',
                'type_animals.name as type_animal_name'
            );

        // Filtros
        if ($request->filled('field')) {
            $query->where('stocks.field_id', $request->input('field'));
        }
        if ($request->filled('rodeo')) {
            $query->where('stocks.rodeo_id', $request->input('rodeo'));
        }

        // Si no se pasa ni field ni rodeo, filtrar por user_id
        if (!$request->filled('field') && !$request->filled('rodeo')) {
            $userId = session()->get('user')->id;
            $query->where('fields.user_id', $userId);
        }

        $data = $query->get();

        // Si no hay datos, mantener encabezados
        if ($data->isEmpty()) {
            $data = collect([
                [
                    // 'index' => null,
                    'index_idv' => null,
                    'index_eid' => null,
                    'field_name' => null,
                    'rodeo_name' => null,
                    'type_animal_name' => null,
                ],
            ]);
        }

        return $this->excel->downloadFromCollection(
            $data,
            ['N° de IDV', 'N° de EID', 'Campo', 'Rodeo', 'Tipo de Animal'],
            'Stocks_proganadero.xlsx'
        );
    }


    // IMPORTAR STOCKS
    public function importStocks(Request $request)
    {
        $request->validate([
            'file' => 'required|file|mimes:xlsx,xls,csv',
        ]);

        $file = $request->file('file');
        $rows = \Maatwebsite\Excel\Facades\Excel::toArray([], $file)[0];

        $imported = 0;
        $skipped = 0;

        foreach ($rows as $index => $row) {
            if ($index === 0) continue; // Encabezado

            [$nro_idv, $nro_eid, $campoNombre, $rodeoNombre, $tipoAnimalNombre] = $row;

            // Normalizar identificador
            // $identificadorLower = strtolower($identificador);

            // if ((str_contains($identificadorLower, 'idv') && str_contains($identificadorLower, 'eid')) ||
            //     (str_contains($identificadorLower, 'visual') && str_contains($identificadorLower, 'electronica')) ||
            //     str_contains($identificadorLower, 'ambos')
            // ) {
            //     $identificador = 'IDV (identificación visual) y EID (identificación electrónica)';
            // } elseif (str_contains($identificadorLower, 'idv') || str_contains($identificadorLower, 'visual')) {
            //     $identificador = 'IDV (identificación visual)';
            // } elseif (str_contains($identificadorLower, 'eid') || str_contains($identificadorLower, 'electrónica') || str_contains($identificadorLower, 'electronica')) {
            //     $identificador = 'EID (identificación electrónica)';
            // } else {
            //     $skipped++;
            //     continue;
            // }

            // Buscar entidades por slug o nombre
            $campo = DB::connection('mysql_admin')->table('fields')->where('slug', Str::slug($campoNombre))->first();
            $rodeo = DB::connection('mysql_admin')->table('rodeos')->where('slug', Str::slug($rodeoNombre))->first();
            $tipoAnimal = DB::connection('mysql_admin')->table('type_animals')->where('slug', Str::slug($tipoAnimalNombre))->first();

            if (!$campo || !$rodeo || !$tipoAnimal) {
                $skipped++;
                continue;
            }

            // Verificar duplicado exacto
            $exists = DB::connection('mysql_admin')->table('stocks')
                // ->where('index', $identificador)
                ->where('index_idv', $nro_idv)
                ->where('index_eid', $nro_eid)
                ->where('field_id', $campo->id)
                ->where('rodeo_id', $rodeo->id)
                ->where('type_animal_id', $tipoAnimal->id)
                ->exists();

            if ($exists) {
                $skipped++;
                continue;
            }

            // Insertar
            DB::connection('mysql_admin')->table('stocks')->insert([
                'id' => $this->generateUniqueCharId('stocks', 'id', 'mysql_admin'),
                // 'index' => $identificador,
                'index_idv' => $nro_idv,
                'index_eid' => $nro_eid,
                'field_id' => $campo->id,
                'rodeo_id' => $rodeo->id,
                'type_animal_id' => $tipoAnimal->id,
                'created_at' => now(),
                'updated_at' => now(),
            ]);

            $imported++;
        }

        return response()->json([
            'title' => 'Importación finalizada',
            'text' => "$imported registros importados, $skipped registros omitidos por duplicados o datos inválidos",
        ]);
    }


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

            $type_animals = DB::connection('mysql_admin')->table('type_animals')->select('id', 'name')->get();

            $animalBreeds = DB::connection('mysql_admin')->table('animal_breeds')->select('id', 'name')->get();

            return view('stocks.index', compact('fields', 'type_animals', 'animalBreeds'));
        } catch (\Throwable $th) {
            Log::error('StockController - index -> Error: ' . $th->getMessage());
            return response()->view(
                'layouts.partials.misc.error_500',
                [
                    'exception' => $th,
                ],
                500,
            );
        }
    }

    public function stocksReunion()
    {
        try {

            return view('stocksReunions.index');
        } catch (\Throwable $th) {
            Log::error('StockController - index -> Error: ' . $th->getMessage());
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
            Log::error('StockController - create -> Error: ' . $th->getMessage());
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
            Log::error('StockController - show -> Error: ' . $th->getMessage());
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
        // try {
        $data = DB::connection('mysql_admin')->table('stocks')->where('id', $id)->first();

        $type_animals = DB::connection('mysql_admin')->table('type_animals')->select('id', 'name')->get();

        $animalBreeds = DB::connection('mysql_admin')->table('animal_breeds')->select('id', 'name')->get();

        $div = '#edit_modal_content_stock';

        return response()->json([
            'html' => view('stocks.partials.modals.components.edit', compact('data', 'type_animals', 'animalBreeds'))->render(),
            'div' => $div,
        ]);
        // } catch (\Throwable $th) {
        //     Log::error('StockController - edit -> Error: ' . $th->getMessage());
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
        // Validación de arrays
        $validation = [
            ...$this->rulesArray(
                'index',
                ['required', 'string', 'max:100', 'not_in:null'],
                'Identificador',
                true,
                count($request->input('index', []))
            ),
            ...$this->rulesArray(
                'type_animal',
                ['required', 'string', 'max:100', 'not_in:null'],
                'Tipo de animal',
                true,
                count($request->input('type_animal', []))
            ),
            // Validamos opcionalmente los campos IDV y EID solo si existen
            ...$this->rulesArray(
                'index_idv',
                ['nullable', 'string', 'max:100'],
                'N° de IDV',
                true,
                count($request->input('index_idv', []))
            ),
            ...$this->rulesArray(
                'index_eid',
                ['nullable', 'string', 'max:100'],
                'N° de EID',
                true,
                count($request->input('index_eid', []))
            ),
        ];

        if ($response = $this->validateFormInput($request, $validation, 'Stock no registrado')) {
            return $response;
        }

        $stocks = $request->index ?? [];
        $total = count($stocks);

        for ($i = 0; $i < $total; $i++) {
            $values = [
                'id' => $this->generateUniqueCharId('stocks', 'id', 'mysql_admin'),
                'index' => $request->index[$i] ?? null,
                'index_idv' => $request->index_idv[$i] ?? null,
                'index_eid' => $request->index_eid[$i] ?? null,
                'field_id' => $request->field_id,
                'rodeo_id' => $request->rodeo_id,
                'type_animal_id' => $request->type_animal[$i] ?? null,
                'created_at' => now(),
            ];

            DB::connection('mysql_admin')->table('stocks')->insert($values);
        }

        return response()->json([
            'title' => 'Stocks Guardados',
            'text' => 'Los stocks fueron guardados correctamente.',
            'reload' => false,
        ]);
    }


    /**
     * Funcion para actualizar.
     */
    public function update(Request $request, $id)
    {
        try {
            // Validación de los campos enviados
            $validation = [
                ...$this->rulesArray(
                    'edit_index',
                    ['required', 'string', 'max:100', 'not_in:null'],
                    'Identificador',
                    false
                ),
                ...$this->rulesArray(
                    'edit_type_animal',
                    ['required', 'string', 'max:100', 'not_in:null'],
                    'Tipo de animal',
                    false
                ),
                // Campos opcionales solo si existen
                ...$this->rulesArray(
                    'edit_index_idv',
                    ['nullable', 'string', 'max:100'],
                    'N° de IDV',
                    false
                ),
                ...$this->rulesArray(
                    'edit_index_eid',
                    ['nullable', 'string', 'max:100'],
                    'N° de EID',
                    false
                ),
            ];

            if ($response = $this->validateFormInput($request, $validation, 'Stock no actualizado')) {
                return $response; // Retorna error JSON o redirección según tu trait
            }

            // Preparar datos para actualización
            $values = [
                'index' => $request->edit_index,
                'index_idv' => $request->edit_index_idv ?? null,
                'index_eid' => $request->edit_index_eid ?? null,
                'type_animal_id' => $request->edit_type_animal,
                'updated_at' => now(),
            ];

            // Actualizar registro en la tabla stocks
            DB::connection('mysql_admin')->table('stocks')->where('id', $id)->update($values);

            // Respuesta JSON exitosa
            return response()->json([
                'title' => 'Stock Actualizado',
                'text' => 'El stock fue actualizado correctamente.',
                'reload' => false,
            ]);
        } catch (\Throwable $th) {
            Log::error('StockController - update -> Error: ' . $th->getMessage());
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
     * Función para eliminar un campo por su ID.
     */
    public function destroy($id)
    {
        try {
            $deleted = DB::connection('mysql_admin')->table('stocks')->where('id', $id)->delete();

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
            Log::error('StockController - destroy -> Error: ' . $th->getMessage());
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
    public function transfer(Request $request, $id = 0)
    {
        try {
            // $data = DB::connection('mysql_admin')->table('stocks')->where('id', $id)->first();

            $fields = DB::connection('mysql_admin')
                ->table('fields')
                ->where('user_id', session()->get('user')->id)
                ->select('id', 'name')
                ->get();

            $div = '#transfer_modal_content_stock';

            // Verificamos si viene la variable ids en el request
            $data = [];
            if ($request->has('ids')) {
                $data['ids'] = $request->ids; // o $request->get('ids')
            }

            // Siempre pasamos fields, y si existe ids también lo incluimos
            return response()->json([
                'html' => view('stocks.partials.modals.components.transfer', array_merge(['fields' => $fields], $data))->render(),
                'div' => $div,
            ]);
        } catch (\Throwable $th) {
            Log::error('StockController - transfer -> Error: ' . $th->getMessage());
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
    public function transferAll(Request $request)
    {
        try {
            $data = [
                'all' => true,
                'field_id' => $request->input('field'),
                'rodeo_id' => $request->input('rodeo'),
            ];

            $fields = DB::connection('mysql_admin')
                ->table('fields')
                ->where('user_id', session()->get('user')->id)
                ->select('id', 'name')
                ->get();

            $div = '#transfer_modal_content_stock';

            return response()->json([
                'html' => view('stocks.partials.modals.components.transfer', compact('data', 'fields'))->render(),
                'div' => $div,
            ]);
        } catch (\Throwable $th) {
            Log::error('StockController - transfer -> Error: ' . $th->getMessage());
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
     * Funcion para mover.
     */
    public function move(Request $request, $id = 0)
    {
        // try {
        // Definición de reglas de validación para los nuevos arrays
        $validation = [...$this->rulesArray('transfer_field', ['required', 'string', 'max:100'], 'Campo', false), ...$this->rulesArray('transfer_rodeo', ['required', 'string', 'max:100'], 'Rodeo', false)];

        // Validar la entrada con el trait personalizado
        if ($response = $this->validateFormInput($request, $validation, 'Stock no actualizado')) {
            return $response; // Retorna error JSON o redirección según tu trait
        }
        // Preparar datos para actualización
        $values = [
            'field_id' => $request->transfer_field,
            'rodeo_id' => $request->transfer_rodeo,
            'updated_at' => now(),
        ];

        $updatedIds = []; // para registrar los IDs que se actualizaron
        $oldFields = [];
        $oldRodeos = [];

        if ($request->boolean('transfer_all')) {
            // Todos los stocks por campo/rodeo viejo
            $stocks = DB::connection('mysql_admin')
                ->table('stocks')
                ->where('field_id', $request->transfer_old_field)
                ->where('rodeo_id', $request->transfer_old_rodeo)
                ->get(['id', 'field_id', 'rodeo_id']);

            $updatedIds = $stocks->pluck('id')->toArray();

            // Obtener nombres de los campos y rodeos viejos desde la tabla stocks
            $oldFieldIds = $stocks->pluck('field_id')->unique()->toArray();
            $oldRodeoIds = $stocks->pluck('rodeo_id')->unique()->toArray();

            $oldFields = DB::connection('mysql_admin')->table('fields')->whereIn('id', $oldFieldIds)->pluck('name')->toArray();

            $oldRodeos = DB::connection('mysql_admin')->table('rodeos')->whereIn('id', $oldRodeoIds)->pluck('name')->toArray();

            // Actualizar stocks
            DB::connection('mysql_admin')->table('stocks')->where('field_id', $request->transfer_old_field)->where('rodeo_id', $request->transfer_old_rodeo)->update($values);
        } elseif (!empty($request->ids)) {
            // Múltiples IDs
            $stocks = DB::connection('mysql_admin')
                ->table('stocks')
                ->whereIn('id', $request->ids)
                ->get(['id', 'field_id', 'rodeo_id']);

            $updatedIds = $stocks->pluck('id')->toArray();

            $oldFieldIds = $stocks->pluck('field_id')->unique()->toArray();
            $oldRodeoIds = $stocks->pluck('rodeo_id')->unique()->toArray();

            $oldFields = DB::connection('mysql_admin')->table('fields')->whereIn('id', $oldFieldIds)->pluck('name')->toArray();

            $oldRodeos = DB::connection('mysql_admin')->table('rodeos')->whereIn('id', $oldRodeoIds)->pluck('name')->toArray();

            DB::connection('mysql_admin')->table('stocks')->whereIn('id', $request->ids)->update($values);
        } elseif ($id > 0) {
            // ID individual
            $stock = DB::connection('mysql_admin')
                ->table('stocks')
                ->where('id', $id)
                ->first(['id', 'field_id', 'rodeo_id']);
            $updatedIds = [$stock->id];

            $oldFields = DB::connection('mysql_admin')->table('fields')->where('id', $stock->field_id)->pluck('name')->toArray();

            $oldRodeos = DB::connection('mysql_admin')->table('rodeos')->where('id', $stock->rodeo_id)->pluck('name')->toArray();

            DB::connection('mysql_admin')->table('stocks')->where('id', $id)->update($values);
        } else {
            return response()->json(
                [
                    'status' => 'error',
                    'message' => 'No se proporcionó ningún ID para actualizar.',
                ],
                400,
            );
        }

        // Obtener nombres de los campos y rodeos nuevos
        $newFields = DB::connection('mysql_admin')
            ->table('fields')
            ->whereIn('id', [$request->transfer_field])
            ->pluck('name')
            ->toArray();

        $newRodeos = DB::connection('mysql_admin')
            ->table('rodeos')
            ->whereIn('id', [$request->transfer_rodeo])
            ->pluck('name')
            ->toArray();

        // Módulo
        $module = DB::table('modules')->where('name', 'Stocks')->first()->id;

        // Crear mensaje dinámico
        $description = 'Se transfirieron stocks del campo <span style="color:#1572e8;">' . implode(', ', $oldFields) . '</span> del rodeo <span style="color:#31ce36;">' . implode(', ', $oldRodeos) . '</span> al campo <span style="color:#1572e8;">' . implode(', ', $newFields) . '</span> del rodeo <span style="color:#31ce36;">' . implode(', ', $newRodeos) . '</span>';

        // --- Registrar log ---
        $this->registerLogEntry($module, $description, $updatedIds);

        // Respuesta JSON exitosa
        return response()->json([
            'title' => 'Stock Transferido',
            'text' => 'Stock transferido correctamente.',
            'reload' => false,
        ]);
        // } catch (\Throwable $th) {
        //     Log::error('StockController - move -> Error: ' . $th->getMessage());
        //     return response()->view(
        //         'layouts.partials.misc.error_500',
        //         [
        //             'exception' => $th,
        //         ],
        //         500,
        //     );
        // }
    }
}
