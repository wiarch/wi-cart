<?php

namespace App\Http\Controllers\Auth;

use App\Http\Controllers\Controller;
use App\Providers\RouteServiceProvider;
use Illuminate\Foundation\Auth\AuthenticatesUsers;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Session;
use App\Traits\RuleArrayTrait;
use App\Traits\ValidateFormTrait;
use Illuminate\Support\Facades\Hash;
use App\Traits\GenerateCodeTrait;
use Illuminate\Support\Facades\Crypt;
use Illuminate\Support\Carbon;

class LoginController extends Controller
{
    use RuleArrayTrait;
    use ValidateFormTrait;
    use GenerateCodeTrait;

    /*
    |--------------------------------------------------------------------------
    | Login Controller
    |--------------------------------------------------------------------------
    |
    | This controller handles authenticating users for the application and
    | redirecting them to your home screen. The controller uses a trait
    | to conveniently provide its functionality to your applications.
    |
    */

    // use AuthenticatesUsers;

    /**
     * Where to redirect users after login.
     *
     * @var string
     */
    // protected $redirectTo = RouteServiceProvider::HOME;

    public function showLoginForm()
    {
        if (session()->get('user') == null) {
            return view('auth.home');
        } else {
            return redirect()->route('dashboard');
        }
    }

    public function verify($email)
    {
        return view('auth.verify', compact('email'));
    }

    public function resend($email)
    {
        $email_user = Crypt::decrypt($email);

        $user = DB::connection('mysql_admin')->table('users')->where('email', $email_user)->first();

        $this->generateCode($user->id);

        session()->flash('success', 'Se ha reenviado el correo de verificación.');

        return view('auth.verify', compact('email'));
    }

    public function login(Request $request)
    {
        // Determinar el email a usar (desencriptar si viene código)
        $email = $request->filled('code') ? Crypt::decrypt($request->email) : $request->input('email_login');

        // Validar credenciales solo si no viene código
        if (!$request->filled('code')) {
            $validation = [...$this->rulesArray('email_login', ['required', 'string', 'email', 'max:100'], 'Correo electrónico', false), ...$this->rulesArray('password_login', ['required', 'string'], 'Contraseña', false)];

            if ($response = $this->validateFormInput($request, $validation, 'Error de credenciales')) {
                return $response;
            }
        }

        // Buscar usuario usando la variable $email
        $user = DB::connection('mysql_admin')->table('users')->where('email', $email)->first();
        $profile = DB::connection('mysql_admin')->table('profiles')->where('user_id', $user->id)->first();

        if (!$user) {
            return response()->json([
                'title' => 'Credencial incorrecta',
                'error' => 'El email no existe',
                'reload' => false,
            ]);
        }

        // Validar contraseña solo si no viene código
        if (!$request->filled('code') && !Hash::check($request->password_login, $user->password)) {
            return response()->json([
                'title' => 'Credencial incorrecta',
                'error' => 'La contraseña es incorrecta',
                'reload' => false,
            ]);
        }

        if ($profile->status == 'inactive') {
            return response()->json([
                'title' => 'No puede iniciar sesión',
                'error' => 'El usuario se encuentra inactivo',
                'reload' => false,
            ]);
        }

        if ($request->filled('code')) {
            $code = $request->input('code');

            if ($user->remember_token === $code) {
                $now = Carbon::now();
                DB::connection('mysql_admin')
                    ->table('users')
                    ->where('id', $user->id)
                    ->update(['email_verified_at' => $now]);

                // Actualizar la variable $user para la siguiente condicional
                $user->email_verified_at = $now;
            } else {
                return response()->json([
                    'title' => 'Código incorrecto',
                    'error' => 'El código proporcionado no coincide',
                    'success' => false,
                ]);
            }
        }

        // Verificar si el email está confirmado
        if (!$user->email_verified_at) {
            $this->generateCode($user->id);

            return response()->json([
                'title' => 'Debe verificar su correo',
                'text' => 'Se le envió un correo de verificación',
                'success' => true,
                'redirect' => route('login.verify', ['email' => Crypt::encrypt($user->email)]),
            ]);
        }

        // Guardar usuario en sesión
        Session::put('user', $user);

        return response()->json([
            'title' => 'Bienvenido',
            'text' => 'Has iniciado sesión correctamente',
            'success' => true,
            'redirect' => route('dashboard'),
        ]);
    }

    public function logout(Request $request)
    {
        $request->session()->forget('user');
        return redirect()->route('auth.form')->with('title', 'Has cerrado sesión')->with('success', 'Hasta pronto');
    }

    /**
     * Create a new controller instance.
     *
     * @return void
     */
    public function __construct()
    {
        $this->middleware('guest')->except('logout');
    }
}
