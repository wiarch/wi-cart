<?php

namespace App\Traits;

use Illuminate\Support\Collection;

trait StockIndexTrait
{
    /**
     * Convierte una colección de stocks en registros separados por cada índice (IDV / EID).
     *
     * Si un stock tiene ambos índices, se generan dos registros distintos.
     *
     * @param Collection $stocks
     * @param string|null $idColumn Nombre de la columna de ID en la colección, por defecto 'id'
     * @return array
     */
    public function separateStockIndexes(Collection $stocks, string $idColumn = 'id'): array
    
    {
        $array = [];

        foreach ($stocks as $item) {
            $stockId = $item->{$idColumn} ?? null;

            if (!empty($item->index_idv)) {
                $array[] = [
                    'id' => $stockId,
                    'name' => "IDV: {$item->index_idv}",
                    'type' => 'IDV',
                    'index' => $item->index_idv,
                ];
            }

            if (!empty($item->index_eid)) {
                $array[] = [
                    'id' => $stockId,
                    'name' => "EID: {$item->index_eid}",
                    'type' => 'EID',
                    'index' => $item->index_eid,
                ];
            }

            if (empty($item->index_idv) && empty($item->index_eid)) {
                $array[] = [
                    'id' => $stockId,
                    'name' => "Sin identificación",
                    'type' => null,
                    'index' => null,
                ];
            }
        }

        return $array;
    }
}
