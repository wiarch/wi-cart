<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        if (Schema::hasTable('stores') && ! Schema::hasColumn('stores', 'location')) {
            Schema::table('stores', function (Blueprint $table) {
                $table->string('location')->nullable()->after('name');
            });
        }
    }

    public function down(): void
    {
        if (Schema::hasColumn('stores', 'location')) {
            Schema::table('stores', function (Blueprint $table) {
                $table->dropColumn('location');
            });
        }
    }
};
