<?php

namespace App\Traits;

use Illuminate\Http\JsonResponse;
use Illuminate\Support\Str;
use Illuminate\Support\Facades\DB;
use App\Traits\CharIdTrait;

trait ApiResponseTrait
{
    use CharIdTrait;
    /**
     * Respuesta de éxito estandarizada.
     */
    public function successResponse(string $message, array $data = [], ?string $token = null): \Illuminate\Http\JsonResponse
    {
        $response = [
            'success' => true,
            'message' => $message,
        ];

        if (!empty($data)) {
            $response['data'] = $data;
        }

        if ($token !== null) {
            $response['token'] = $token;
        }

        return response()->json($response, 200, [], JSON_UNESCAPED_UNICODE);
    }

    /**
     * Respuesta de error estandarizada.
     */
    public function errorResponse(string $message = 'Ocurrió un error', int $statusCode = 400, array $errors = []): JsonResponse
    {
        $response = [
            'success' => false,
            'message' => $message,
        ];

        if (!empty($errors)) {
            $response['errors'] = $errors;
        }

        return response()->json($response, $statusCode, [], JSON_UNESCAPED_UNICODE);
    }

    /**
     * Crear o actualizar token de acceso en la tabla personal_access_tokens
     */ public function createOrUpdateToken($userId, $name, $device_id = null, $refreshToken = false)
    {
        // Revisar si el usuario ya tiene token
        $tokenRecord = DB::connection('mysql_admin')->table('personal_access_tokens')->where('tokenable_id', $userId)->first();

        // Generar token solo si necesitamos crear uno nuevo o forzar actualización
        $token = $tokenRecord && !$refreshToken ? $tokenRecord->token : hash('sha256', Str::random(60));

        if ($tokenRecord) {
            // Actualizar solo name y updated_at, opcionalmente token
            $updateData = [
                'name' => $name,
                'updated_at' => now(),
            ];

            if ($refreshToken) {
                $updateData['token'] = $token;
            }

            DB::connection('mysql_admin')->table('personal_access_tokens')->where('tokenable_id', $userId)->update($updateData);
        } else {
            // Insertar nuevo token
            DB::connection('mysql_admin')
                ->table('personal_access_tokens')
                ->insert([
                    'id' => $this->generateUniqueCharId('personal_access_tokens', 'id', 'mysql_admin'),
                    'tokenable_type' => 'login',
                    'tokenable_id' => $userId,
                    'name' => $name,
                    'token' => $token,
                    'created_at' => now(),
                    'updated_at' => now(),
                ]);
        }

        // Manejo de dispositivos solo si se pasan parámetros
        if ($device_id) {
            $deviceRecord = DB::connection('mysql_admin')->table('history_device_has_users')->where('expo_token', $device_id)->first();

            if ($deviceRecord) {
                DB::connection('mysql_admin')
                    ->table('history_device_has_users')
                    ->where('expo_token', $device_id)
                    ->update([
                        'last_login_at' => now(),
                    ]);
            } else {
                DB::connection('mysql_admin')
                    ->table('history_device_has_users')
                    ->insert([
                        'id' => $this->generateUniqueCharId('history_device_has_users', 'id', 'mysql_admin'),
                        'expo_token' => $device_id,
                        'user_id' => $userId,
                        'last_login_at' => now(),
                        'created_at' => now(),
                        'updated_at' => now(),
                    ]);
            }
        }

        return $token;
    }
}
