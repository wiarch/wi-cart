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
        Schema::create('sanitary', function (Blueprint $table) {
            $table->uuid('id')->primary();
            $table->uuid('user_id');
            $table->uuid('field_id')->nullable();
            $table->uuid('stock_id')->nullable();
            $table->uuid('rodeo_id')->nullable();
            $table->uuid('type_animal_id');
            $table->uuid('treatment_code_id');
            $table->date('date');
            $table->boolean('type_sanitary');
            $table->integer('dose');
            $table->integer('serial_number');
            $table->date('date_expiration');
            $table->string('mark');
            $table->string('retirement');
            $table->longText('diagnostic');
            $table->longText('observation');
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('sanitary');
    }
};
