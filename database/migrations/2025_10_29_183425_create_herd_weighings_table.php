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
        Schema::create('herd_weighings', function (Blueprint $table) {
            $table->uuid('id')->primary();
            $table->date('weighing_date')->nullable();
            $table->uuid('type_animal_id')->nullable()->comment('ID del tipo de animal');
            $table->string('vid_eid')->nullable()->comment('VID/EID del animal');
            $table->decimal('weight', 10, 2)->nullable()->comment('Peso del animal');
            $table->uuid('user_id')->comment('ID del usuario propietario del registro');
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('herd_weighings');
    }
};
