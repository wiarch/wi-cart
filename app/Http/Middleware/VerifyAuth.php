<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;

class VerifyAuth
{
    public function handle(Request $request, Closure $next)
    {
        if ($request->session()->get('user') == null) {
            return redirect()->route('auth.form');
        }

        return $next($request);
    }
}
