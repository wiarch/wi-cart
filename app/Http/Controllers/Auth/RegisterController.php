<?php

namespace App\Http\Controllers\Auth;

use App\Http\Controllers\Controller;
use App\Providers\RouteServiceProvider;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Facades\DB;
use Illuminate\Http\Request;
use App\Traits\ValidateFormTrait;
use App\Traits\CharIdTrait;
use App\Traits\RuleArrayTrait;
use Illuminate\Support\Carbon;
use Illuminate\Support\Facades\Hash;

class RegisterController extends Controller
{
    use ValidateFormTrait;
    use CharIdTrait;
    use RuleArrayTrait;

    /*
    |--------------------------------------------------------------------------
    | Register Controller
    |--------------------------------------------------------------------------
    |
    | This controller handles the registration of new users as well as their
    | validation and creation. By default this controller uses a trait to
    | provide this functionality without requiring any additional code.
    |
    */

    /**
     * Where to redirect users after registration.
     *
     * @var string
     */

    protected $redirectTo = RouteServiceProvider::HOME;

    /**
     * Create a new controller instance.
     *
     * @return void
     */
    public function __construct()
    {
        $this->middleware('guest');
    }

    public function register(Request $request)
    {
        $validation = [
            // Campos de usuario
            ...$this->rulesArray('name', ['required', 'string', 'max:100'], 'Nombre', false),
            ...$this->rulesArray('last_name', ['required', 'string', 'max:100'], 'Apellido', false),
            ...$this->rulesArray('email', ['required', 'string', 'email', 'max:100', 'unique:mysql_admin.users,email'], 'Correo electrónico', false),
            ...$this->rulesArray('password', ['required', 'string', 'min:8', 'confirmed'], 'Contraseña', false),
            ...$this->rulesArray('password_confirmation', ['required', 'string', 'min:8'], 'Confirmar Contraseña', false),
            ...$this->rulesArray('phone', ['required'], 'Teléfono', false),
            ...$this->rulesArray('address', ['required'], 'Dirección', false),
            ...$this->rulesArray('cuit', ['required', 'digits:11'], 'CUIT (11 dígitos)', false),
            ...$this->rulesArray('region', ['required'], 'Región', false),
            ...$this->rulesArray('seller', ['required'], 'Vendedor', false),
        ];

        // Validar la entrada con el trait personalizado
        if ($response = $this->validateFormInput($request, $validation, 'Cuenta no registrada')) {
            return $response;
        }

        $user_id = $this->generateUniqueCharId('users', 'id', 'mysql_admin');

        // Insertar en users con ese ID
        DB::connection('mysql_admin')->insert(
            'insert into users (
            id,
            name,
            email,
            password,
            created_at
        ) values (?, ?, ?, ?, ?)',
            [$user_id, $request->name, $request->email, Hash::make($request->password), Carbon::now()],
        );

        // Insertar en profiles con mismo user_id
        DB::connection('mysql_admin')->insert(
            'insert into profiles (
            id,
            name,
            last_name,
            phone,
            address,
            cuit,
            region_id,
            seller,
            status,
            user_id,
            created_at
        ) values (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)',
            [
                $this->generateUniqueCharId('profiles', 'id', 'mysql_admin'),
                $request->name,
                $request->last_name,
                $request->phone,
                $request->address,
                $request->cuit,
                $request->region,
                $request->seller,
                'inactive',
                $user_id, // este sí existe en users
                Carbon::now(),
            ],
        );

        session()->flash('confirm_alert', true);
        session()->flash('confirm_title', 'Cuenta registrada');
        session()->flash(
            'confirm_text',
            "Tu registro se ha completado de forma exitosa.<br>
            Para poder entrar en el sistema debes verificar tu correo, que te llegará con un código único de verificación.<br>
            Tienes 3 meses gratis",
                    );

        return response()->json([
            'title' => 'Usuario registrado',
            'text' => 'Ya puede iniciar sesión',
            'reload' => true,
        ]);
    }
}
