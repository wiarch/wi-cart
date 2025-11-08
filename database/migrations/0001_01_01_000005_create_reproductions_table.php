<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration {
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('reproductions', function (Blueprint $table) {
            $table->uuid('id')->primary();
            $table->uuid('user_id');
            // $table->uuid('field_id')->nullable();
            // $table->uuid('rodeo_id')->nullable();
            $table->uuid('stock_id')->nullable();
            $table->integer('type_reproduction');
            $table->uuid('type_animal_id');

            // parto
            $table->date('date_birth')->nullable();
            $table->boolean('gender')->nullable();
            $table->integer('weight')->nullable();
            $table->longText('observation_birth')->nullable();
            $table->longText('diagnostic_birth')->nullable();

            // pre-servicio
            $table->date('date_pre_service')->nullable();
            $table->longText('diagnostic_pre_service')->nullable();
            $table->longText('cc_pre_service')->nullable(); // cc = body_condition (condición corporal)
            $table->date('date_insemination')->nullable();
            $table->string('bull')->nullable();

            // ecografia
            $table->date('date_ecography')->nullable();
            $table->longText('diagnostic_ecography')->nullable();
            $table->longText('cc_ecography')->nullable();

            // tacto
            $table->date('date_touch')->nullable();
            $table->longText('diagnostic_touch')->nullable();
            $table->longText('cc_touch')->nullable();

            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('reproductions');
    }
};
