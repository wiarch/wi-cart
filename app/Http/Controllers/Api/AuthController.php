<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Traits\ApiResponseTrait;
use App\Traits\GenerateCodeTrait;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Hash;

/**
 * Controlador de autenticación vía API
 *
 * Maneja login de usuarios, verificación de email y dispositivos.
 */
class AuthController extends Controller
{
    use ApiResponseTrait;
    use GenerateCodeTrait;

    /**
     * Login de usuario vía API
     *
     * Valida email, contraseña, dispositivo y código de verificación.
     *
     * @param Request $request
     * @return \Illuminate\Http\JsonResponse
     */
    public function login(Request $request)
    {
        // Validar datos de entrada
        $validated = $request->validate([
            'email'        => 'required|email',
            'password'     => 'required|string|min:6',
            'device_id'    => 'required|string',
            'token_verify' => 'nullable|string',
        ]);

        // Buscar usuario por email
        $user = DB::connection('mysql_admin')->table('users')
            ->where('email', $validated['email'])
            ->first();

        if (!$user) {
            return $this->errorResponse('Correo no encontrado', 404);
        }

        // Verificar contraseña
        if (!Hash::check($validated['password'], $user->password)) {
            return $this->errorResponse('Contraseña incorrecta', 401);
        }

        $deviceId = $validated['device_id'];

        // Revisar si el dispositivo ya existe
        $userDevice = DB::connection('mysql_admin')->table('history_device_has_users')
            ->where('user_id', $user->id) // UUID
            ->where('expo_token', $deviceId)
            ->first();

        // Si se envía token_verify, validar código
        if (!empty($validated['token_verify'])) {
            if ($user->remember_token !== $validated['token_verify']) {
                return $this->errorResponse('Código de verificación inválido', 403);
            }

            // Actualizar email verificado
            DB::connection('mysql_admin')->table('users')
                ->where('id', $user->id)
                ->update([
                    'email_verified_at' => now(),
                    'updated_at'       => now(),
                ]);

            // Registrar o actualizar dispositivo
            $this->updateOrInsertDevice($user->id, $deviceId, $userDevice);
        } else {
            // Validar email y dispositivo si no hay token_verify
            if (empty($user->email_verified_at)) {
                $this->generateCode($user->id);
                return $this->successResponse('Debe verificar su correo', [], 403);
            }

            if (!$userDevice) {
                $this->generateCode($user->id);
                return $this->successResponse('Debe verificar su dispositivo', [], 403);
            }

            // Actualizar last_login_at si el dispositivo ya existía
            $this->updateOrInsertDevice($user->id, $deviceId, $userDevice);
        }

        // Generar o actualizar token de sesión
        $token = $this->createOrUpdateToken($user->id, 'login', $deviceId, true);

        return $this->successResponse('Login exitoso', [], $token);
    }

    /**
     * Actualiza o inserta un registro de dispositivo para el usuario
     *
     * @param string $userId UUID del usuario
     * @param string $deviceId
     * @param object|null $userDevice
     */
    private function updateOrInsertDevice(string $userId, string $deviceId, ?object $userDevice): void
    {
        if ($userDevice) {
            DB::connection('mysql_admin')->table('history_device_has_users')
                ->where('id', $userDevice->id)
                ->update([
                    'last_login_at' => now(),
                    'updated_at'    => now(),
                ]);
        } else {
            DB::connection('mysql_admin')->table('history_device_has_users')
                ->insert([
                    'id'            => $this->generateUniqueCharId('history_device_has_users', 'id', 'mysql_admin'),
                    'expo_token'    => $deviceId,
                    'user_id'       => $userId,
                    'last_login_at' => now(),
                    'created_at'    => now(),
                    'updated_at'    => now(),
                ]);
        }
    }
}
