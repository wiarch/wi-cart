<?php

namespace App\Http\Controllers\Auth;

use App\Http\Controllers\Controller;
use App\Models\User;
use Illuminate\Support\Facades\Auth;
use Laravel\Socialite\Facades\Socialite;
use Illuminate\Support\Str;
use Exception;

class GoogleController extends Controller
{
    /**
     * Redirect the user to the Google authentication page.
     *
     * @return \Symfony\Component\HttpFoundation\RedirectResponse
     */
    public function redirectToGoogle()
    {
        return Socialite::driver('google')->redirect();
    }

    /**
     * Obtain the user information from Google.
     *
     * @return \Illuminate\Http\RedirectResponse
     */
    public function handleGoogleCallback()
    {
        try {
            $googleUser = Socialite::driver('google')->user();
            
            // Find existing user by google_id or email
            $user = User::where('google_id', $googleUser->id)
                ->orWhere('email', $googleUser->email)
                ->first();

            if ($user) {
                // Update google_id if it's missing (merging)
                if (empty($user->google_id)) {
                    $user->update(['google_id' => $googleUser->id]);
                }
                
                Auth::login($user);
            } else {
                // Create new user (Google-only auth doesn't need a password)
                $newUser = User::create([
                    'name' => $googleUser->name,
                    'email' => $googleUser->email,
                    'google_id' => $googleUser->id,
                    'password' => null, // Password is nullable in our new migration
                ]);

                Auth::login($newUser);
            }

            return redirect()->route('dashboard');
            
        } catch (Exception $e) {
            return redirect()->route('login')->with('status', 'Error al autenticar con Google: ' . $e->getMessage());
        }
    }
}
