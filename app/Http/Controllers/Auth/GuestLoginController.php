<?php

namespace App\Http\Controllers\Auth;

use App\Http\Controllers\Controller;
use App\Models\User;
use Illuminate\Http\RedirectResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Str;

class GuestLoginController extends Controller
{
    public function store(Request $request): RedirectResponse
    {
        $validated = $request->validate([
            'username' => ['required', 'string', 'max:50', 'regex:/^[\pL\pN\s._-]+$/u'],
        ]);

        $username = trim($validated['username']);
        $slug = Str::slug($username, '.');

        if ($slug === '') {
            return back()
                ->withInput()
                ->withErrors(['username' => 'Nombre de usuario inválido.']);
        }

        $email = $slug.'@guest.wi-cart.local';

        $user = User::firstOrCreate(
            ['email' => $email],
            [
                'name' => $username,
                'password' => null,
                'email_verified_at' => now(),
            ]
        );

        if ($user->name !== $username) {
            $user->update(['name' => $username]);
        }

        Auth::login($user);
        $request->session()->regenerate();

        return redirect()->intended(route('dashboard', absolute: false));
    }
}
