@extends('layouts.guest')

@section('title', 'Iniciar Sesión - List Market')

@section('content')
    <div class="botanical-card p-8 sm:p-12 shadow-2xl relative overflow-hidden">
        <!-- Abstract Decoration inside card -->
        <div class="absolute -right-12 -top-12 w-32 h-32 bg-primary/5 rounded-full blur-2xl"></div>

        <!-- Session Status -->
        @if (session('status'))
            <div class="mb-6 font-bold text-sm text-primary px-4 py-3 bg-secondary-container/20 rounded-xl animate-slide-up">
                {{ session('status') }}
            </div>
        @endif

        <form method="POST" action="{{ route('login') }}" class="relative z-10 space-y-6">
            @csrf

        <div class="header-section mb-12 text-center">
            <h2 class="text-3xl sm:text-4xl font-black text-on-surface tracking-tighter leading-tight mb-2">Inicio de Sesión</h2>
            <p class="text-on-surface-variant font-medium text-sm sm:text-base px-4">Accede de forma rápida y segura con tu cuenta.</p>
        </div>

        <div class="flex flex-col gap-8 pb-4">
            <a href="{{ route('auth.google') }}" class="flex items-center justify-center gap-4 w-full h-16 bg-white text-black font-black text-base rounded-2xl shadow-xl hover:shadow-2xl hover:-translate-y-1 active:scale-[0.98] transition-all no-underline border border-outline-variant/10 group">
                <div class="bg-white p-2 rounded-lg shadow-sm">
                    <svg class="w-6 h-6" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
                        <path d="M22.56 12.25c0-.78-.07-1.53-.2-2.25H12v4.26h5.92c-.26 1.37-1.04 2.53-2.21 3.31v2.77h3.57c2.08-1.92 3.28-4.74 3.28-8.09z" fill="#4285F4"/>
                        <path d="M12 23c2.97 0 5.46-.98 7.28-2.66l-3.57-2.77c-.98.66-2.23 1.06-3.71 1.06-2.86 0-5.29-1.93-6.16-4.53H2.18v2.84C3.99 20.53 7.7 23 12 23z" fill="#34A853"/>
                        <path d="M5.84 14.09c-.22-.66-.35-1.36-.35-2.09s.13-1.43.35-2.09V7.07H2.18C1.43 8.55 1 10.22 1 12s.43 3.45 1.18 4.93l3.66-2.84z" fill="#FBBC05"/>
                        <path d="M12 5.38c1.62 0 3.06.56 4.21 1.64l3.15-3.15C17.45 2.09 14.97 1 12 1 7.7 1 3.99 3.47 2.18 7.07l3.66 2.84c.87-2.6 3.3-4.53 6.16-4.53z" fill="#EA4335"/>
                    </svg>
                </div>
                <span>Continuar con Google</span>
                <i class="fa-solid fa-arrow-right ml-1 text-xs opacity-0 group-hover:opacity-60 group-hover:translate-x-1 transition-all"></i>
            </a>
        </div>
        </form>
    </div>
@endsection
