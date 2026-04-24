@extends('layouts.guest')

@section('title', 'Restablecer Contraseña - List Market')

@section('content')
    <form method="POST" action="{{ route('password.store') }}" class="space-y-6">
        @csrf

        <!-- Password Reset Token -->
        <input type="hidden" name="token" value="{{ $request->route('token') }}">

        <div class="header-section mb-10">
            <h2 class="text-3xl font-black text-on-surface tracking-tighter leading-none mb-2">Nueva Contraseña</h2>
            <p class="text-on-surface-variant font-medium text-sm">Elige una clave fresca y segura.</p>
        </div>

        <!-- Email Address -->
        <div>
            <label for="email" class="block font-bold text-[11px] text-primary uppercase tracking-widest mb-2">Email</label>
            <input id="email" class="botanical-input" type="email" name="email" value="{{ old('email', $request->email) }}" required autofocus autocomplete="username" />
            @if ($errors->get('email'))
                <ul class="text-xs text-error font-bold space-y-1 mt-2 list-none p-0">
                    @foreach ((array) $errors->get('email') as $message)
                        <li>{{ $message }}</li>
                    @endforeach
                </ul>
            @endif
        </div>

        <!-- Password -->
        <div class="mt-6">
            <label for="password" class="block font-bold text-[11px] text-primary uppercase tracking-widest mb-2">Contraseña</label>
            <input id="password" class="botanical-input" type="password" name="password" required autocomplete="new-password" placeholder="••••••••" />
            @if ($errors->get('password'))
                <ul class="text-xs text-error font-bold space-y-1 mt-2 list-none p-0">
                    @foreach ((array) $errors->get('password') as $message)
                        <li>{{ $message }}</li>
                    @endforeach
                </ul>
            @endif
        </div>

        <!-- Confirm Password -->
        <div class="mt-6">
            <label for="password_confirmation" class="block font-bold text-[11px] text-primary uppercase tracking-widest mb-2">Confirmar Contraseña</label>
            <input id="password_confirmation" class="botanical-input" type="password" name="password_confirmation" required placeholder="••••••••" />
            @if ($errors->get('password_confirmation'))
                <ul class="text-xs text-error font-bold space-y-1 mt-2 list-none p-0">
                    @foreach ((array) $errors->get('password_confirmation') as $message)
                        <li>{{ $message }}</li>
                    @endforeach
                </ul>
            @endif
        </div>

        <div class="flex items-center justify-end mt-10">
            <button type="submit" class="btn-botanical w-full border-none">
                Restablecer Contraseña
            </button>
        </div>
    </form>
@endsection
