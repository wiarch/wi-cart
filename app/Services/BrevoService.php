<?php

namespace App\Services;

use App\Order;
use Illuminate\Support\Facades\View;

class BrevoService
{
    public function sendEmail(array $data)
    {
        if ($data['data'] == false) {
            $html = View::make($data['htmlmail'])->render();
        } else {
            if ($data['token'] == true) {
                $token = $data['token_data'];
                $user = $data['email_user'] ?? null;
                $html = View::make($data['htmlmail'], compact('user', 'token'))->render();
            } else {
                $order = Order::find($data['id']);
                $html = View::make($data['htmlmail'])->with('data', $order)->render();
            }
        }

        $postfields = json_encode([
            'sender' => [
                'name' => 'ProGanadero',
                'email' => 'josemiguelfernandez83@gmail.com',
            ],
            'to' => [
                [
                    'email' => $data['sendto'],
                    'name' => $data['sentto_name'],
                ],
            ],
            'htmlContent' => $html,
            'textContent' => '.',
            'subject' => $data['subject'],
        ]);

        $curl = curl_init();
        curl_setopt_array($curl, [
            CURLOPT_URL => 'https://api.brevo.com/v3/smtp/email',
            CURLOPT_RETURNTRANSFER => true,
            CURLOPT_CUSTOMREQUEST => 'POST',
            CURLOPT_POSTFIELDS => $postfields,
            CURLOPT_HTTPHEADER => [
                'accept: application/json',
                'api-key: ' . config('services.brevo.api_key'), //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,
                'content-type: application/json',
            ],
        ]);

        $response = curl_exec($curl);
        $err = curl_error($curl);

        return [$response, $err];
    }
}
