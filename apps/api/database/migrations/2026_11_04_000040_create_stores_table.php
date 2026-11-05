<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        if (! Schema::hasTable('stores')) {
            Schema::create('stores', function (Blueprint $table) {
                $table->uuid('id')->primary();
                $table->foreignUuid('user_id')->constrained('users')->cascadeOnDelete();
                $table->string('device_id')->nullable()->index();
                $table->timestamp('client_updated_at', 3);
                $table->timestamps(3);
                $table->softDeletes('deleted_at', 3);
                $table->index(['user_id', 'updated_at']);
                $table->index(['user_id', 'client_updated_at']);
                $table->string('name');
                $table->string('icon', 64)->nullable();
                $table->text('notes')->nullable();
            });
        }

        if (Schema::hasTable('shopping_lists') && ! Schema::hasColumn('shopping_lists', 'store_id')) {
            Schema::table('shopping_lists', function (Blueprint $table) {
                $table->uuid('store_id')->nullable()->index()->after('icon');
            });
        }
    }

    public function down(): void
    {
        if (Schema::hasColumn('shopping_lists', 'store_id')) {
            Schema::table('shopping_lists', function (Blueprint $table) {
                $table->dropColumn('store_id');
            });
        }
        Schema::dropIfExists('stores');
    }
};
