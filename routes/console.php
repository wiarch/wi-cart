<?php

use Illuminate\Foundation\Inspiring;
use Illuminate\Support\Facades\Artisan;

Artisan::command('inspire', function () {
    $this->comment(Inspiring::quote());


    
})->purpose('Display an inspiring quote');



Artisan::command('cache:wipe', function () {
    $this->info("🧹 Iniciando limpieza de cachés y optimización...\n");

    // 1️⃣ 🗂️ Borrar archivos compilados de bootstrap/cache (opcional)
    // $this->info("1️⃣ 🗂️ Borrando archivos compilados...");
    // exec('php artisan optimize:clear', $output1);
    // foreach ($output1 as $line) {
    //     $this->line("   → $line");
    // }

    // 2️⃣ 🔧 Regenerar autoload de Composer
    $this->info("2️⃣ 🔧 Ejecutando: composer dump-autoload");
    exec('composer dump-autoload', $output2);
    foreach ($output2 as $line) {
        $this->line("   → $line");
    }

    // 3️⃣ ⚙️ Limpiar caché de configuración
    $this->info("3️⃣ ⚙️ Limpiando caché de configuración");
    exec('php artisan config:clear', $output3);
    foreach ($output3 as $line) {
        $this->line("   → $line");
    }

    // 4️⃣ 🧠 Limpiar caché de aplicación
    $this->info("4️⃣ 🧠 Limpiando caché de aplicación");
    exec('php artisan cache:clear', $output4);
    foreach ($output4 as $line) {
        $this->line("   → $line");
    }

    // 5️⃣ 🖼️ Limpiar vistas compiladas
    $this->info("5️⃣ 🖼️ Limpiando vistas compiladas");
    exec('php artisan view:clear', $output5);
    foreach ($output5 as $line) {
        $this->line("   → $line");
    }

    // 6️⃣ 🗺️ Limpiar caché de rutas
    $this->info("6️⃣ 🗺️ Limpiando caché de rutas");
    exec('php artisan route:clear', $output6);
    foreach ($output6 as $line) {
        $this->line("   → $line");
    }

    // 7️⃣ 🔁 Limpiar caché de eventos (opcional)
    // $this->info("7️⃣ 🔁 Limpiando caché de eventos...");
    // exec('php artisan event:clear', $output7);
    // foreach ($output7 as $line) {
    //     $this->line("   → $line");
    // }

    // 8️⃣ 🕒 Limpiar caché de programación (opcional)
    // $this->info("8️⃣ 🕒 Limpiando caché de programación de tareas...");
    // exec('php artisan schedule:clear-cache', $output8);
    // foreach ($output8 as $line) {
    //     $this->line("   → $line");
    // }

    // 9️⃣ 🧵 Reiniciar workers de colas (opcional)
    // $this->info("9️⃣ 🧵 Reiniciando workers de colas...");
    // exec('php artisan queue:restart', $output9);
    // foreach ($output9 as $line) {
    //     $this->line("   → $line");
    // }

    // 🔟 🗃️ Limpiar archivos de log (opcional)
    // $this->info("🔟 🗃️ Eliminando archivos de log...");
    // exec('rm -f storage/logs/*.log', $output10);
    // $this->line("   → Archivos de log eliminados.");

    // 1️⃣1️⃣ ⚡ Optimizar archivos de arranque (opcional)
    $this->info("1️⃣1️⃣ ⚡ Ejecutando: php artisan optimize");
    exec('php artisan optimize', $output11);
    foreach ($output11 as $line) {
        $this->line("   → $line");
    }

    // 1️⃣2️⃣ 🚀 Generar caché de configuración (para producción)
    // $this->info("1️⃣2️⃣ 🚀 Generando caché de configuración...");
    // exec('php artisan config:cache', $output12);
    // foreach ($output12 as $line) {
    //     $this->line("   → $line");
    // }

    // 1️⃣3️⃣ 🌐 Regenerar caché de entorno (.env) (opcional)
    // $this->info("1️⃣3️⃣ 🌐 Regenerando caché de entorno...");
    // exec('php artisan env:cache', $output13);
    // foreach ($output13 as $line) {
    //     $this->line("   → $line");
    // }

    $this->info("\n✅ Proceso completado: Todas las cachés fueron limpiadas correctamente.");
})->describe('🧼 Limpia toda la caché y optimiza la aplicación (ordenado y con extras opcionales)');
