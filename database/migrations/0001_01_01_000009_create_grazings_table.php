<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     *
     * Crea la tabla 'grazings', que registra los eventos de pastoreo realizados por un usuario
     * en un rodeo, dentro de una región y con un tipo de pastoreo específico.
     */
    public function up(): void
    {
        // Si la tabla ya existe, no hacer nada
        if (Schema::hasTable('grazings')) {
            return;
        }
        Schema::create('grazings', function (Blueprint $table) {
            // Identificador principal tipo UUID
            $table->uuid('id')->primary()->comment('ID único del registro de pastoreo');

            // Relaciones (todas con UUID para consistencia y escalabilidad)
            $table->uuid('user_id')->comment('ID del usuario propietario del registro');
            $table->uuid('rodeo_id')->comment('ID del rodeo asociado');
            $table->uuid('region_id')->comment('ID de la región donde se realiza el pastoreo');
            $table->uuid('forage_resource_id')->comment('ID de la base de recursos donde se realiza el pastoreo (relación con region)');
            $table->uuid('grazing_id')->comment('ID del tipo de pastoreo (relación con type_grazings)');

            // Fechas de entrada y salida al potrero
            $table->date('input_date')->nullable()->comment('Fecha de ingreso al área de pastoreo');
            $table->date('output_date')->nullable()->comment('Fecha de salida del área de pastoreo');

            // Fechas de creación y actualización
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     *
     * Elimina la tabla 'grazings'.
     */
    public function down(): void
    {
        Schema::dropIfExists('grazings');
    }
};
