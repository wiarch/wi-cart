<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     *
     * Crea las tablas principales del sistema:
     * - users: información básica de usuarios.
     * - password_reset_tokens: recuperación de contraseñas.
     * - sessions: control de sesiones activas.
     */
    public function up(): void
    {
        /**
         * Tabla: users
         * ------------------------------------------
         * Almacena la información de los usuarios registrados en el sistema.
         */
        Schema::create('users', function (Blueprint $table) {
            $table->uuid('id')->primary()->comment('ID único del usuario (UUID)');
            $table->string('name')->comment('Nombre completo del usuario');
            $table->string('email')->unique()->comment('Correo electrónico único');
            $table->timestamp('email_verified_at')->nullable()->comment('Fecha en que se verificó el correo electrónico');
            $table->string('password')->comment('Contraseña cifrada del usuario');
            $table->rememberToken()->comment('Token de autenticación para la opción "recordarme"');
            $table->timestamps(); // created_at y updated_at
        });

        /**
         * Tabla: password_reset_tokens
         * ------------------------------------------
         * Almacena los tokens temporales utilizados en la recuperación de contraseñas.
         */
        Schema::create('password_reset_tokens', function (Blueprint $table) {
            $table->string('email')->primary()->comment('Correo electrónico asociado al token');
            $table->string('token')->comment('Token temporal de recuperación de contraseña');
            $table->timestamp('created_at')->nullable()->comment('Fecha de creación del token');
        });

        /**
         * Tabla: sessions
         * ------------------------------------------
         * Guarda información de las sesiones activas de los usuarios.
         * Permite controlar la actividad y persistencia de autenticación.
         */
        Schema::create('sessions', function (Blueprint $table) {
            $table->string('id')->primary()->comment('ID único de la sesión');
            $table->uuid('user_id')->nullable()->index()->comment('ID del usuario autenticado (relación con users)');
            $table->string('ip_address', 45)->nullable()->comment('Dirección IP del usuario');
            $table->text('user_agent')->nullable()->comment('Información del dispositivo o navegador utilizado');
            $table->longText('payload')->comment('Datos serializados (JSON) de la sesión');
            $table->integer('last_activity')->index()->comment('Última actividad registrada (timestamp)');

            // Índice compuesto para consultas eficientes por usuario y actividad
            $table->index(['user_id', 'last_activity'], 'sessions_user_last_activity_index');
        });
    }

    /**
     * Reverse the migrations.
     *
     * Elimina las tablas creadas si existen.
     */
    public function down(): void
    {
        Schema::dropIfExists('sessions');
        Schema::dropIfExists('password_reset_tokens');
        Schema::dropIfExists('users');
    }
};
