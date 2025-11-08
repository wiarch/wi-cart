<?php

namespace App\Http\Controllers;

use Illuminate\Support\Str;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\Session;
use App\Http\Controllers\AjaxController;
use Illuminate\Support\Facades\View;

class UserController extends Controller
{
    protected $permissions;
    protected $moduleName;
    public function __construct()
    {

        $this->middleware('user.permissions');

       /* $this->middleware(function ($request, $next) {
            $usuario = Session::get('user');
            $userId = $usuario->id_usuario ?? null;

            if ($userId) {
                $moduleName = class_basename($request->route()->getController());
                $this->moduleName = $moduleName;
                $moduleId = DB::table('modules')
                    ->where('name_controller', $moduleName)
                    ->pluck('id')
                    ->first();

                $permissions = DB::table('module_usuario')
                    ->where('id_usuario', $userId)
                    ->where('module_id', $moduleId)
                    ->first(['can_create', 'can_read', 'can_update', 'can_delete','can_activate','can_permissions']);
            }
            View::share('permissions', $permissions);
            $this->permissions = $permissions;
            return $next($request);
        });*/
         // Obtener la sesión usando el contenedor de servicios
         /*$session = app('id_usuario');
         dd($session);
         // Recuperar el usuario de la sesión
         $this->usuario = $session->get('user');*/ // Equivalente a Session::get('user')


         // Obtener módulos y permisos para un usuario específico
        /* $session = app('session');
         dd( $session->get('user') );
        $usuario = Session::get('user');
        $userId = $usuario->id_usuario;

        // Obtener el nombre del controlador actual (módulo)
        $moduleName = class_basename(request()->route()->getController());
        $moduleId = DB::table('modules')
            ->where('name_controller', $moduleName)
            ->pluck('id')
            ->first();

        // Obtener los permisos del usuario para el módulo
        $this->permissions = DB::table('module_usuario')
            ->where('id_usuario', $userId)
            ->where('module_id', $moduleId)
            ->first(['can_create', 'can_read', 'can_update', 'can_delete']);*/
    }

    /**
     * Display a listing of the resource.
     */
    public function index()
    {

        // try {

        $user = DB::table('usuarios')
            ->leftJoin('profesionales', 'profesionales.id_prof', '=', 'usuarios.id_prof')
            ->select(
                'usuarios.*',
                'profesionales.nombre as nombre_prof',
                'profesionales.id_prof as id_prof'
            )
            ->get();

        // todas las sucursales activas
        $bof = (new AjaxController)->getBof();
        $prof = (new AjaxController)->getProf();

        Session::forget('sidebar');
        $moduleName = $this->moduleName;
        $usuario = Session::get('user');
        $id_usuario  =$usuario->id_usuario;
        $permissions_template = DB::table('permission_profiles')->get();
        return view('users.index', compact('user', 'bof', 'prof','moduleName','id_usuario','permissions_template'));

        // } catch (\Throwable $th) {
        //     Log::error('index - UserController -> Error: ' . $th);
        //     abort(403, "Ocurrio un error. Contacte con el administrador");
        // }
    }
    public function permissionsTemplate(Request $request){

       // dd($request);
        $permissions_template = DB::table('permission_profiles')->where('id','=',$request->permissionTemplate)->first();

        //if($request->permissionTemplate == 'todos'){
            $modules = DB::table('modules')->get();
            foreach ($modules as $module) {
                DB::table('module_usuario')->updateOrInsert(
                    [
                        'module_id' => $module->id,
                        'id_usuario' => $request->id_usuario, // Ajusta este valor según corresponda
                    ],
                    [
                        'can_create' => $permissions_template->can_create,
                        'can_read' => $permissions_template->can_read,
                        'can_update' => $permissions_template->can_update,
                        'can_delete' => $permissions_template->can_delete,
                        'can_activate' => $permissions_template->can_activate,
                        'can_permissions' => $permissions_template->can_permissions,
                        'can_shifts' => $permissions_template->can_shifts,
                        'can_ot' => $permissions_template->can_ot,
                        'can_hc' => $permissions_template->can_hc,
                        'can_payments' => $permissions_template->can_payments,
                        'can_show' => $permissions_template->can_show,
                        'can_assign_practices' => $permissions_template->can_assign_practices,
                        'updated_at' => now(), // Solo `updated_at` se actualiza, `created_at` permanece igual si el registro existe
                    ]
                );
            }
            return redirect()->back();
        //}

    }
    /**
     * Show the form for creating a new resource.
     */
    public function create()
    {
        //
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request)
    {
        // try {

        $all_bof = DB::table('sucursales')->where('habilitada', 1)->get('id_sucursal');
        $array_bof = [];
        $bof = $request->branch_office;

        // si $all_bof tiene el valor 1, agrega todas las sucursales
        if (isset($request->all_bofs)) {

            for ($i = 0; $i < count($all_bof); $i++) {

                $data = json_encode($all_bof[$i]->id_sucursal);
                array_push($array_bof, $data);
            }
        } elseif ($bof != null) {
            for ($i = 0; $i < count($bof); $i++) {

                $data = $bof[$i];
                array_push($array_bof, $data);
            }
        }

        $verify_username = DB::table('usuarios')
            ->where('usuario', $request->username)->get();

        $last_id = DB::table('usuarios')
            ->latest('id_usuario')
            ->first()
            ->id_usuario;

        if ($verify_username == '[]') {
            // usuario administrativo
            if ($request->user_type == 1) {
                DB::insert(
                    'insert into usuarios (
                        id_usuario,
                        nombre,
                        usuario,
                        clave,
                        sucursales,
                        es_supervisor
                        ) values (?, ?, ?, ?, ?, ?)',
                    [$last_id + 1, $request->name, $request->username, $request->password, json_encode($array_bof), 1]
                );
                // usuario profesional
            } else {
                DB::insert(
                    'insert into usuarios (
                        id_usuario,
                        nombre,
                        usuario,
                        clave,
                        id_prof,
                        es_odontologo
                        ) values (?, ?, ?, ?, ?, ?)',
                    [$last_id + 1, $request->name, $request->username, $request->password, $request->prof, 1]
                );
            }


        } else {
            return redirect()->back()
                ->with('title', 'Usuario invalido')
                ->with('error', 'El usuario ' . $request->username . ' ya existe');
        }

        return redirect()->back()
            ->with('title', 'Usuario creado')
            ->with('success', 'El usuario ' . $request->username . ' ha sido creado exitosamente');

        // } catch (\Throwable $th) {
        //     Log::error('store - UserController -> Error: ' . $th);
        //     abort(403, "Ocurrió un error. Contacta con el administrador");
        // }
    }

    /**
     * Display the specified resource.
     */
    public function show(string $id)
    {
        //
    }

    /**
     * Show the form for editing the specified resource.
     */
    public function edit(request $request, string $id)
    {
        try {

            $user = DB::selectOne('select * from usuarios where id_usuario = ' . $id);

            if ($user && $user->habilitado != 0) {
                DB::table('usuarios')
                    ->where('id_usuario', $id)
                    ->update([
                        'habilitado' => 0,
                    ]);

                return redirect()->back()
                    ->with('title', 'Usuario actualizado')
                    ->with('success', 'El usuario ' . $id . ' ha sido desactivado exitosamente');
            } else {
                DB::table('usuarios')
                    ->where('id_usuario', $id)
                    ->update([
                        'habilitado' => 1,
                    ]);

                return redirect()->back()
                    ->with('title', 'Usuario actualizado')
                    ->with('success', 'El usuario ' . $id . ' ha sido activado exitosamente');
            }

        } catch (\Throwable $th) {
            Log::error('edit - UserController -> Error: ' . $th);
            abort(403, "Ocurrió un error. Contacta con el administrador");
        }
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, string $id)
    {
        // try {

        $all_bof = DB::table('sucursales')->where('habilitada', 1)->get('id_sucursal');
        $array_bof = [];
        $bof = $request->branch_office;

        if (isset($request->all_bofs)) {

            for ($i = 0; $i < count($all_bof); $i++) {

                $data = json_encode($all_bof[$i]->id_sucursal);
                array_push($array_bof, $data);
            }
        } elseif ($bof != null) {
            for ($i = 0; $i < count($bof); $i++) {

                $data = $bof[$i];
                array_push($array_bof, $data);
            }
        }

        if ($request->user_type == 1) {

            DB::table('usuarios')
                ->where('id_usuario', $id)
                ->update([
                    'nombre' => $request->name,
                    'clave' => $request->password,
                    'id_prof' => 0,
                    'es_supervisor' => 1,
                    'es_odontologo' => 0,
                    'sucursales' => json_encode($array_bof),
                ]);
        } else {
            DB::table('usuarios')
            ->where('id_usuario', $id)
            ->update([
                'nombre' => $request->name,
                'clave' => $request->password,
                'id_prof' => $request->prof,
                'es_supervisor' => 0,
                'es_odontologo' => 1,
                'sucursales' => null,
            ]);
        }
        return redirect()->back()
            ->with('title', 'Usuario actualizado')
            ->with('success', 'El usuario ' . $id . ' ha sido actualizado exitosamente');

        // } catch (\Throwable $th) {
        //     Log::error('update - UserController -> Error: ' . $th);
        //     abort(403, "Ocurrió un error. Contacta con el administrador");
        // }
    }


    /**
     * Remove the specified resource from storage.
     */
    public function destroy(string $id)
    {
        try {

            DB::delete('delete from usuarios where id_usuario = ' . $id);

            return redirect()->back()
                ->with('title', 'Usuario eliminado')
                ->with('success', 'El usuario ha sido eliminado exitosamente');

        } catch (\Throwable $th) {
            Log::error('destroy - UserController -> Error: ' . $th);
            abort(403, "Ocurrió un error. Contacta con el administrador");
        }
    }

    // funcion para generar una contraseña aleatoria
    public function generatePassword(Request $request)
    {
        try {

            if ($request->ajax()) {
                $password = Str::random(12);
                return $password;
            }

        } catch (\Throwable $th) {
            Log::error('generatePassword - UserController -> Error: ' . $th);
            abort(403, "Ocurrió un error. Contacta con el administrador");
        }
    }

}
