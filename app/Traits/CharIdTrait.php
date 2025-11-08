<?php

namespace App\Traits;

use Illuminate\Support\Str;
use Illuminate\Support\Facades\DB;

trait CharIdTrait
{
    /**
     * Genera un UUID único que no exista en la tabla y columna dadas.
     *
     * @param string $table   Nombre de la tabla.
     * @param string $column  Nombre de la columna.
     * @return string         UUID único.
     */
    public function generateUniqueCharId(string $table, string $column, string $db = 'mysql'): string
    {
        do {
            $uuid = Str::uuid()->toString();
            $exists = DB::connection($db)->table($table)->where($column, $uuid)->exists();
        } while ($exists);

        return $uuid;
    }
}
