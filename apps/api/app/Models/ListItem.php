<?php

namespace App\Models;

use App\Models\Concerns\Syncable;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;

class ListItem extends Model
{
    use SoftDeletes, Syncable;

    protected $fillable = [
        'id',
        'user_id',
        'device_id',
        'shopping_list_id',
        'product_id',
        'unit_id',
        'unit_abbr',
        'name',
        'qty_planned',
        'qty_bought',
        'unit_price',
        'status',
        'notes',
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
            'qty_planned' => 'decimal:3',
            'qty_bought' => 'decimal:3',
            'unit_price' => 'decimal:2',
            'client_updated_at' => 'datetime',
            'deleted_at' => 'datetime',
        ];
    }
}
