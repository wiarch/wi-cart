<?php

namespace App\Models;

use App\Models\Concerns\Syncable;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;

class Unit extends Model
{
    use SoftDeletes, Syncable;

    protected $fillable = [
        'id',
        'user_id',
        'device_id',
        'name',
        'abbreviation',
        'client_updated_at',
        'created_at',
        'updated_at',
        'deleted_at',
    ];

    public $incrementing = false;

    protected $keyType = 'string';
}
