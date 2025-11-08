<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;

class ModulesSeeder extends Seeder
{
    /**
     * Ejecuta los seeders de la tabla "modules".
     *
     * Inserta los módulos iniciales en la base de datos con UUIDs únicos
     * y timestamps de creación y actualización.
     */
    public function run(): void
    {
        // Timestamp actual para created_at y updated_at
        $now = now();

        // Definición de módulos a insertar
        $modules = [
            ['name' => 'Stocks'],
            // Aquí puedes agregar más módulos en el futuro
        ];

        // Mapear los módulos para incluir ID y timestamps
        $insertData = array_map(function ($module) use ($now) {
            return [
                'id'         => Str::uuid()->toString(), // UUID único
                'name'       => $module['name'],
                'created_at' => $now,
                'updated_at' => $now,
            ];
        }, $modules);

        // Insertar los datos en la tabla "modules"
        DB::table('modules')->insert($insertData);
    }
}
