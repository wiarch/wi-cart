<?php

namespace App\Http\Controllers\Ajax;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

/**
 * Controlador para manejar respuestas Ajax de tipo "Select2" o búsquedas rápidas.
 * Incluye búsqueda de Rodeos y Stocks filtrados por usuario.
 */
class AjaxSelectController extends Controller
{
    protected $DB_admin;

    public function __construct()
    {
        $this->DB_admin = config('database.connections.mysql_admin.database');
    }

    /**
     * Devuelve un query que genera un registro por cada índice de stock (IDV y EID)
     * con alias 'name' para usar en Select2 u otras búsquedas
     */
    protected function getStockNameQuery()
    {
        $DB = $this->DB_admin;

        return DB::table("$DB.stocks")
            ->select(
                'stocks.id',
                DB::raw("
                CONCAT_WS(' | ',
                    IF(stocks.index_idv IS NOT NULL, CONCAT('IDV: ', stocks.index_idv), NULL),
                    IF(stocks.index_eid IS NOT NULL, CONCAT('EID: ', stocks.index_eid), NULL)
                ) AS name
            ")
            )
            ->whereNotNull('stocks.id'); // Asegura que siempre traiga registros válidos
    }

    /**
     * Método genérico para búsqueda rápida de Select2
     *
     * @param string $table Nombre de la tabla
     * @param string $searchColumn Columna para buscar
     * @param array $whereCond Condiciones fijas [col => valor]
     * @param int $limit Límite de resultados
     * @param bool $order Indica si se debe ordenar
     */
    protected function quickSearch(string $table, string $searchColumn, array $whereCond, int $limit = 10, bool $order = true)
    {
        if ($table === 'stocks') {
            $query = $this->getStockNameQuery();

            // Filtrar por condiciones
            foreach ($whereCond as $col => $val) {
                $query->where($col, $val);
            }

            // Búsqueda por texto (opcional)
            if ($search = request('search')) {
                $query->where('name', 'LIKE', "%{$search}%");
            }

            // Orden
            if ($order) {
                $query->orderBy('name');
            }

            return $query->limit($limit)->get();
        }

        // Otros tables
        $query = DB::connection('mysql_admin')->table($table)
            ->select([
                "$table.id",
                "$table.$searchColumn as name"
            ]);

        foreach ($whereCond as $col => $val) {
            $query->where($col, $val);
        }

        if ($search = request('search')) {
            $query->where('name', 'LIKE', "%{$search}%");
        }

        if ($order) {
            $query->orderBy('name');
        }

        return $query->limit($limit)->get();
    }


    /**
     * Búsqueda de Rodeos por usuario
     */
    public function searchRodeos(Request $request)
    {
        $userId = $request->session()->get('user')->id;

        $results = $this->quickSearch(
            'rodeos',
            'name',
            ['user_id' => $userId]
        );

        return response()->json($results);
    }

    /**
     * Búsqueda de Stocks por usuario
     */
    public function searchStocks(Request $request)
    {
        $userId = $request->session()->get('user')->id;

        $results = $this->quickSearch(
            'stocks',
            '', // Ignorado para stocks
            ['fields.user_id' => $userId]
        );

        return response()->json($results);
    }

    /**
     * Búsqueda de Stocks por Rodeo
     */
    public function searchStocksRodeos(Request $request, $rodeoId)
    {
        $results = $this->quickSearch(
            'stocks',
            '', // Ignorado para stocks
            ['stocks.rodeo_id' => $rodeoId]
        );

        return response()->json($results);
    }

    /**
     * Búsqueda de códigos de tratamiento (catálogo admin)
     */
    public function searchTreatmentCodes(Request $request)
    {
        $limit = (int) ($request->get('limit', 10000));

        $results = $this->quickSearch(
            'treatment_codes',
            'name',
            [],
            $limit,
            true
        );

        return response()->json($results);
    }
}
