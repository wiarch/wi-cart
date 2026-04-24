@extends('layouts.guest')

@section('title', 'Verificar Email - List Market')

@section('content')
    <div class="mb-8 font-medium text-sm text-on-surface-variant">
        ¡Gracias por registrarte! Antes de comenzar, ¿podrías verificar tu dirección de correo electrónico haciendo clic en el enlace que acabamos de enviarte? Si no recibiste el correo, con gusto te enviaremos otro.
    </div>

    @if (session('status') == 'verification-link-sent')
        <div class="mb-6 font-bold text-sm text-primary px-4 py-3 bg-secondary-container/20 rounded-xl">
            Se ha enviado un nuevo enlace de verificación a la dirección de correo electrónico que proporcionaste durante el registro.
        </div>
    @endif

    <div class="mt-8 flex flex-col gap-4 items-center justify-between">
        <form method="POST" action="{{ route('verification.send') }}" class="w-full">
            @csrf
            <div>
                <button type="submit" class="btn-botanical w-full border-none">
                    Reenviar Email de Verificación
                </button>
            </div>
        </form>

        <form method="POST" action="{{ route('logout') }}" class="w-full">
            @csrf
            <button type="submit" class="w-full text-sm font-black text-on-surface-variant hover:text-primary transition-colors no-underline uppercase tracking-wider bg-transparent border-none cursor-pointer">
                Cerrar Sesión
            </button>
        </form>
    </div>
@endsection
