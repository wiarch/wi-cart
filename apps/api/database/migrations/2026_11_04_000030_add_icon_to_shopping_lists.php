<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        if (Schema::hasTable('shopping_lists') && ! Schema::hasColumn('shopping_lists', 'icon')) {
            Schema::table('shopping_lists', function (Blueprint $table) {
                $table->string('icon', 64)->nullable()->after('notes');
            });
        }
    }

    public function down(): void
    {
        if (Schema::hasColumn('shopping_lists', 'icon')) {
            Schema::table('shopping_lists', function (Blueprint $table) {
                $table->dropColumn('icon');
            });
        }
    }
};
