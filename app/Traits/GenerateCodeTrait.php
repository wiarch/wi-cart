<?php

namespace App\Traits;

use Illuminate\Support\Facades\DB;
use App\Services\BrevoService;

trait GenerateCodeTrait
{
    public function generateCode($user_id): void
    {
        $code = rand(100000, 999999);

        $user = DB::connection('mysql_admin')
            ->table('users')
            ->where('id', $user_id)
            ->first();

        DB::connection('mysql_admin')
            ->table('users')
            ->where('id', $user_id)
            ->update(['remember_token' => $code]);

        // Instancia del servicio Brevo
        $brevo = app(BrevoService::class);

        $brevo->sendEmail([
            'htmlmail'    => 'mails.code_login',
            'sendto'      => $user->email,
            'sentto_name' => $user->name,
            'token_data'  => $code,
            'token'       => true,
            'data'        => true,
            'subject'     => 'Código de verificación',
        ]);
    }
}
