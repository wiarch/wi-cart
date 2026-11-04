<?php

namespace Database\Seeders;

use App\Models\Category;
use App\Models\Unit;
use App\Models\User;
use Illuminate\Database\Seeder;
use Illuminate\Support\Str;

class DatabaseSeeder extends Seeder
{
    public function run(): void
    {
        $user = User::query()->firstOrCreate(
            ['email' => 'demo@wicart.local'],
            [
                'name' => 'Demo',
                'password' => 'password123',
            ]
        );

        $now = now();

        $units = [
            ['name' => 'Unidad', 'abbreviation' => 'un'],
            ['name' => 'Kilogramo', 'abbreviation' => 'kg'],
            ['name' => 'Gramo', 'abbreviation' => 'g'],
            ['name' => 'Litros', 'abbreviation' => 'lts'],
            ['name' => 'Mililitros', 'abbreviation' => 'ml'],
            ['name' => 'Paquete', 'abbreviation' => 'paquete'],
        ];

        foreach ($units as $u) {
            $exists = Unit::withTrashed()
                ->where('user_id', $user->id)
                ->where('abbreviation', $u['abbreviation'])
                ->exists();
            if ($exists) {
                continue;
            }
            Unit::create([
                'id' => (string) Str::uuid(),
                'user_id' => $user->id,
                'name' => $u['name'],
                'abbreviation' => $u['abbreviation'],
                'client_updated_at' => $now,
            ]);
        }

        $categories = [
            ['name' => 'Huevos, fruta y verdura', 'icon' => 'eco', 'color' => '#2E7D32'],
            ['name' => 'Comestibles', 'icon' => 'grocery', 'color' => '#F9A825'],
            ['name' => 'Lácteos', 'icon' => 'dairy', 'color' => '#1565C0'],
            ['name' => 'Limpieza', 'icon' => 'clean', 'color' => '#6A1B9A'],
        ];

        foreach ($categories as $c) {
            $exists = Category::withTrashed()
                ->where('user_id', $user->id)
                ->where('name', $c['name'])
                ->exists();
            if ($exists) {
                continue;
            }
            Category::create([
                'id' => (string) Str::uuid(),
                'user_id' => $user->id,
                'name' => $c['name'],
                'icon' => $c['icon'],
                'color' => $c['color'],
                'client_updated_at' => $now,
            ]);
        }
    }
}
