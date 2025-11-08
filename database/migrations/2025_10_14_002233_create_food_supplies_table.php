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
        Schema::create('food_supplies', function (Blueprint $table) {
            $table->uuid('id')->primary()->comment('ID único del registro de suministros');
            $table->timestamps();
            $table->uuid('code_tratment_id');
            $table->decimal('stock_init', 10, 2)->default(0);
            $table->decimal('stock_end', 10, 2)->default(0);
            $table->decimal('consumed', 10, 2)->default(0);
            // batch_id eliminado por requerimiento; mantenemos consumed y stock_end en la tabla
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('food_supplies');
    }
};
