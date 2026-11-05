<?php

namespace App\Http\Controllers;

use App\Models\User;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Http;
use Illuminate\Support\Str;
use Illuminate\Validation\ValidationException;

class AuthController extends Controller
{
    public function google(Request $request): JsonResponse
    {
        $data = $request->validate([
            'id_token' => ['required', 'string'],
            'device_name' => ['nullable', 'string', 'max:255'],
        ]);

        $response = Http::timeout(10)->get('https://oauth2.googleapis.com/tokeninfo', [
            'id_token' => $data['id_token'],
        ]);

        $claims = $response->ok() ? $response->json() : [];
        $validAud = in_array($claims['aud'] ?? null, config('services.google.client_ids'), true);
        $validIss = in_array($claims['iss'] ?? null, ['accounts.google.com', 'https://accounts.google.com'], true);
        $verified = filter_var($claims['email_verified'] ?? false, FILTER_VALIDATE_BOOLEAN);

        if (! $validAud || ! $validIss || ! $verified || empty($claims['sub']) || empty($claims['email'])) {
            throw ValidationException::withMessages([
                'id_token' => ['Token de Google inválido.'],
            ]);
        }

        $email = $claims['email'];
        $user = User::where('google_id', $claims['sub'])->first()
            ?? User::where('email', $email)->first()
            ?? new User();

        $user->google_id = $claims['sub'];
        $user->email = $email;
        $user->name = $claims['name'] ?? $user->name ?? Str::before($email, '@');
        $user->avatar_url = $claims['picture'] ?? $user->avatar_url;
        $user->email_verified_at ??= now();
        $user->username ??= $this->uniqueUsername(Str::before($email, '@'));
        // Google users never log in with a password; random value keeps the NOT NULL column satisfied.
        $user->password ??= Str::random(64);
        $user->save();

        $token = $user->createToken($data['device_name'] ?? 'mobile')->plainTextToken;

        return response()->json([
            'user' => $user,
            'token' => $token,
        ]);
    }

    public function logout(Request $request): JsonResponse
    {
        $request->user()->currentAccessToken()->delete();

        return response()->json(['ok' => true]);
    }

    public function me(Request $request): JsonResponse
    {
        return response()->json(['user' => $request->user()]);
    }

    private function uniqueUsername(string $seed): string
    {
        $base = Str::of($seed)->lower()->ascii()->replaceMatches('/[^a-z0-9_]/', '')->limit(20, '')->toString();
        if (strlen($base) < 3) {
            $base = 'user';
        }

        $candidate = $base;
        while (User::where('username', $candidate)->exists()) {
            $candidate = $base.random_int(1000, 99999999);
        }

        return $candidate;
    }
}
