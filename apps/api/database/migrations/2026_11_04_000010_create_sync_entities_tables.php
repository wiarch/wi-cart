<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        $syncColumns = function (Blueprint $table): void {
            $table->uuid('id')->primary();
            $table->foreignUuid('user_id')->constrained('users')->cascadeOnDelete();
            $table->string('device_id')->nullable()->index();
            $table->timestamp('client_updated_at', 3);
            $table->timestamps(3);
            $table->softDeletes('deleted_at', 3);
            $table->index(['user_id', 'updated_at']);
            $table->index(['user_id', 'client_updated_at']);
        };

        Schema::create('categories', function (Blueprint $table) use ($syncColumns) {
            $syncColumns($table);
            $table->string('name');
            $table->string('icon')->nullable();
            $table->string('color', 32)->nullable();
        });

        Schema::create('units', function (Blueprint $table) use ($syncColumns) {
            $syncColumns($table);
            $table->string('name');
            $table->string('abbreviation', 16)->nullable();
        });

        Schema::create('products', function (Blueprint $table) use ($syncColumns) {
            $syncColumns($table);
            $table->string('name');
            $table->text('description')->nullable();
            $table->uuid('category_id')->nullable()->index();
            $table->uuid('unit_id')->nullable()->index();
            $table->decimal('base_price', 12, 2)->nullable();
            $table->string('image_path')->nullable();
            $table->boolean('image_pending')->default(false);
        });

        Schema::create('shopping_lists', function (Blueprint $table) use ($syncColumns) {
            $syncColumns($table);
            $table->string('name');
            $table->string('status')->default('active'); // active|completed
            $table->text('notes')->nullable();
            $table->string('store_location')->nullable();
        });

        Schema::create('list_items', function (Blueprint $table) use ($syncColumns) {
            $syncColumns($table);
            $table->uuid('shopping_list_id')->index();
            $table->uuid('product_id')->nullable()->index();
            $table->uuid('unit_id')->nullable()->index();
            $table->string('unit_abbr', 16)->nullable();
            $table->string('name');
            $table->decimal('qty_planned', 12, 3)->default(1);
            $table->decimal('qty_bought', 12, 3)->nullable();
            $table->decimal('unit_price', 12, 2)->nullable();
            $table->string('status')->default('pending'); // pending|in_cart
        });

        Schema::create('purchase_histories', function (Blueprint $table) use ($syncColumns) {
            $syncColumns($table);
            $table->uuid('shopping_list_id')->nullable()->index();
            $table->string('store_location')->nullable();
            $table->timestamp('purchased_at', 3);
            $table->decimal('total', 12, 2)->default(0);
        });

        Schema::create('purchase_history_items', function (Blueprint $table) use ($syncColumns) {
            $syncColumns($table);
            $table->uuid('purchase_history_id')->index();
            $table->uuid('product_id')->nullable()->index();
            $table->string('name');
            $table->string('unit_abbr', 16)->nullable();
            $table->decimal('quantity', 12, 3)->default(1);
            $table->decimal('unit_price', 12, 2)->nullable();
            $table->decimal('line_total', 12, 2)->nullable();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('purchase_history_items');
        Schema::dropIfExists('purchase_histories');
        Schema::dropIfExists('list_items');
        Schema::dropIfExists('shopping_lists');
        Schema::dropIfExists('products');
        Schema::dropIfExists('units');
        Schema::dropIfExists('categories');
    }
};
