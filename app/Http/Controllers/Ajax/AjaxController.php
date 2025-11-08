<?php

namespace App\Http\Controllers\Ajax;

use App\Http\Controllers\Controller;
use Carbon\Carbon;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Validator;

/**
 * Controlador principal para peticiones AJAX genéricas.
 * Proporciona datos dinámicos como regiones, razas de animales,
 * campos, rodeos, servicios y lotes.
 */
class AjaxController extends Controller
{
    /**
     * Obtener todas las regiones disponibles.
     *
     * @return array
     */
    public function getRegions()
    {
        $regions = DB::connection('mysql_admin')->table('regions')->select('id', 'name')->get();

        $array = [];

        foreach ($regions as $item) {
            $array[] = [
                'id' => $item->id,
                'name' => $item->name,
                'data' => null,
            ];
        }

        return $array;
    }

    /**
     * Obtener todas las razas de animales.
     *
     * @return array
     */
    public function getAnimalBreeds()
    {
        $animalBreeds = DB::connection('mysql_admin')->table('animal_breeds')->select('id', 'name', 'code')->get();

        $array = [];

        foreach ($animalBreeds as $item) {
            $array[] = [
                'id' => $item->id,
                'name' => "{$item->code} - {$item->name}",
                'data' => null,
            ];
        }

        return $array;
    }

    /**
     * Obtener los campos asociados a un usuario.
     *
     * @param int $id ID del usuario
     * @return array
     */
    public function getFields($id)
    {
        $fields = DB::connection('mysql_admin')->table('fields')->where('user_id', $id)->select('id', 'name')->get();

        $array = [];

        foreach ($fields as $item) {
            $array[] = [
                'id' => $item->id,
                'name' => $item->name,
                'data' => null,
            ];
        }

        return $array;
    }

    /**
     * Obtener los rodeos pertenecientes a un campo o usuario específico.
     *
     * - Si el ID pertenece a un usuario, traerá los rodeos de todos sus campos.
     * - Si el ID pertenece a un campo, traerá solo los rodeos de ese campo.
     * - Si el parámetro `batch` es true, solo trae rodeos con batch asignado.
     * - Si el parámetro `transfer` es true, devuelve el nombre del batch como `data`.
     *
     * @param int $id ID del campo o usuario
     * @param Request $request
     * @return array
     */
    public function getRodeos($id, Request $request)
    {
        $conn = DB::connection('mysql_admin');

        // Verificar si el ID pertenece a un usuario
        $userExists = $conn->table('users')->where('id', $id)->exists();

        // Construir la base del query
        $query = $conn->table('rodeos')
            ->leftJoin('batches', 'batches.id', '=', 'rodeos.batch_id')
            ->leftJoin('fields', 'fields.id', '=', 'rodeos.field_id')
            ->select(
                'rodeos.id',
                'rodeos.name',
                'rodeos.batch_id',
                'batches.name as batch_name'
            );

        // Si el ID es de un usuario, filtrar por user_id, si no, por field_id
        if ($userExists) {
            $query->where('fields.user_id', $id);
        } else {
            $query->where('rodeos.field_id', $id);
        }

        // Filtrar solo rodeos con batch asignado (si aplica)
        if ($request->boolean('batch')) {
            $query->whereNotNull('rodeos.batch_id');
        }

        $rodeos = $query->get();

        // Armar respuesta
        $array = [];
        foreach ($rodeos as $item) {
            $array[] = [
                'id' => $item->id,
                'name' => $item->name,
                'data' => $request->boolean('transfer') ? $item->batch_name : $item->batch_id,
            ];
        }

        return $array;
    }

    /**
     * Obtener los stocks pertenecientes a un rodeo específico,
     * generando un registro por cada índice (IDV y EID) si existen.
     *
     * @param int $id ID del rodeo
     * @param Request $request
     * @return array
     */
    public function getStocks($id, Request $request)
    {
        $stocks = DB::connection('mysql_admin')
            ->table('stocks')
            ->where('stocks.rodeo_id', $id)
            ->select('stocks.id', 'stocks.index_idv', 'stocks.index_eid')
            ->get();

        $array = [];

        foreach ($stocks as $item) {
            // Construimos un string que combine ambos índices si existen
            $nameParts = [];
            if ($item->index_idv) {
                $nameParts[] = "IDV: {$item->index_idv}";
            }
            if ($item->index_eid) {
                $nameParts[] = "EID: {$item->index_eid}";
            }

            // Si no hay ninguno, mostramos "Sin identificación"
            $name = !empty($nameParts) ? implode(' | ', $nameParts) : 'Sin identificación';

            $array[] = [
                'id' => $item->id,
                'name' => $name,
                'type' => $item->index_idv ? 'IDV' : ($item->index_eid ? 'EID' : null),
                'index' => $item->index_idv ?? $item->index_eid ?? null,
            ];
        }

        return $array;
    }

    /**
     * Obtener la lista de servicios disponibles.
     *
     * @return array
     */
    public function getServices()
    {
        $services = DB::connection('mysql_admin')->table('services')->select('id', 'name', 'description')->get();

        $array = [];

        foreach ($services as $item) {
            $array[] = [
                'id' => $item->id,
                'name' => "{$item->name} - {$item->description}",
                'data' => null,
            ];
        }

        return $array;
    }

    /**
     * Obtener los lotes (batches) asociados a un campo.
     * Solo se listan aquellos que no estén vinculados a un rodeo.
     *
     * @param int $id ID del campo
     * @return array
     */
    public function getBatches($id)
    {
        $batches = DB::connection('mysql_admin')->table('batches')->where('field_id', $id)->whereNull('rodeo_id')->select('id', 'name')->get();

        $array = [];

        foreach ($batches as $item) {
            $array[] = [
                'id' => $item->id,
                'name' => $item->name,
                'data' => null,
            ];
        }

        return $array;
    }

    /**
     * Obtener los recursos de forraje asociados a una región.
     *
     * @param int $id ID de la región
     * @return array
     */
    public function getForageResources($id)
    {
        $forageResources = DB::connection('mysql_admin')->table('forage_resources')->where('region_id', $id)->select('id', 'name')->get();

        $array = [];

        foreach ($forageResources as $item) {
            $array[] = [
                'id' => $item->id,
                'name' => $item->name,
                'data' => null,
            ];
        }

        return $array;
    }
}
