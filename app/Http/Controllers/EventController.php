<?php

namespace App\Http\Controllers;

use Illuminate\Support\Str;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\Schema;
use App\Traits\ValidateFormTrait;
use App\Traits\CharIdTrait;
use App\Traits\RuleArrayTrait;
use App\Services\ExcelService;

class EventController extends Controller
{
    use ValidateFormTrait;
    use CharIdTrait;
    use RuleArrayTrait;

    protected $DB_admin;
    protected $excel;

    public function __construct(ExcelService $excel)
    {
        // Se ejecuta al instanciar el controlador
        $this->DB_admin = config('database.connections.mysql_admin.database');

        $this->excel = $excel;
    }

    /**
     * Muestra una lista.
     */
    public function index()
    {
        try {
            return 'test';
        } catch (\Throwable $th) {
            Log::error('EventController - index -> Error: ' . $th->getMessage());
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
    public function logs()
    {
        try {
            $modules = DB::table('modules')->select('id', 'name')->get();

            return view('events.logs.index', compact('modules'));
        } catch (\Throwable $th) {
            Log::error('EventController - logs -> Error: ' . $th->getMessage());
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
    public function logsShow($id)
    {
        // try {

        $log = DB::table('logs')->where('id', $id)->first();

        if ($log && !empty($log->ids)) {
            $stockIds = json_decode($log->ids, true);

            $stocks = DB::connection('mysql_admin')->table('stocks')->whereIn('id', $stockIds)->select('id', 'index', 'index_description')->get();
        } else {
            $stocks = collect(); // colección vacía
        }
        $div = '#show_modal_content_stocks';

        return response()->json([
            'html' => view('events.logs.partials.modals.components.show_stocks', compact('stocks'))->render(),
            'div' => $div,
        ]);

        // } catch (\Throwable $th) {
        //     Log::error('EventController - logs -> Error: ' . $th->getMessage());
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
     * Muestra la vista.
     */
    public function reproductions()
    {
        try {
            $type_animals = DB::connection('mysql_admin')->table('type_animals')->select('id', 'name')->get();

            $fields = DB::connection('mysql_admin')->table('fields')
                ->where('user_id', session()->get('user')->id)
                ->select('id', 'name')
                ->get();

            $rodeos = DB::connection('mysql_admin')->table('rodeos')
                ->where('user_id', session()->get('user')->id)
                ->select('id', 'name')
                ->get();

            $stocks = DB::connection('mysql_admin')
                ->table('stocks')
                ->join('rodeos', 'rodeos.id', '=', 'stocks.rodeo_id')
                ->where('rodeos.user_id', session()->get('user')->id)
                ->select(
                    'stocks.id',
                    DB::raw("
                    CASE
                        WHEN stocks.index_idv IS NOT NULL AND stocks.index_eid IS NOT NULL THEN
                            CONCAT('IDV: ', COALESCE(stocks.index_idv, '-'), ' | EID: ', COALESCE(stocks.index_eid, '-'))
                        WHEN stocks.index_idv IS NOT NULL THEN
                            CONCAT('IDV: ', COALESCE(stocks.index_idv, '-'))
                        WHEN stocks.index_eid IS NOT NULL THEN
                            CONCAT('EID: ', COALESCE(stocks.index_eid, '-'))
                        ELSE
                            'Sin identificación'
                    END as name
                ")
                )
                ->get();

            return view('events.reproductions.index', compact('type_animals', 'fields', 'rodeos', 'stocks'));
        } catch (\Throwable $th) {
            Log::error('EventController - reproductions -> Error: ' . $th->getMessage());
            return response()->view('layouts.partials.misc.error_500', ['exception' => $th], 500);
        }
    }


    public function exportReproductions(Request $request)
    {
        $query = DB::table('reproductions as r')
            // ->leftJoin($this->DB_admin . '.fields as f', 'r.field_id', '=', 'f.id')
            // ->leftJoin($this->DB_admin . '.rodeos as ro', 'r.rodeo_id', '=', 'ro.id')
            ->leftJoin($this->DB_admin . '.stocks as s', 'r.stock_id', '=', 's.id')
            ->leftJoin($this->DB_admin . '.type_animals as ta', 'r.type_animal_id', '=', 'ta.id')
            ->select(
                // 'f.name as field_name',
                // 'ro.name as rodeo_name',
                's.index_idv',
                's.index_eid',
                'ta.name as type_animal_name',
                'r.date_birth',
                DB::raw("CASE WHEN r.gender = 1 THEN 'M' WHEN r.gender = 0 THEN 'F' ELSE '' END as gender"),
                'r.weight',
                'r.observation_birth',
                'r.diagnostic_birth',
                'r.date_pre_service',
                'r.diagnostic_pre_service',
                'r.cc_pre_service',
                'r.date_insemination',
                'r.bull',
                'r.date_ecography',
                'r.diagnostic_ecography',
                'r.cc_ecography',
                'r.date_touch',
                'r.diagnostic_touch',
                'r.cc_touch',
                'r.created_at',
                'r.updated_at'
            );

        if ($request->filled('rodeo')) {
            $query->where('r.rodeo_id', $request->input('rodeo'));
        }

        $data = $query->get();

        if ($data->isEmpty()) {
            $data = collect([array_fill_keys([
                // 'field_name',
                // 'rodeo_name',
                'index_idv',
                'index_eid',
                'type_animal_name',
                'date_birth',
                'gender',
                'weight',
                'observation_birth',
                'diagnostic_birth',
                'date_pre_service',
                'diagnostic_pre_service',
                'cc_pre_service',
                'date_insemination',
                'bull',
                'date_ecography',
                'diagnostic_ecography',
                'cc_ecography',
                'date_touch',
                'diagnostic_touch',
                'cc_touch',
                'created_at',
                'updated_at'
            ], null)]);
        }

        return $this->excel->downloadFromCollection(
            $data,
            [
                // 'Campo',
                // 'Rodeo',
                'IDV',
                'EID',
                'Tipo Animal',
                'Fecha Nacimiento',
                'Sexo',
                'Peso en KG',
                'Observación Parto',
                'Diagnóstico Parto',
                'Fecha Pre Servicio',
                'Diagnóstico Pre Servicio',
                'CC Pre Servicio',
                'Fecha Inseminación',
                'Toro',
                'Fecha Ecografía',
                'Diagnóstico Ecografía',
                'CC Ecografía',
                'Fecha Tacto',
                'Diagnóstico Tacto',
                'CC Tacto',
                'Creado',
                'Actualizado'
            ],
            'Reproductions_proganadero.xlsx'
        );
    }

    public function importReproductions(Request $request)
    {
        $request->validate(['file' => 'required|file|mimes:xlsx,xls,csv']);
        $file = $request->file('file');

        $rows = \Maatwebsite\Excel\Facades\Excel::toArray([], $file)[0];

        $imported = 0;
        $skipped = 0;
        $userId = session()->get('user')->id;

        foreach ($rows as $index => $row) {
            if ($index === 0) continue; // Saltar encabezado

            [
                // $fieldName,
                // $rodeoName,
                $indexIdv,
                $indexEid,
                $typeAnimalName,
                $dateBirth,
                $gender,
                $weight,
                $observationBirth,
                $diagnosticBirth,
                $datePreService,
                $diagnosticPreService,
                $ccPreService,
                $dateInsemination,
                $bull,
                $dateEcography,
                $diagnosticEcography,
                $ccEcography,
                $dateTouch,
                $diagnosticTouch,
                $ccTouch,
                $createdAt,
                $updatedAt
            ] = $row;

            // Convertir sexo M/F a 1/0
            $gender = strtoupper(trim($gender));
            if ($gender === 'M') {
                $gender = 1;
            } elseif ($gender === 'F') {
                $gender = 0;
            } else {
                $gender = null;
            }

            // $field = $fieldName
            //     ? DB::table($this->DB_admin . '.fields')->where('slug', Str::slug($fieldName))->first()
            //     : null;

            // $rodeo = $rodeoName
            //     ? DB::table($this->DB_admin . '.rodeos')->where('slug', Str::slug($rodeoName))->first()
            //     : null;

            $tipoAnimal = $typeAnimalName
                ? DB::table($this->DB_admin . '.type_animals')->where('slug', Str::slug($typeAnimalName))->first()
                : null;

            $stock = ($indexIdv || $indexEid)
                ? DB::table($this->DB_admin . '.stocks')
                ->when($indexIdv, fn($q) => $q->where('index_idv', $indexIdv))
                ->when($indexEid, fn($q) => $q->orWhere('index_eid', $indexEid))
                ->first()
                : null;

            if (!$tipoAnimal || !$stock) {
            // if (!$rodeo || !$tipoAnimal || !$stock) {
                $skipped++;
                continue;
            }

            $exists = DB::table('reproductions')
                ->where('stock_id', $stock->id)
                ->where('date_birth', $dateBirth)
                ->exists();

            if ($exists) {
                $skipped++;
                continue;
            }

            DB::table('reproductions')->insert([
                'id' => $this->generateUniqueCharId('reproductions', 'id'),
                'user_id' => $userId,
                // 'field_id' => $field->id ?? null,
                // 'rodeo_id' => $rodeo->id,
                'stock_id' => $stock->id,
                'type_reproduction' => 1,
                'type_animal_id' => $tipoAnimal->id,
                'date_birth' => $dateBirth,
                'gender' => $gender,
                'weight' => $weight,
                'observation_birth' => $observationBirth,
                'diagnostic_birth' => $diagnosticBirth,
                'date_pre_service' => $datePreService,
                'diagnostic_pre_service' => $diagnosticPreService,
                'cc_pre_service' => $ccPreService,
                'date_insemination' => $dateInsemination,
                'bull' => $bull,
                'date_ecography' => $dateEcography,
                'diagnostic_ecography' => $diagnosticEcography,
                'cc_ecography' => $ccEcography,
                'date_touch' => $dateTouch,
                'diagnostic_touch' => $diagnosticTouch,
                'cc_touch' => $ccTouch,
                'created_at' => $createdAt ?? now(),
                'updated_at' => $updatedAt ?? now(),
            ]);

            $imported++;
        }

        return response()->json([
            'title' => 'Importación finalizada',
            'text' => "$imported registros importados, $skipped registros omitidos por duplicados o datos inválidos",
        ]);
    }


    public function sanitary()
    {
        try {
            $treatment_codes = DB::connection('mysql_admin')->table('treatment_codes')->select('id', 'name')->get();
            $type_animals = DB::connection('mysql_admin')->table('type_animals')->select('id', 'name')->get();

            $rodeos = DB::connection('mysql_admin')->table('rodeos')
                ->where('user_id', session()->get('user')->id)
                ->select('id', 'name')
                ->get();

            $stocks = DB::connection('mysql_admin')
                ->table('stocks')
                ->join('rodeos', 'rodeos.id', '=', 'stocks.rodeo_id')
                ->where('rodeos.user_id', session()->get('user')->id)
                ->select(
                    'stocks.id',
                    DB::raw("
                    CASE
                        WHEN stocks.index_idv IS NOT NULL AND stocks.index_eid IS NOT NULL THEN
                            CONCAT('IDV: ', COALESCE(stocks.index_idv, '-'), ' | EID: ', COALESCE(stocks.index_eid, '-'))
                        WHEN stocks.index_idv IS NOT NULL THEN
                            CONCAT('IDV: ', COALESCE(stocks.index_idv, '-'))
                        WHEN stocks.index_eid IS NOT NULL THEN
                            CONCAT('EID: ', COALESCE(stocks.index_eid, '-'))
                        ELSE
                            'Sin identificación'
                    END as name
                ")
                )
                ->get();

            return view('events.sanitary.index', compact('treatment_codes', 'type_animals', 'rodeos', 'stocks'));
        } catch (\Throwable $th) {
            Log::error('EventController - sanitary -> Error: ' . $th->getMessage());
            return response()->view('layouts.partials.misc.error_500', ['exception' => $th], 500);
        }
    }

    public function deaths()
    {
        try {
            $type_animals = DB::connection('mysql_admin')->table('type_animals')->select('id', 'name')->get();

            $rodeos = DB::connection('mysql_admin')->table('rodeos')
                ->where('user_id', session()->get('user')->id)
                ->select('id', 'name')
                ->get();

            $stocks = DB::connection('mysql_admin')
                ->table('stocks')
                ->join('rodeos', 'rodeos.id', '=', 'stocks.rodeo_id')
                ->where('rodeos.user_id', session()->get('user')->id)
                ->select(
                    'stocks.id',
                    DB::raw("
                    CASE
                        WHEN stocks.index_idv IS NOT NULL AND stocks.index_eid IS NOT NULL THEN
                            CONCAT('IDV: ', COALESCE(stocks.index_idv, '-'), ' | EID: ', COALESCE(stocks.index_eid, '-'))
                        WHEN stocks.index_idv IS NOT NULL THEN
                            CONCAT('IDV: ', COALESCE(stocks.index_idv, '-'))
                        WHEN stocks.index_eid IS NOT NULL THEN
                            CONCAT('EID: ', COALESCE(stocks.index_eid, '-'))
                        ELSE
                            'Sin identificación'
                    END as name
                ")
                )
                ->get();

            return view('events.deaths.index', compact('type_animals', 'rodeos', 'stocks'));
        } catch (\Throwable $th) {
            Log::error('EventController - deaths -> Error: ' . $th->getMessage());
            return response()->view('layouts.partials.misc.error_500', ['exception' => $th], 500);
        }
    }

    /**
     * Muestra la vista.
     */
    public function feedings()
    {
        try {

            $rodeos = DB::connection('mysql_admin')->table('rodeos')->where('user_id', session()->get('user')->id)->select('id', 'name')->get();
            $stocks = DB::connection('mysql_admin')
                ->table('stocks')
                ->join('rodeos', 'rodeos.id', '=', 'stocks.rodeo_id')
                ->where('rodeos.user_id', session()->get('user')->id)
                ->select(
                    'stocks.id',
                    DB::raw("
            CASE
                WHEN stocks.index_idv IS NOT NULL AND stocks.index_eid IS NOT NULL THEN
                    CONCAT('IDV: ', COALESCE(stocks.index_idv, '-'), ' | EID: ', COALESCE(stocks.index_eid, '-'))
                WHEN stocks.index_idv IS NOT NULL THEN
                    CONCAT('IDV: ', COALESCE(stocks.index_idv, '-'))
                WHEN stocks.index_eid IS NOT NULL THEN
                    CONCAT('EID: ', COALESCE(stocks.index_eid, '-'))
                ELSE
                    'Sin identificación'
            END as name
        ")
                )
                ->get();


            return view('events.feedings.index', compact('rodeos', 'stocks'));
        } catch (\Throwable $th) {
            Log::error('EventController - feedings -> Error: ' . $th->getMessage());
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
            Log::error('EventController - create -> Error: ' . $th->getMessage());
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
            Log::error('EventController - show -> Error: ' . $th->getMessage());
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
    public function edit($id, Request $request)
    {
        $type = $request->type ?? null;
        $userId = session()->get('user')->id;

        $extraVariables = [];
        // Mensaje de error genérico
        $errorMessage = 'No se pudo cargar el formulario de edición.';

        // Mapeo tipo => tabla
        $tables = [
            '0' => 'logs',
            '1' => 'reproductions',
            '2' => 'sanitary',
            '3' => 'deaths',
            '4' => 'feedings',
        ];

        // Validar tipo
        if (!isset($tables[$type])) {
            return response()->json(
                [
                    'title' => 'Error',
                    'error' => $errorMessage,
                ],
                400,
            );
        }

        $table = $tables[$type];

        // Traer los datos del registro
        $data = null;

        switch ($type) {
            case '0': // logs
                $data = DB::table('logs')->where('id', $id)->first();
                break;

            case '1': // reproductions
                $data = DB::table('reproductions as r')
                    ->where('r.id', $id)
                    ->select('r.*')->first();

                // $extraVariables['type_animals'] = DB::connection('mysql_admin')->table('type_animals')->select('id', 'name')->get();

                break;

            case '2': // sanitary
                $data = DB::table('sanitary as sy')
                    ->leftJoin($this->DB_admin . '.fields as f', 'sy.rodeo_id', '=', 'f.id')
                    ->leftJoin($this->DB_admin . '.rodeos as r', 'sy.rodeo_id', '=', 'r.id')
                    ->leftJoin($this->DB_admin . '.treatment_codes as t', 'sy.treatment_code_id', 't.id')
                    ->where('sy.id', $id)
                    ->select('sy.*', 'f.name as field_name', 'r.name as rodeo_name', 't.name as treatment_code_name')
                    ->first();
                $extraVariables['type_animals'] = DB::connection('mysql_admin')->table('type_animals')->select('id', 'name')->get();
                $extraVariables['treatment_codes'] = DB::connection('mysql_admin')->table('treatment_codes')->select('id', 'name')->get();

                break;

            case '3': // deaths
                $data = DB::table('deaths as d')
                    // ->leftJoin($this->DB_admin . '.stocks as s', 'd.stock_id', '=', 's.id')
                    // ->leftJoin($this->DB_admin . '.rodeos as r', 'd.rodeo_id', '=', 'r.id')
                    // ->leftJoin($this->DB_admin . '.type_animals as ta', 'd.type_animal_id', '=', 'ta.id')
                    ->where('d.id', $id)
                    ->select('d.*')
                    ->first();

                $extraVariables['type_animals'] = DB::connection('mysql_admin')->table('type_animals')->select('id', 'name')->get();
                $extraVariables['type_death'] = $request->type_death;

                break;

            case '4': // feedings
                $data = DB::table('feedings as f')
                    // ->leftJoin($this->DB_admin . '.stocks as s', 'f.stock_id', '=', 's.id')
                    // ->leftJoin($this->DB_admin . '.rodeos as r', 'f.rodeo_id', '=', 'r.id')
                    ->where('f.id', $id)
                    ->select('f.*')
                    ->first();
                break;

            default:
                // Manejar tipo no válido
                throw new \Exception("Tipo no válido: $type");
        }

        if (!$data) {
            return response()->json(
                [
                    'title' => 'Error',
                    'error' => 'Registro no encontrado.',
                ],
                404,
            );
        }

        // Definir el div y la vista parcial según el tipo
        $divs = [
            '0' => '#edit_modal_content_log',
            '1' => '#edit_modal_content_reproduction',
            '2' => '#edit_modal_content_sanitary',
            '3' => '#edit_modal_content_death',
            '4' => '#edit_modal_content_feeding',
        ];

        $views = [
            '0' => 'events.logs.partials.modals.components.edit',
            '1' => 'events.reproductions.partials.modals.components.edit',
            '2' => 'events.sanitary.partials.modals.components.edit',
            '3' => 'events.deaths.partials.modals.components.edit',
            '4' => 'events.feedings.partials.modals.components.edit',
        ];

        $div = $divs[$type];
        $view = $views[$type];
        // Combinar $data con $extraVariables para enviarlos al Blade
        $variables = array_merge(['data' => $data], $extraVariables);

        return response()->json([
            'html' => view($view, $variables)->render(),
            'div' => $div,
        ]);
    }

    /**
     * Funcion para crear.
     */
    public function store(Request $request)
    {
        $type = $request->type;
        $userId = session()->get('user')->id;

        // Mensaje de error único
        $errorMessage = 'No se pudo crear el evento.';

        // Mapeo de tipo => tabla
        $tables = [
            '0' => 'logs',
            '1' => 'reproductions',
            '2' => 'sanitary',
            '3' => 'deaths',
            '4' => 'feedings',
        ];

        // Mapeo de tipo => campos que se insertarán
        $fields = [
            '0' => ['description'],
            '1' => [
                // 'rodeo_id',
                'stock_id',
                'type_reproduction',
                'type_animal_id',
                'diagnostic_birth',
                'date_birth',
                'gender',
                'weight',
                'observation_birth',
                'date_pre_service',
                'diagnostic_pre_service',
                'cc_pre_service',
                'date_insemination',
                'bull',
                'date_ecography',
                'diagnostic_ecography',
                'cc_ecography',
                'date_touch',
                'diagnostic_touch',
                'cc_touch'
            ],
            '2' => [
                'rodeo_id',
                'stock_id',
                'treatment_code_id',
                'type_sanitary',
                'type_animal_id',
                'date',
                'dose',
                'serial_number',
                'date_expiration',
                'mark',
                'retirement',
                'diagnostic',
                'observation'
            ],
            '3' => [
                'rodeo_id',
                'stock_id',
                'type_death',
                'type_animal_id',
                'date',
                'diagnostic',
                'observation',
                'date_sale',
                'guide_number'
            ],
            '4' => ['rodeo_id', 'stock_id', 'date', 'weight'],
        ];

        // Alias de los campos para mensajes de error
        $fieldLabels = [
            'description' => 'Descripción',
            'rodeo_id' => 'Rodeo',
            'stock_id' => 'Stock',
            'type_reproduction' => 'Tipo de Reproducción',
            'type_animal_id' => 'Tipo de Animal',
            'diagnostic_birth' => 'Diagnóstico de Parto',
            'date_birth' => 'Fecha de Parto',
            'gender' => 'Sexo',
            'weight' => 'Peso',
            'observation_birth' => 'Observación de Parto',
            'date_pre_service' => 'Fecha Pre Servicio',
            'diagnostic_pre_service' => 'Diagnóstico Pre Servicio',
            'cc_pre_service' => 'CC Pre Servicio',
            'date_insemination' => 'Fecha de Inseminación',
            'bull' => 'Toro',
            'date_ecography' => 'Fecha de Ecografía',
            'diagnostic_ecography' => 'Diagnóstico Ecografía',
            'cc_ecography' => 'CC Ecografía',
            'date_tacto' => 'Fecha de Tacto',
            'diagnostic_tacto' => 'Diagnóstico de Tacto',
            'cc_tacto' => 'CC Tacto',
            'treatment_code_id' => 'Código de Tratamiento',
            'type_sanitary' => 'Tipo Sanitario',
            'date' => 'Fecha',
            'dose' => 'Dosis',
            'serial_number' => 'Número de Serie',
            'date_expiration' => 'Vencimiento',
            'mark' => 'Marca',
            'retirement' => 'Retiro',
            'diagnostic' => 'Diagnóstico',
            'observation' => 'Observación',
            'type_death' => 'Tipo de Muerte',
            'date_sale' => 'Fecha de Venta',
            'guide_number' => 'Número de Guía',
        ];

        // Validar que exista el tipo
        if (!isset($tables[$type]) || !isset($fields[$type])) {
            return response()->json(
                [
                    'title' => 'Error',
                    'error' => $errorMessage,
                ],
                400,
            );
        }

        // Mapeo tipo => campos a validar
        $validationFields = [
            '0' => [
                'description' => ['required', 'string', 'max:255'],
            ],
            '1' => [
                // 'rodeo_id' => ['required'],
                'stock_id' => ['required'],
                'type_reproduction' => ['required'],
            ],
            '2' => [
                'type_sanitary' => ['required'],
                'type_animal_id' => ['required'],
                'treatment_code_id' => ['required'],
                'date' => ['required', 'date'],
                'dose' => ['required', 'numeric'],
                'diagnostic' => ['required', 'string'],
                'observation_birth' => ['nullable', 'string'],
                'serial_number' => ['required', 'numeric'],
                'date_expiration' => ['required', 'date'],
                'mark' => ['required', 'string'],
                'retirement' => ['required', 'string'],
            ],
            '3' => [
                'rodeo_id' => ['required'],
                'stock_id' => ['required'],
                'type_animal_id' => ['required'],
                'date' => ['required', 'date'],
                'type_death' => ['required'],
            ],
            '4' => [
                'rodeo_id' => ['required'],
                'stock_id' => ['required'],
                'date' => ['required', 'date'],
                'weight' => ['required'],
            ],
        ];

        // Validar que exista el tipo
        if (!isset($validationFields[$type])) {
            return response()->json(
                [
                    'title' => 'Error',
                    'error' => 'Tipo no válido.',
                ],
                400,
            );
        }

        // Generar reglas dinámicas usando tu trait rulesArray
        $validation = [];
        foreach ($validationFields[$type] as $field => $rules) {
            $count = is_array($request->input($field)) ? count($request->input($field)) : 1;
            $validation = array_merge($validation, $this->rulesArray($field, $rules, $fieldLabels[$field] ?? $field, false));
        }

        // Validar con tu trait
        if ($response = $this->validateFormInput($request, $validation, 'Evento no registrado')) {
            return $response;
        }

        $table = $tables[$type];
        $data = [];

        // Asignar cada campo su valor desde el request
        foreach ($fields[$type] as $field) {
            $data[$field] = $request->input($field) ?? null;
        }

        // Campos comunes
        $data['id'] = $this->generateUniqueCharId($table, 'id');
        $data['user_id'] = $userId;
        $data['created_at'] = now();
        $data['updated_at'] = now();

        switch ($type) {
            case 1:


                // $data['field_id'] = DB::connection('mysql_admin')
                //     ->table('rodeos')
                //     ->where('id', $data['rodeo_id'])
                //     ->value('field_id');

                $data['type_animal_id'] = DB::connection('mysql_admin')->table('stocks')
                    ->where('id', $data['stock_id'])
                    ->value('type_animal_id');

                // Buscar si ya existe un registro con mismo rodeo, stock
                $existing = DB::table('reproductions')
                    // ->where('rodeo_id', $data['rodeo_id'])
                    ->where('stock_id', $data['stock_id'])
                    ->first();

                if ($existing) {
                    // Actualizar solo los campos con valores
                    $updateData = array_filter($data, fn($value) => $value !== null);
                    $updateData['updated_at'] = now();

                    DB::table('reproductions')->where('id', $existing->id)->update($updateData);

                    return response()->json([
                        'title' => 'Registro actualizado',
                        'text' => 'El evento de reproducción fue actualizado correctamente.',
                        'reload' => false,
                        'id' => $existing->id,
                    ]);
                }

                // Crear nuevo registro si no existe
                $data['id'] = $this->generateUniqueCharId('reproductions', 'id');
                $data['user_id'] = $userId;
                $data['created_at'] = now();
                $data['updated_at'] = now();

                break;
            case 2:
                if (!empty($data['rodeo_id'])) {
                    // Si viene el rodeo directamente
                    $fieldId = DB::connection('mysql_admin')->table('rodeos')->where('id', $data['rodeo_id'])->value('field_id');

                    $data['field_id'] = $fieldId ?? null;
                } elseif (!empty($data['stock_id'])) {
                    // Si viene por stock, buscamos rodeo y field
                    $stock = DB::connection('mysql_admin')->table('stocks')->select('rodeo_id', 'field_id')->where('id', $data['stock_id'])->first();

                    if ($stock) {
                        $data['rodeo_id'] = $stock->rodeo_id;
                        $data['field_id'] = $stock->field_id;
                    }
                }

                // Actualizar inventario en food_supplies según tratamiento y usuario
                try {
                    $codeId = $data['treatment_code_id'] ?? null;
                    $dose = isset($data['dose']) ? (float) $data['dose'] : 0;

                    if ($codeId && $dose > 0) {
                        $query = DB::table('food_supplies')
                            ->where('code_tratment_id', $codeId);

                        // Filtrar por usuario si la columna existe
                        if (Schema::hasColumn('food_supplies', 'user_id')) {
                            $query->where('user_id', $userId);
                        }

                        // Tomar el registro más reciente por si hay varios
                        $foodSupply = $query->orderByDesc('created_at')->first();

                        if ($foodSupply) {
                            $consumed = (float) ($foodSupply->consumed ?? 0);
                            $stockInit = (float) ($foodSupply->stock_init ?? 0);
                            $newConsumed = $consumed + $dose;
                            $newStockEnd = $stockInit - $newConsumed;

                            DB::table('food_supplies')
                                ->where('id', $foodSupply->id)
                                ->update([
                                    'consumed' => $newConsumed,
                                    'stock_end' => $newStockEnd,
                                    'updated_at' => now(),
                                ]);
                        }
                    }
                } catch (\Throwable $e) {
                    // No interrumpir la creación del sanitario si falla la actualización del stock
                    Log::warning('EventController - sanitary stock update failed: ' . $e->getMessage());
                }
                break;
            case 3:
                $fieldId = DB::connection('mysql_admin')->table('rodeos')->where('id', $data['rodeo_id'])->value('field_id');

                $data['field_id'] = $fieldId ?? null;
                break;
        }

        // Insertar en la tabla correspondiente (puedes cambiar la conexión si es otra DB)
        DB::table($table)->insertGetId($data);

        return response()->json([
            'title' => 'Evento creado',
            'text' => 'El evento se creó correctamente.',
            'reload' => false,
            // 'id' => $id,
        ]);
    }

    /**
     * Actualiza un evento según su tipo.
     */
    public function update(Request $request, $id)
    {
        // try {
        $type = $request->type;
        $userId = session()->get('user')->id;

        $errorMessage = 'No se pudo actualizar el evento.';

        // Mapeo de tipo => tabla
        $tables = [
            '0' => 'logs',
            '1' => 'reproductions',
            '2' => 'sanitary',
            '3' => 'deaths',
            '4' => 'feedings',
        ];

        // Mapeo de tipo => campos que se insertarán
        $fields = [
            '0' => ['description'],
            '1' => [
                'type_reproduction',
                'diagnostic_birth',
                'date_birth',
                'gender',
                'weight',
                'observation_birth',
                'date_pre_service',
                'diagnostic_pre_service',
                'cc_pre_service',
                'date_insemination',
                'bull',
                'date_ecography',
                'diagnostic_ecography',
                'cc_ecography',
                'date_touch',
                'diagnostic_touch',
                'cc_touch'
            ],
            '2' => [
                'treatment_code_id',
                'type_sanitary',
                'type_animal_id',
                'date',
                'dose',
                'serial_number',
                'date_expiration',
                'mark',
                'retirement',
                'diagnostic',
                'observation'
            ],
            '3' => [
                'type_animal_id',
                'type_death',
                'date',
                'diagnostic',
                'observation',
                'date_sale',
                'guide_number'
            ],
            '4' => ['date', 'weight'],
        ];

        // Alias de los campos para mensajes de error
        $fieldLabels = [
            'description' => 'Descripción',
            'type_reproduction' => 'Tipo de Reproducción',
            'type_animal_id' => 'Tipo de Animal',
            'diagnostic_birth' => 'Diagnóstico de Parto',
            'date_birth' => 'Fecha de Parto',
            'gender' => 'Sexo',
            'weight' => 'Peso',
            'observation_birth' => 'Observación de Parto',
            'date_pre_service' => 'Fecha Pre Servicio',
            'diagnostic_pre_service' => 'Diagnóstico Pre Servicio',
            'cc_pre_service' => 'CC Pre Servicio',
            'date_insemination' => 'Fecha de Inseminación',
            'bull' => 'Toro',
            'date_ecography' => 'Fecha de Ecografía',
            'diagnostic_ecography' => 'Diagnóstico Ecografía',
            'cc_ecography' => 'CC Ecografía',
            'date_tacto' => 'Fecha de Tacto',
            'diagnostic_tacto' => 'Diagnóstico de Tacto',
            'cc_tacto' => 'CC Tacto',
            'treatment_code_id' => 'Código de Tratamiento',
            'type_sanitary' => 'Tipo Sanitario',
            'date' => 'Fecha',
            'dose' => 'Dosis',
            'serial_number' => 'Número de Serie',
            'date_expiration' => 'Vencimiento',
            'mark' => 'Marca',
            'retirement' => 'Retiro',
            'diagnostic' => 'Diagnóstico',
            'observation' => 'Observación',
            'type_death' => 'Tipo de Muerte',
            'date_sale' => 'Fecha de Venta',
            'guide_number' => 'Número de Guía',
        ];

        if (!isset($tables[$type]) || !isset($fields[$type])) {
            return response()->json(
                [
                    'title' => 'Error',
                    'error' => $errorMessage,
                ],
                400,
            );
        }

        $table = $tables[$type];

        // Validación dinámica
        $validationFields = [
            '0' => ['description' => ['required', 'string', 'max:255']],
            '1' => [
                // 'date' => ['required', 'date'],
                // 'observation' => ['required'],
                // 'type_animal_id' => ['required'],
            ],
            '2' => [
                'type_animal_id' => ['required'],
                'treatment_code_id' => ['required'],
                'date' => ['required', 'date'],
                'dose' => ['required', 'numeric'],
                'diagnostic' => ['required', 'string'],
                'observation' => ['nullable', 'string'],
                'serial_number' => ['required', 'numeric'],
                'date_expiration' => ['required', 'date'],
                'mark' => ['required', 'string'],
                'retirement' => ['required', 'string'],
            ],
            '3' => [
                'type_animal_id' => ['required'],
                'date' => ['required', 'date'],
            ],
            '4' => [
                'weight' => ['required'],
                'date' => ['required', 'date'],
            ],
        ];

        $validation = [];
        foreach ($validationFields[$type] as $field => $rules) {
            $validation = array_merge($validation, $this->rulesArray($field, $rules, $fieldLabels[$field] ?? $field, false));
        }

        // Validar con el trait
        if ($response = $this->validateFormInput($request, $validation, 'Evento no actualizado')) {
            return $response;
        }

        // Preparar los valores para update solo con inputs existentes
        $values = [];
        foreach ($fields[$type] as $field) {
            if ($request->has($field)) {  // Solo toma los campos presentes en el request
                $values[$field] = $request->input($field);
            }
        }

        // Si no hay campos para actualizar, no hacemos nada
        if (!empty($values)) {
            $values['updated_at'] = now();
            DB::table($table)->where('id', $id)->update($values);
        }

        return response()->json([
            'title' => 'Evento Actualizado',
            'text' => 'El evento se actualizó correctamente.',
            'reload' => false,
        ]);

        // } catch (\Throwable $th) {
        //     Log::error('EventController - update -> Error: ' . $th->getMessage());
        //     return response()->view('layouts.partials.misc.error_500', ['exception' => $th], 500);
        // }
    }

    /**
     * Función para eliminar un campo por su ID.
     */
    public function destroy(Request $request, $id)
    {
        // try {
        $type = $request->type;

        // Mensaje de error único
        $errorMessage = 'No se encontró el evento o ya fue eliminado.';

        // Mapeo de tipo => tabla
        $tables = [
            '0' => 'logs',
            '1' => 'reproductions',
            '2' => 'sanitary',
            '3' => 'deaths',
            '4' => 'feedings',
        ];

        // Validar que exista el tipo
        if (!isset($tables[$type])) {
            return response()->json(
                [
                    'title' => 'Error',
                    'error' => $errorMessage,
                ],
                400,
            );
        }

        // Realizar delete
        $deleted = DB::table($tables[$type])->where('id', $id)->delete();

        // Verificar si se eliminó
        if (!$deleted) {
            return response()->json(
                [
                    'title' => 'Error',
                    'error' => $errorMessage,
                ],
                404,
            );
        }

        // Si se eliminó correctamente
        return response()->json([
            'title' => 'Evento eliminado',
            'text' => 'El evento fue eliminado correctamente.',
            'reload' => false,
        ]);
        // } catch (\Throwable $th) {
        //     Log::error('EventController - destroy -> Error: ' . $th->getMessage());
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
