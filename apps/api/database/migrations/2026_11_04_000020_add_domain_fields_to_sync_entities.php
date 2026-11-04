<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        if (Schema::hasTable('categories')) {
            Schema::table('categories', function (Blueprint $table) {
                if (! Schema::hasColumn('categories', 'icon')) {
                    $table->string('icon')->nullable()->after('name');
                }
                if (! Schema::hasColumn('categories', 'color')) {
                    $table->string('color', 32)->nullable()->after('icon');
                }
            });
        }

        if (Schema::hasTable('shopping_lists') && ! Schema::hasColumn('shopping_lists', 'store_location')) {
            Schema::table('shopping_lists', function (Blueprint $table) {
                $table->string('store_location')->nullable()->after('notes');
            });
        }

        if (Schema::hasTable('list_items')) {
            Schema::table('list_items', function (Blueprint $table) {
                if (! Schema::hasColumn('list_items', 'unit_id')) {
                    $table->uuid('unit_id')->nullable()->index()->after('product_id');
                }
                if (! Schema::hasColumn('list_items', 'unit_abbr')) {
                    $table->string('unit_abbr', 16)->nullable()->after('unit_id');
                }
            });
        }

        if (Schema::hasTable('purchase_histories') && ! Schema::hasColumn('purchase_histories', 'store_location')) {
            Schema::table('purchase_histories', function (Blueprint $table) {
                $table->string('store_location')->nullable()->after('shopping_list_id');
            });
        }

        if (Schema::hasTable('purchase_history_items') && ! Schema::hasColumn('purchase_history_items', 'unit_abbr')) {
            Schema::table('purchase_history_items', function (Blueprint $table) {
                $table->string('unit_abbr', 16)->nullable()->after('name');
            });
        }
    }

    public function down(): void
    {
        if (Schema::hasColumn('categories', 'icon')) {
            Schema::table('categories', function (Blueprint $table) {
                $table->dropColumn(['icon', 'color']);
            });
        }
        if (Schema::hasColumn('shopping_lists', 'store_location')) {
            Schema::table('shopping_lists', function (Blueprint $table) {
                $table->dropColumn('store_location');
            });
        }
        if (Schema::hasColumn('list_items', 'unit_id')) {
            Schema::table('list_items', function (Blueprint $table) {
                $table->dropColumn(['unit_id', 'unit_abbr']);
            });
        }
        if (Schema::hasColumn('purchase_histories', 'store_location')) {
            Schema::table('purchase_histories', function (Blueprint $table) {
                $table->dropColumn('store_location');
            });
        }
        if (Schema::hasColumn('purchase_history_items', 'unit_abbr')) {
            Schema::table('purchase_history_items', function (Blueprint $table) {
                $table->dropColumn('unit_abbr');
            });
        }
    }
};
