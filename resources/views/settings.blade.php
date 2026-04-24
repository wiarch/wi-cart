@extends('layouts.app')

@section('category', 'Dashboard')
@section('header_title', 'Configuración')
@section('header_description', 'Gestiona los parámetros administrativos de tu cuenta.')

@section('content')
<div class="space-y-6 animate-slide-up">
    <!-- Desktop View: Grid Layout (Hidden on Mobile) -->
    <div class="hidden sm:grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
        <!-- Negocios Card -->
        <a href="{{ route('stores.index') }}" class="botanical-card p-6 flex flex-col gap-4 no-underline group hover:transform hover:translate-y-[-4px] transition-all">
            <div class="w-14 h-14 rounded-2xl bg-primary/10 flex items-center justify-center text-primary group-hover:bg-primary group-hover:text-white transition-all">
                <i class="fa-solid fa-store text-2xl"></i>
            </div>
            <div>
                <h3 class="text-lg font-black text-on-surface uppercase tracking-widest mb-1">Negocios</h3>
                <p class="text-sm text-on-surface-variant font-medium">Configura tus supermercados y puntos de venta habituales.</p>
            </div>
            <div class="mt-auto pt-4 flex items-center gap-2 text-primary font-bold text-xs uppercase tracking-widest">
                Gestionar <i class="fa-solid fa-arrow-right-long transition-transform group-hover:translate-x-2"></i>
            </div>
        </a>

        <!-- Categorías Card -->
        <a href="{{ route('categories.index') }}" class="botanical-card p-6 flex flex-col gap-4 no-underline group hover:transform hover:translate-y-[-4px] transition-all">
            <div class="w-14 h-14 rounded-2xl bg-secondary-container flex items-center justify-center text-on-secondary-container group-hover:bg-primary group-hover:text-white transition-all">
                <i class="fa-solid fa-tags text-2xl"></i>
            </div>
            <div>
                <h3 class="text-lg font-black text-on-surface uppercase tracking-widest mb-1">Categorías</h3>
                <p class="text-sm text-on-surface-variant font-medium">Organiza tus productos por departamentos o pasillos.</p>
            </div>
            <div class="mt-auto pt-4 flex items-center gap-2 text-primary font-bold text-xs uppercase tracking-widest">
                Gestionar <i class="fa-solid fa-arrow-right-long transition-transform group-hover:translate-x-2"></i>
            </div>
        </a>

        <!-- Unidades Card -->
        <a href="{{ route('units.index') }}" class="botanical-card p-6 flex flex-col gap-4 no-underline group hover:transform hover:translate-y-[-4px] transition-all">
            <div class="w-14 h-14 rounded-2xl bg-secondary-container flex items-center justify-center text-on-secondary-container group-hover:bg-primary group-hover:text-white transition-all">
                <i class="fa-solid fa-scale-balanced text-2xl"></i>
            </div>
            <div>
                <h3 class="text-lg font-black text-on-surface uppercase tracking-widest mb-1">Unidades</h3>
                <p class="text-sm text-on-surface-variant font-medium">Configura pesajes, medidas y presentaciones de productos.</p>
            </div>
            <div class="mt-auto pt-4 flex items-center gap-2 text-primary font-bold text-xs uppercase tracking-widest">
                Gestionar <i class="fa-solid fa-arrow-right-long transition-transform group-hover:translate-x-2"></i>
            </div>
        </a>
    </div>

    <!-- Mobile View: Action List (Shown on Mobile) -->
    <div class="sm:hidden space-y-3">
        <a href="{{ route('stores.index') }}" class="flex items-center gap-4 p-5 rounded-3xl bg-surface-container-high border border-outline-variant/10 no-underline active:scale-95 transition-all">
            <div class="w-12 h-12 rounded-2xl bg-primary/10 text-primary flex items-center justify-center shadow-sm">
                <i class="fa-solid fa-store text-xl"></i>
            </div>
            <div class="flex-grow">
                <span class="block text-sm font-black text-on-surface uppercase tracking-wide">Negocios</span>
                <span class="block text-xs text-on-surface-variant">Supermercados y tiendas</span>
            </div>
            <i class="fa-solid fa-chevron-right text-on-surface-variant opacity-30"></i>
        </a>

        <a href="{{ route('categories.index') }}" class="flex items-center gap-4 p-5 rounded-3xl bg-surface-container-high border border-outline-variant/10 no-underline active:scale-95 transition-all">
            <div class="w-12 h-12 rounded-2xl bg-primary/10 text-primary flex items-center justify-center shadow-sm">
                <i class="fa-solid fa-tags text-xl"></i>
            </div>
            <div class="flex-grow">
                <span class="block text-sm font-black text-on-surface uppercase tracking-wide">Categorías</span>
                <span class="block text-xs text-on-surface-variant">Tags y departamentos</span>
            </div>
            <i class="fa-solid fa-chevron-right text-on-surface-variant opacity-30"></i>
        </a>

        <a href="{{ route('units.index') }}" class="flex items-center gap-4 p-5 rounded-3xl bg-surface-container-high border border-outline-variant/10 no-underline active:scale-95 transition-all">
            <div class="w-12 h-12 rounded-2xl bg-primary/10 text-primary flex items-center justify-center shadow-sm">
                <i class="fa-solid fa-scale-balanced text-xl"></i>
            </div>
            <div class="flex-grow">
                <span class="block text-sm font-black text-on-surface uppercase tracking-wide">Unidades</span>
                <span class="block text-xs text-on-surface-variant">Medidas y pesajes</span>
            </div>
            <i class="fa-solid fa-chevron-right text-on-surface-variant opacity-30"></i>
        </a>
        
    </div>
</div>
@endsection
