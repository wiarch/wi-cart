<?php

namespace App\Traits;

use Illuminate\Support\Facades\DB;

trait LogTrait
{
    use CharIdTrait;

    public function registerLogEntry(string $module, string $description, array $ids): void
    {
        DB::table('logs')->insert([
            'id' => $this->generateUniqueCharId('logs', 'id', 'mysql'),
            'user_id' => session()->get('user')->id,
            'module_id' => $module,
            'description' => $description,
            'ids' => json_encode($ids),
            'created_at' => now(),
            'updated_at' => now(),
        ]);
    }
}
