<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('food_supply_treatment_codes', function (Blueprint $table) {
            $table->uuid('id')->primary();
            $table->uuid('food_supply_id');
            $table->uuid('treatment_code_id');
            $table->timestamps();

            $table->index('food_supply_id');
            $table->index('treatment_code_id');
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('food_supply_treatment_codes');
    }
};
