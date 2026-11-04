<?php

namespace App\Models;

use App\Models\Concerns\Syncable;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;

class PurchaseHistoryItem extends Model
{
    use SoftDeletes, Syncable;

    protected $fillable = [
        'id',
        'user_id',
        'device_id',
        'purchase_history_id',
        'product_id',
        'name',
        'unit_abbr',
        'quantity',
        'unit_price',
        'line_total',
        'client_updated_at',
        'created_at',
        'updated_at',
        'deleted_at',
    ];

    public $incrementing = false;

    protected $keyType = 'string';

    protected function casts(): array
    {
        return [
            'quantity' => 'decimal:3',
            'unit_price' => 'decimal:2',
            'line_total' => 'decimal:2',
            'client_updated_at' => 'datetime',
            'deleted_at' => 'datetime',
        ];
    }
}
