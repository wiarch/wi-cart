@extends('layouts.guest')

@section('title', 'Confirmar Contraseña - List Market')

@section('content')
    <div class="mb-8 font-medium text-sm text-on-surface-variant">
        Esta es una zona segura de la aplicación. Por favor, confirma tu contraseña antes de continuar.
    </div>

    <form method="POST" action="{{ route('password.confirm') }}" class="space-y-6">
        @csrf

        <!-- Password -->
        <div>
            <label for="password" class="block font-bold text-[11px] text-primary uppercase tracking-widest mb-2">Contraseña</label>
            <input id="password" class="botanical-input" type="password" name="password" required autocomplete="current-password" placeholder="••••••••" />
            @if ($errors->get('password'))
                <ul class="text-xs text-error font-bold space-y-1 mt-2 list-none p-0">
                    @foreach ((array) $errors->get('password') as $message)
                        <li>{{ $message }}</li>
                    @endforeach
                </ul>
            @endif
        </div>

        <div class="flex justify-end mt-8">
            <button type="submit" class="btn-botanical w-full border-none">
                Confirmar
            </button>
        </div>
    </form>
@endsection
