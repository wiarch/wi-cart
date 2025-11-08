<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     * Crea la tabla 'modules' que almacena los módulos disponibles en la aplicación.
     */
    public function up(): void
    {
        Schema::create('modules', function (Blueprint $table) {
            // Clave primaria tipo UUID
            $table->uuid('id')->primary()->comment('Identificador único del módulo');

            // Nombre del módulo
            $table->string('name')->comment('Nombre del módulo');

            // Timestamps para control de creación y actualización
            $table->timestamps();

        });
    }

    /**
     * Reverse the migrations.
     * Elimina la tabla 'modules' en caso de rollback.
     */
    public function down(): void
    {
        Schema::dropIfExists('modules');
    }
};
