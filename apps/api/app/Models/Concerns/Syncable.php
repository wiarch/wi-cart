<?php

namespace App\Models\Concerns;

use Illuminate\Database\Eloquent\Concerns\HasUuids;

trait Syncable
{
    use HasUuids;

    public function initializeSyncable(): void
    {
        $this->casts = array_merge($this->casts ?? [], [
            'client_updated_at' => 'datetime',
            'deleted_at' => 'datetime',
        ]);
    }

    public function toSyncArray(): array
    {
        return $this->toArray();
    }
}
