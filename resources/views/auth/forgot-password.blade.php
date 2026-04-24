@extends('layouts.guest')

@section('title', 'Recuperar Contraseña - List Market')

@section('content')
    <div class="mb-8 font-medium text-sm text-on-surface-variant">
        ¿Olvidaste tu contraseña? No hay problema. Solo dinos tu dirección de correo electrónico y te enviaremos un enlace para restablecerla.
    </div>

    <!-- Session Status -->
    @if (session('status'))
        <div class="mb-6 font-bold text-sm text-primary px-4 py-3 bg-secondary-container/20 rounded-xl">
            {{ session('status') }}
        </div>
    @endif

    <form method="POST" action="{{ route('password.email') }}" class="space-y-6">
        @csrf

        <!-- Email Address -->
        <div>
            <label for="email" class="block font-bold text-[11px] text-primary uppercase tracking-widest mb-2">Email</label>
            <input id="email" class="botanical-input" type="email" name="email" value="{{ old('email') }}" required autofocus placeholder="tu@email.com" />
            @if ($errors->get('email'))
                <ul class="text-xs text-error font-bold space-y-1 mt-2 list-none p-0">
                    @foreach ((array) $errors->get('email') as $message)
                        <li>{{ $message }}</li>
                    @endforeach
                </ul>
            @endif
        </div>

        <div class="flex items-center justify-end mt-8">
            <button type="submit" class="btn-botanical w-full border-none">
                Enviar Enlace
            </button>
        </div>
    </form>
@endsection
