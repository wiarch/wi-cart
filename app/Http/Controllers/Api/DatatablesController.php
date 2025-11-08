<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Traits\ApiResponseTrait;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class DatatablesController extends Controller
{
    use ApiResponseTrait;

    protected $DB_admin;

    public function __construct()
    {
        $this->DB_admin = config('database.connections.mysql_admin.database');
    }

    private function paginateQuery($query, $page = 1, $perPage = 10)
    {
        $filteredQuery = clone $query;
        $filtered = $filteredQuery->count();

        $total = clone $query;
        $totalCount = $total->count();

        $data = $query
            ->offset(($page - 1) * $perPage)
            ->limit($perPage)
            ->get();

        $lastPage = $filtered > 0 ? ceil($filtered / $perPage) : 1;

        return [
            'data' => $data,
            'meta' => [
                'total' => $totalCount,
                'filtered' => $filtered,
                'per_page' => $perPage,
                'current_page' => $page,
                'last_page' => $lastPage,
            ],
        ];
    }

    private function applySearch(Request $request, $query, array $columns)
    {
        $search = $request->search;
        if (!$search) return $query;

        return $query->where(function ($q) use ($columns, $search) {
            foreach ($columns as $column) {
                $q->orWhere($column, 'like', "%$search%");
            }
        });
    }

    public function getData(Request $request)
    {
        $userId = (string) $request->user->tokenable_id; // UUID
        $perPage = $request->get('per_page', 10);
        $page = $request->get('page', 1);

        // -------------------
        // Stocks
        // -------------------
        $query = DB::connection('mysql_admin')->table('stocks')
            ->select(
                'stocks.id',
                'stocks.index',
                'stocks.index_idv',
                'stocks.index_eid',
                'stocks.field_id',
                'fields.name as field_name',
                'stocks.rodeo_id',
                'rodeos.name as rodeo_name',
                'stocks.type_animal_id',
                'type_animals.name as type_animal_name',
                'rodeos.animal_breed_id',
                'animal_breeds.name as animal_breed_name',
                'rodeos.batch_id',
                'batches.name as batch_name',
                'stocks.created_at',
                'stocks.updated_at'
            )
            ->leftJoin('fields', 'fields.id', '=', 'stocks.field_id')
            ->leftJoin('rodeos', 'rodeos.id', '=', 'stocks.rodeo_id')
            ->leftJoin('type_animals', 'type_animals.id', '=', 'stocks.type_animal_id')
            ->leftJoin('animal_breeds', 'animal_breeds.id', '=', 'rodeos.animal_breed_id')
            ->leftJoin('batches', 'batches.id', '=', 'rodeos.batch_id')
            ->where('fields.user_id', $userId);

        $query = $this->applySearch($request, $query, [
            'stocks.index',
            'stocks.index_idv',
            'stocks.index_eid',
            'fields.name',
            'rodeos.name',
            'type_animals.name',
            'animal_breeds.name',
            'batches.name'
        ]);

        $result = $this->paginateQuery($query, $page, $perPage);

        $stocks = $result['data']->map(fn($item) => [
            'id' => (string) $item->id,
            'index' => $item->index,
            'index_idv' => $item->index_idv,
            'index_eid' => $item->index_eid,
            'field_id' => (string) $item->field_id,
            'field_name' => $item->field_name,
            'rodeo_id' => (string) $item->rodeo_id,
            'rodeo_name' => $item->rodeo_name,
            'animal_breed_id' => (string) $item->animal_breed_id,
            'animal_breed_name' => $item->animal_breed_name,
            'batch_id' => (string) $item->batch_id,
            'batch_name' => $item->batch_name,
            'type_animal_id' => (string) $item->type_animal_id,
            'type_animal_name' => $item->type_animal_name,
            'created_at' => $item->created_at,
            'updated_at' => $item->updated_at,
        ]);

        // -------------------
        // Modulos
        // -------------------
        $fields = DB::connection('mysql_admin')->table('fields')
            ->where('user_id', $userId)
            ->get()
            ->map(fn($item) => [
                'id' => (string) $item->id,
                'name' => $item->name,
                'location' => $item->location,
                'coordinate' => $item->coordinate,
                'created_at' => $item->created_at,
                'updated_at' => $item->updated_at,
            ]);

        $batches = DB::connection('mysql_admin')->table('batches')
            ->where('batches.user_id', $userId)
            ->select('batches.id', 'batches.name', 'batches.surface', 'batches.field_id', 'batches.rodeo_id', 'batches.created_at', 'batches.updated_at')
            ->get()
            ->map(fn($item) => [
                'id' => (string) $item->id,
                'name' => $item->name,
                'surface' => $item->surface,
                'field_id' => (string) $item->field_id,
                'rodeo_id' => (string) $item->rodeo_id,
                'created_at' => $item->created_at,
                'updated_at' => $item->updated_at,
            ]);

        $rodeos = DB::connection('mysql_admin')->table('rodeos')
            ->where('user_id', $userId)
            ->select('id', 'name', 'field_id', 'batch_id', 'region_id', 'service_id', 'animal_breed_id', 'created_at', 'updated_at')
            ->get()
            ->map(fn($item) => [
                'id' => (string) $item->id,
                'name' => $item->name,
                'field_id' => (string) $item->field_id,
                'batch_id' => (string) $item->batch_id,
                'region_id' => (string) $item->region_id,
                'service_id' => (string) $item->service_id,
                'animal_breed_id' => (string) $item->animal_breed_id,
                'created_at' => $item->created_at,
                'updated_at' => $item->updated_at,
            ]);

        // -------------------
        // Eventos
        // -------------------
        $feedings = DB::table('feedings')->where('user_id', $userId)->get()->map(fn($item) => (array) $item);
        $deaths = DB::table('deaths')->where('user_id', $userId)->get()->map(fn($item) => (array) $item);
        $sanitarys = DB::table('sanitary')->where('user_id', $userId)->get()->map(fn($item) => (array) $item);

        // -------------------
        // Selects
        // -------------------
        $animal_breeds = DB::connection('mysql_admin')->table('animal_breeds')->get()->map(fn($item) => (array) $item);
        $regions = DB::connection('mysql_admin')->table('regions')->get()->map(fn($item) => (array) $item);
        $services = DB::connection('mysql_admin')->table('services')->get()->map(fn($item) => (array) $item);
        $treatment_codes = DB::connection('mysql_admin')->table('treatment_codes')->get()->map(fn($item) => (array) $item);
        $type_animals = DB::connection('mysql_admin')->table('type_animals')->get()->map(fn($item) => (array) $item);

        $this->createOrUpdateToken($userId, 'getStocks');

        return $this->successResponse('Data obtenida', [
            'Modulos' => [
                'fields' => $fields,
                'batches' => $batches,
                'rodeos' => $rodeos,
                'stocks' => $stocks,
                'feedings' => $feedings,
                'deaths' => $deaths,
                'sanitarys' => $sanitarys,
            ],
            'Select' => [
                'animal_breeds' => $animal_breeds,
                'regions' => $regions,
                'services' => $services,
                'treatment_codes' => $treatment_codes,
                'type_animals' => $type_animals,
            ],
        ]);
    }
}
