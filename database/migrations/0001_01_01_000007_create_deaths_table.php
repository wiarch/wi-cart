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
        Schema::create('deaths', function (Blueprint $table) {
            $table->uuid('id')->primary();
            $table->uuid('user_id');
            $table->uuid('field_id');
            $table->uuid('rodeo_id');
            $table->uuid('stock_id');
            $table->uuid('type_animal_id');
            $table->boolean('type_death');
            $table->date('date');
            $table->integer('guide_number')->nullable();
            $table->date('date_sale')->nullable();
            $table->longText('diagnostic')->nullable();
            $table->longText('observation')->nullable();
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('deaths');
    }
};
