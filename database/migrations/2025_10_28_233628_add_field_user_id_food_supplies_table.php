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
        Schema::table('food_supplies', function (Blueprint $table) {
            $table->uuid('user_id')->comment('ID del usuario propietario del registro');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('food_supplies', function (Blueprint $table) {
            $table->dropColumn('user_id');
        });
    }
};
