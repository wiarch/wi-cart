<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('supplies', function (Blueprint $table) {
            $table->uuid('id')->primary()->comment('ID único del registro de suministros');
            $table->string('name')->comment('Nombre del suministro');
            $table->integer('quantity')->comment('Cantidad del suministro');
            $table->string('unit')->comment('Unidad de medida del suministro');
            $table->date('date')->comment('Fecha del suministro');
            $table->uuid('batch_id');
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('supplies');
    }
};
