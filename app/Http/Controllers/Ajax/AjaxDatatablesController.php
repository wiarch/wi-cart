<?php

namespace App\Http\Controllers\Ajax;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class AjaxDatatablesController extends Controller
{
    protected $DB_admin;

    public function __construct()
    {
        $this->DB_admin = config('database.connections.mysql_admin.database');
    }

    /**
     * Respuesta centralizada para DataTables
     */
    private function dataTableResponse(
        $query,
        Request $request,
        array $allowedColumns,
        ?array $searchColumns = null,
        ?array $filterMap = null
    ) {
        $draw = intval($request->get('draw'));
        $start = intval($request->get('start', 0));
        $length = intval($request->get('length', 10));
        $searchValue = $request->input('search.value');

        if ($filterMap) {
            foreach ($filterMap as $param => $column) {
                if ($request->filled($param) && $request->$param !== '') {
                    $query->where($column, $request->$param);
                }
            }
        }

        $totalRecords = $query->count();

        if (!empty($searchValue) && $searchColumns) {
            $query->where(function ($q) use ($searchValue, $searchColumns) {
                foreach ($searchColumns as $column) {
                    $q->orWhere($column, 'like', "%$searchValue%");
                }
            });
        }

        $totalRecordsWithFilter = $query->count();

        $orderColumnIndex = $request->input('order.0.column');
        $orderDir = $request->input('order.0.dir', 'asc');
        $orderColumnName = $request->input("columns.$orderColumnIndex.data");

        if ($orderColumnName && in_array($orderColumnName, $allowedColumns)) {
            $query->orderBy($orderColumnName, $orderDir);
        }

        $records = $query->offset($start)->limit($length)->get()->map(fn($item) => get_object_vars($item));

        return response()->json([
            'draw' => $draw,
            'iTotalRecords' => $totalRecords,
            'iTotalDisplayRecords' => $totalRecordsWithFilter,
            'aaData' => $records,
        ]);
    }

    /* =========================
       MÉTODOS PÚBLICOS
    ========================= */

    public function getFieldsUser(Request $request)
    {
        $id_user = $request->session()->get('user')->id;
        $query = DB::connection('mysql_admin')->table('fields')->where('user_id', $id_user);
        return $this->dataTableResponse($query, $request, ['id', 'name', 'location', 'created_at'], ['name', 'location']);
    }

    public function getReasonsUser(Request $request)
    {
        $id_user = $request->session()->get('user')->id;
        $query = DB::table('reasons')
            ->where('reasons.user_id', $id_user)
            ->leftJoin($this->DB_admin . '.rodeos', 'rodeos.id', '=', 'reasons.rodeo_id')
            ->leftJoin($this->DB_admin . '.rearing_finishing_bases', 'rearing_finishing_bases.id', '=', 'reasons.rearing_finishing_bases_id')
            ->select(
                'reasons.*',
                'rodeos.name as rodeo_name',
                'rearing_finishing_bases.detail as food_name'
            );

        return $this->dataTableResponse($query, $request, ['id', 'detail', 'reason_value', 'created_at', 'rodeo_name', 'food_name'], ['detail', 'reason_value']);
    }

    public function getTerminationsUser(Request $request)
    {
        $id_user = $request->session()->get('user')->id;
        $query = DB::table('terminations')
            ->where('terminations.user_id', $id_user)
            ->select('terminations.*');

        return $this->dataTableResponse($query, $request, ['id', 'reason_name', 'type', 'cms', 'pv', 'gdp', 'animals', 'days', 'date'], ['reason_name']);
    }

    public function getBatchesUser(Request $request)
    {
        $id_user = $request->session()->get('user')->id;
        $query = DB::connection('mysql_admin')->table('batches')
            ->where('batches.user_id', $id_user)
            ->leftJoin('fields', 'fields.id', '=', 'batches.field_id')
            ->select('batches.id', 'batches.name', 'batches.surface', 'batches.created_at', 'fields.name as field_name');

        if ($request->filled('field')) $query->where('batches.field_id', $request->field);

        return $this->dataTableResponse($query, $request, ['id', 'name', 'surface', 'created_at', 'field_name'], ['batches.name', 'batches.surface', 'fields.name']);
    }

    public function getRodeosUser(Request $request)
    {
        $id_user = $request->session()->get('user')->id;
        $query = DB::connection('mysql_admin')->table('rodeos')
            ->where('rodeos.user_id', $id_user)
            ->leftJoin('fields', 'fields.id', '=', 'rodeos.field_id')
            ->leftJoin('batches', 'batches.id', '=', 'rodeos.batch_id')
            ->leftJoin('regions', 'regions.id', '=', 'rodeos.region_id')
            ->leftJoin('services', 'services.id', '=', 'rodeos.service_id')
            ->leftJoin('animal_breeds', 'animal_breeds.id', '=', 'rodeos.animal_breed_id')
            ->select('rodeos.*', 'fields.name as field_name', 'batches.name as batch_name', 'regions.name as region_name', 'services.name as service_name', 'services.description as service_description', 'animal_breeds.name as animal_breed_name');

        return $this->dataTableResponse(
            $query,
            $request,
            ['id', 'name', 'created_at', 'field_name', 'batch_name', 'region_name', 'service_name', 'service_description', 'animal_breed_name'],
            ['rodeos.name', 'fields.name', 'batches.name', 'regions.name', 'services.name', 'services.description', 'animal_breeds.name']
        );
    }

    public function getStocksUser(Request $request)
    {
        $query = DB::connection('mysql_admin')->table('stocks')
            ->leftJoin('fields', 'fields.id', '=', 'stocks.field_id')
            ->leftJoin('rodeos', 'rodeos.id', '=', 'stocks.rodeo_id')
            ->leftJoin('type_animals', 'type_animals.id', '=', 'stocks.type_animal_id')
            ->leftJoin('animal_breeds', 'animal_breeds.id', '=', 'rodeos.animal_breed_id')
            ->leftJoin('batches', 'batches.id', '=', 'rodeos.batch_id')
            ->select('stocks.*', 'fields.name as field_name', 'rodeos.name as rodeo_name', 'animal_breeds.name as animal_breed_name', 'type_animals.name as type_animal_name', 'batches.name as batch_name');

        $id_user = $request->session()->get('user')->id;
        if (!isset($request->field) || !isset($request->rodeo)) $query->where('fields.user_id', $id_user);

        return $this->dataTableResponse(
            $query,
            $request,
            ['id', 'index_idv', 'index_eid', 'created_at', 'field_name', 'rodeo_name', 'animal_breed_name', 'batch_name', 'type_animal_name'],
            ['stocks.index_idv', 'stocks.index_eid', 'fields.name', 'rodeos.name', 'animal_breeds.name', 'batches.name', 'type_animals.name'],
            ['field' => 'stocks.field_id', 'rodeo' => 'stocks.rodeo_id']
        );
    }

    /**
     * Devuelve los feedings del usuario con índice combinado IDV/EID.
     */
    public function getFeedings(Request $request)
    {
        $id_user = $request->session()->get('user')->id;

        $query = DB::table('feedings')
            ->where('feedings.user_id', $id_user)
            ->leftJoin($this->DB_admin . '.rodeos', 'rodeos.id', '=', 'feedings.rodeo_id')
            ->leftJoin($this->DB_admin . '.stocks', 'stocks.id', '=', 'feedings.stock_id')
            ->select(
                'feedings.*',
                'rodeos.name as rodeo_name',
                DB::raw("
                CASE
                    WHEN stocks.index_idv IS NOT NULL AND stocks.index_eid IS NOT NULL THEN CONCAT('IDV: ', stocks.index_idv, ' | EID: ', stocks.index_eid)
                    WHEN stocks.index_idv IS NOT NULL THEN CONCAT('IDV: ', stocks.index_idv)
                    WHEN stocks.index_eid IS NOT NULL THEN CONCAT('EID: ', stocks.index_eid)
                    ELSE 'Sin identificación'
                END as stock_index
            ")
            );

        return $this->dataTableResponse(
            $query,
            $request,
            ['id', 'weight', 'created_at', 'rodeo_name', 'stock_index'],
            ['feedings.weight', 'rodeos.name', 'stocks.index_idv', 'stocks.index_eid'],
            ['rodeo' => 'feedings.rodeo_id', 'stock' => 'feedings.stock_id']
        );
    }

    /**
     * Devuelve los deaths del usuario con índice combinado IDV/EID.
     */
    public function getDeaths(Request $request)
    {
        $id_user = $request->session()->get('user')->id;

        $query = DB::table('deaths')
            ->where('deaths.user_id', $id_user)
            ->leftJoin($this->DB_admin . '.fields', 'fields.id', '=', 'deaths.field_id')
            ->leftJoin($this->DB_admin . '.rodeos', 'rodeos.id', '=', 'deaths.rodeo_id')
            ->leftJoin($this->DB_admin . '.stocks', 'stocks.id', '=', 'deaths.stock_id')
            ->leftJoin($this->DB_admin . '.type_animals', 'type_animals.id', '=', 'deaths.type_animal_id')
            ->select(
                'deaths.*',
                'rodeos.name as rodeo_name',
                'type_animals.name as type_animal_name',
                'fields.name as field_name',
                DB::raw("
                CASE
                    WHEN stocks.index_idv IS NOT NULL AND stocks.index_eid IS NOT NULL THEN CONCAT('IDV: ', stocks.index_idv, ' | EID: ', stocks.index_eid)
                    WHEN stocks.index_idv IS NOT NULL THEN CONCAT('IDV: ', stocks.index_idv)
                    WHEN stocks.index_eid IS NOT NULL THEN CONCAT('EID: ', stocks.index_eid)
                    ELSE 'Sin identificación'
                END as stock_index
            ")
            );

        return $this->dataTableResponse(
            $query,
            $request,
            ['id', 'weight', 'type_death', 'created_at', 'rodeo_name', 'stock_index', 'type_animal_name', 'field_name'],
            ['deaths.weight', 'rodeos.name', DB::raw("
            CASE
                WHEN stocks.index_idv IS NOT NULL AND stocks.index_eid IS NOT NULL THEN CONCAT('IDV: ', stocks.index_idv, ' | EID: ', stocks.index_eid)
                WHEN stocks.index_idv IS NOT NULL THEN CONCAT('IDV: ', stocks.index_idv)
                WHEN stocks.index_eid IS NOT NULL THEN CONCAT('EID: ', stocks.index_eid)
                ELSE 'Sin identificación'
            END
        ")],
            ['type_death' => 'deaths.type_death', 'rodeo' => 'deaths.rodeo_id', 'stock' => 'deaths.stock_id']
        );
    }

    /**
     * Devuelve los registros sanitarios del usuario con índice combinado IDV/EID.
     */
    public function getSanitary(Request $request)
    {
        $id_user = $request->session()->get('user')->id;

        $query = DB::table('sanitary')
            ->where('sanitary.user_id', $id_user)
            ->leftJoin($this->DB_admin . '.stocks', 'stocks.id', '=', 'sanitary.stock_id')
            ->leftJoin($this->DB_admin . '.rodeos', 'rodeos.id', '=', 'sanitary.rodeo_id')
            ->leftJoin($this->DB_admin . '.fields', 'fields.id', '=', 'sanitary.field_id')
            ->leftJoin($this->DB_admin . '.treatment_codes', 'treatment_codes.id', '=', 'sanitary.treatment_code_id')
            ->leftJoin($this->DB_admin . '.type_animals', 'type_animals.id', '=', 'sanitary.type_animal_id')
            ->select(
                'sanitary.*',
                'rodeos.name as rodeo_name',
                'fields.name as field_name',
                'treatment_codes.name as treatment_name',
                'type_animals.name as type_animal_name',
                DB::raw("
                CASE
                    WHEN stocks.index_idv IS NOT NULL AND stocks.index_eid IS NOT NULL THEN CONCAT('IDV: ', stocks.index_idv, ' | EID: ', stocks.index_eid)
                    WHEN stocks.index_idv IS NOT NULL THEN CONCAT('IDV: ', stocks.index_idv)
                    WHEN stocks.index_eid IS NOT NULL THEN CONCAT('EID: ', stocks.index_eid)
                    ELSE 'Sin identificación'
                END as stock_index
            ")
            );

        return $this->dataTableResponse(
            $query,
            $request,
            ['id', 'type_sanitary', 'created_at', 'stock_index', 'rodeo_name', 'field_name', 'treatment_name', 'type_animal_name'],
            ['rodeos.name', 'fields.name', 'treatment_codes.name', 'type_animals.name', DB::raw("
            CASE
                WHEN stocks.index_idv IS NOT NULL AND stocks.index_eid IS NOT NULL THEN CONCAT('IDV: ', stocks.index_idv, ' | EID: ', stocks.index_eid)
                WHEN stocks.index_idv IS NOT NULL THEN CONCAT('IDV: ', stocks.index_idv)
                WHEN stocks.index_eid IS NOT NULL THEN CONCAT('EID: ', stocks.index_eid)
                ELSE 'Sin identificación'
            END
        ")],
            ['type_sanitary' => 'sanitary.type_sanitary', 'rodeo' => 'sanitary.rodeo_id', 'stock' => 'sanitary.stock_id']
        );
    }

    /**
     * Devuelve los registros de reproducción del usuario con índice combinado IDV/EID.
     */
    public function getReproduction(Request $request)
    {
        $id_user = $request->session()->get('user')->id;

        $query = DB::table('reproductions')
            ->where('reproductions.user_id', $id_user)
            ->leftJoin($this->DB_admin . '.stocks', 'stocks.id', '=', 'reproductions.stock_id')
            ->leftJoin($this->DB_admin . '.rodeos', 'rodeos.id', '=', 'stocks.rodeo_id')
            ->leftJoin($this->DB_admin . '.fields', 'fields.id', '=', 'stocks.field_id')
            ->leftJoin($this->DB_admin . '.type_animals', 'type_animals.id', '=', 'reproductions.type_animal_id')
            ->select(
                'reproductions.*',
                'rodeos.name as rodeo_name',
                'fields.name as field_name',
                'type_animals.name as type_animal_name',
                DB::raw("
            CASE
                WHEN stocks.index_idv IS NOT NULL AND stocks.index_eid IS NOT NULL THEN CONCAT('IDV: ', stocks.index_idv, ' | EID: ', stocks.index_eid)
                WHEN stocks.index_idv IS NOT NULL THEN CONCAT('IDV: ', stocks.index_idv)
                WHEN stocks.index_eid IS NOT NULL THEN CONCAT('EID: ', stocks.index_eid)
                ELSE 'Sin identificación'
            END as stock_index
        ")
            );

        return $this->dataTableResponse(
            $query,
            $request,
            ['id', 'stock_index', 'rodeo_name', 'field_name', 'type_animal_name'],
            ['rodeos.name', 'fields.name', 'type_animals.name', DB::raw("
            CASE
                WHEN stocks.index_idv IS NOT NULL AND stocks.index_eid IS NOT NULL THEN CONCAT('IDV: ', stocks.index_idv, ' | EID: ', stocks.index_eid)
                WHEN stocks.index_idv IS NOT NULL THEN CONCAT('IDV: ', stocks.index_idv)
                WHEN stocks.index_eid IS NOT NULL THEN CONCAT('EID: ', stocks.index_eid)
                ELSE 'Sin identificación'
            END
        ")],
            ['field' => 'stocks.field_id', 'rodeo' => 'stocks.rodeo_id', 'stock' => 'reproductions.stock_id']
        );
    }


    public function getGrazingsUser(Request $request)
    {
        $userId = $request->session()->get('user')->id;

        $query = DB::table('grazings')
            ->where('grazings.user_id', $userId)
            ->leftJoin($this->DB_admin . '.rodeos', 'rodeos.id', '=', 'grazings.rodeo_id')
            ->leftJoin($this->DB_admin . '.batches', 'batches.id', '=', 'rodeos.batch_id')
            ->leftJoin($this->DB_admin . '.regions', 'regions.id', '=', 'grazings.region_id')
            ->leftJoin($this->DB_admin . '.forage_resources', 'forage_resources.id', '=', 'grazings.forage_resource_id')
            ->leftJoin($this->DB_admin . '.type_grazings', 'type_grazings.id', '=', 'grazings.grazing_id')
            ->select(
                'grazings.id',
                'grazings.input_date',
                'grazings.output_date',
                'grazings.created_at',
                'batches.name as batch_name',
                'batches.surface as surface',
                'rodeos.name as rodeo_name',
                'regions.name as region_name',
                'forage_resources.name as forage_resource_name',
                'type_grazings.name as type_grazing_name'
            );

        return $this->dataTableResponse(
            $query,
            $request,
            ['id', 'input_date', 'output_date', 'created_at', 'rodeo_name', 'batch_name', 'surface', 'region_name', 'forage_resource_name', 'type_grazing_name'],
            ['rodeos.name', 'batches.name', 'batches.surface', 'regions.name', 'forage_resources.name', 'type_grazings.name'],
            ['rodeo' => 'grazings.rodeo_id']
        );
    }

    public function getStocksReunionUser(Request $request)
    {
        $userId = $request->session()->get('user')->id;

        $stocksSub = DB::connection('mysql_admin')->table('stocks')
            ->leftJoin('rodeos', 'stocks.rodeo_id', '=', 'rodeos.id')
            ->leftJoin('type_animals', 'stocks.type_animal_id', '=', 'type_animals.id')
            ->leftJoin('animal_breeds', 'rodeos.animal_breed_id', '=', 'animal_breeds.id')
            ->where('rodeos.user_id', $userId)
            ->select(
                'stocks.id as stock_id',
                'rodeos.id',
                'rodeos.name as rodeo_name',
                'type_animals.id as type_animal_id',
                'type_animals.name as type_animal_name',
                'rodeos.animal_breed_id as animal_breed_id',
                'animal_breeds.name as animal_breed_name',
                'stocks.updated_at'
            );

        $query = DB::connection('mysql_admin')->table(DB::raw(''))->fromSub($stocksSub, 'sub')
            ->select(
                'id',
                'rodeo_name',
                'type_animal_id',
                'type_animal_name',
                'animal_breed_id',
                'animal_breed_name',
                DB::raw('COUNT(stock_id) as amount'),
                DB::raw('MAX(updated_at) as date')
            )
            ->groupBy('id', 'rodeo_name', 'type_animal_id', 'type_animal_name', 'animal_breed_id', 'animal_breed_name')
            ->orderBy('rodeo_name')
            ->orderBy('type_animal_name');

        return $this->dataTableResponse(
            $query,
            $request,
            ['id', 'rodeo_name', 'type_animal_id', 'type_animal_name', 'animal_breed_id', 'animal_breed_name', 'amount', 'date'],
            ['rodeo_name', 'type_animal_name', 'animal_breed_name'],
            ['id' => 'id', 'type_animal_id' => 'type_animal_id', 'animal_breed_id' => 'animal_breed_id']
        );
    }

    public function getSuppliesUser(Request $request)
    {
        $id_user = $request->session()->get('user')->id;
        $query = DB::table('supplies')
            ->leftJoin($this->DB_admin . '.batches', 'batches.id', '=', 'supplies.batch_id')
            ->where(function ($q) use ($id_user) {
                $q->whereNull('batches.user_id')
                    ->orWhere('batches.user_id', $id_user);
            })
            ->select(
                'supplies.id',
                'supplies.name',
                'supplies.quantity',
                'supplies.unit',
                'supplies.date',
                'batches.name as batch_name'
            );

        $allowedColumns = ['id', 'name', 'quantity', 'unit', 'date', 'batch_name'];
        $searchColumns = ['supplies.name', 'supplies.unit', $this->DB_admin . '.batches.name'];
        $filterMap = [];

        return $this->dataTableResponse($query, $request, $allowedColumns, $searchColumns, $filterMap);
    }

    public function getVeterinarySuppliesUser(Request $request)
    {
        $id_user = $request->session()->get('user')->id;
        $query = DB::table('food_supplies')
            ->whereNotNull('food_supplies.user_id')
            ->where('food_supplies.user_id', $id_user)
            ->leftJoin($this->DB_admin . '.treatment_codes', 'treatment_codes.id', '=', 'food_supplies.code_tratment_id')
            ->select(
                'food_supplies.id',
                'food_supplies.stock_init',
                'food_supplies.consumed',
                'food_supplies.stock_end',
                'treatment_codes.name as code_tratment_name'
            );

        $allowedColumns = ['id', 'stock_init', 'consumed', 'stock_end', 'code_tratment_name'];
        $searchColumns = [$this->DB_admin . '.treatment_codes.name', 'food_supplies.stock_init', 'food_supplies.stock_end'];
        $filterMap = [];

        return $this->dataTableResponse($query, $request, $allowedColumns, $searchColumns, $filterMap);
    }

    public function getLogsModule(Request $request)
    {
        $id_user = $request->session()->get('user')->id;
        $query = DB::table('logs')
            ->leftJoin('modules', 'modules.id', '=', 'logs.module_id')
            ->where('logs.user_id', $id_user)
            ->select('logs.*', 'modules.name as module_name');

        return $this->dataTableResponse(
            $query,
            $request,
            ['id', 'description', 'created_at', 'module_name'],
            ['logs.description', 'modules.name'],
            ['module' => 'logs.module_id']
        );
    }

    public function getHerdWeighingsUser(Request $request)
    {
        $id_user = $request->session()->get('user')->id;

        $query = DB::table('herd_weighings')
            ->where('user_id', $id_user)
            ->select('weighing_date', 'type_animal_id', 'vid_eid', 'weight');

        // Filtros por rango de fechas (weighing_date)
        if ($request->filled('date_from')) {
            $query->whereDate('weighing_date', '>=', $request->input('date_from'));
        }
        if ($request->filled('date_to')) {
            $query->whereDate('weighing_date', '<=', $request->input('date_to'));
        }

        $allowed = ['weighing_date', 'type_animal_id', 'vid_eid', 'weight'];
        $search = ['vid_eid'];

        return $this->dataTableResponse($query, $request, $allowed, $search, []);
    }
}
