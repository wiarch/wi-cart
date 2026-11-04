<?php

namespace App\Models;

use App\Models\Concerns\Syncable;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;

class PurchaseHistory extends Model
{
    use SoftDeletes, Syncable;

    protected $fillable = [
        'id',
        'user_id',
        'device_id',
        'shopping_list_id',
        'store_location',
        'purchased_at',
        'total',
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
            'purchased_at' => 'datetime',
            'total' => 'decimal:2',
            'client_updated_at' => 'datetime',
            'deleted_at' => 'datetime',
        ];
    }
}
