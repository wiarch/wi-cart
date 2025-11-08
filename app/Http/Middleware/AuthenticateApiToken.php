<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Support\Facades\DB;

class AuthenticateApiToken
{
    public function handle($request, Closure $next)
    {
        $token = $request->bearerToken(); // Token desde header Authorization

        if (!$token) {
            return response()->json(['message' => 'Token requerido'], 401);
        }

        $user = DB::connection('mysql_admin')
            ->table('personal_access_tokens')
            ->where('token', $token)
            ->first();

        if (!$user) {
            return response()->json(['message' => 'Token inválido'], 401);
        }

        // Guardamos usuario para acceso global
        $request->user = $user;

        return $next($request);
    }
}
