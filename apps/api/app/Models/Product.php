<?php

namespace App\Models;

use App\Models\Concerns\Syncable;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;

class Product extends Model
{
    use SoftDeletes, Syncable;

    protected $fillable = [
        'id',
        'user_id',
        'device_id',
        'name',
        'description',
        'category_id',
        'unit_id',
        'base_price',
        'image_path',
        'image_pending',
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
            'base_price' => 'decimal:2',
            'image_pending' => 'boolean',
            'client_updated_at' => 'datetime',
            'deleted_at' => 'datetime',
        ];
    }
}
