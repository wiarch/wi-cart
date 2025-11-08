<?php

namespace App\Http\Controllers;

use Illuminate\Support\Facades\Log;

class DashboardController extends Controller
{

    public function dashboard()
    {
        try {
            return view('dashboard');
        } catch (\Throwable $th) {
            Log::error('DashboardController - home -> Error: ' . $th->getMessage());
            return response()->view('layouts.partials.misc.error_500', [
                'exception' => $th
            ], 500);
        }
    }
}
