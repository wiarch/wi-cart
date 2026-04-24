@extends('layouts.guest')

@section('title', 'Registro - List Market')

@section('content')
    <form method="POST" action="{{ route('register') }}" class="space-y-6">
        @csrf

        <div class="header-section mb-10">
            <h2 class="text-3xl font-black text-on-surface tracking-tighter leading-none mb-2">Crear Cuenta</h2>
            <p class="text-on-surface-variant font-medium text-sm">Únete a la ritual de compra fresca.</p>
        </div>

        <!-- Name -->
        <div>
            <label for="name" class="block font-bold text-[11px] text-primary uppercase tracking-widest mb-2">Nombre</label>
            <input id="name" class="botanical-input" type="text" name="name" value="{{ old('name') }}" required autofocus placeholder="Tu nombre" />
            @if ($errors->get('name'))
                <ul class="text-xs text-error font-bold space-y-1 mt-2 list-none p-0">
                    @foreach ((array) $errors->get('name') as $message)
                        <li>{{ $message }}</li>
                    @endforeach
                </ul>
            @endif
        </div>

        <!-- Email Address -->
        <div class="mt-6">
            <label for="email" class="block font-bold text-[11px] text-primary uppercase tracking-widest mb-2">Email</label>
            <input id="email" class="botanical-input" type="email" name="email" value="{{ old('email') }}" required placeholder="tu@email.com" />
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

        <div class="flex flex-col gap-4 mt-10">
            <button type="submit" class="btn-botanical w-full border-none">
                Registrarse
            </button>

            <div class="text-center mt-4">
                <p class="text-sm font-medium text-on-surface-variant">
                    ¿Ya tienes cuenta? 
                    <a class="font-bold text-primary hover:underline no-underline" href="{{ route('login') }}">
                        Inicia Sesión
                    </a>
                </p>
            </div>
        </div>
    </form>
@endsection
