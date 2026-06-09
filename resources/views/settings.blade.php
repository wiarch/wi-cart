@extends('layouts.app')

@section('title', 'Configuración - Wi Cart')
@section('header_title', 'Configuración')
@section('header_description', 'Administra catálogos y preferencias.')

@section('content')
    <div class="grid grid-cols-1 md:grid-cols-2 xl:grid-cols-3 gap-4 animate-slide-up">
        <button type="button" data-crud-create="store" class="web-card text-left border-none cursor-pointer w-full">
            <div class="w-11 h-11 rounded-xl flex items-center justify-center mb-4" style="background: var(--primary-muted); color: #c4b5fd;">
                <i class="fa-solid fa-store"></i>
            </div>
            <h3 class="web-panel-title">Negocios</h3>
            <p class="web-panel-subtitle">Crear o editar desde modal.</p>
        </button>

        <button type="button" data-crud-create="category" class="web-card text-left border-none cursor-pointer w-full">
            <div class="w-11 h-11 rounded-xl flex items-center justify-center mb-4" style="background: var(--success-bg); color: var(--success);">
                <i class="fa-solid fa-tags"></i>
            </div>
            <h3 class="web-panel-title">Categorías</h3>
            <p class="web-panel-subtitle">Clasificación de productos.</p>
        </button>

        <button type="button" data-crud-create="unit" class="web-card text-left border-none cursor-pointer w-full">
            <div class="w-11 h-11 rounded-xl flex items-center justify-center mb-4" style="background: var(--warning-bg); color: var(--warning);">
                <i class="fa-solid fa-scale-balanced"></i>
            </div>
            <h3 class="web-panel-title">Unidades</h3>
            <p class="web-panel-subtitle">Medidas y presentaciones.</p>
        </button>

        <a href="{{ route('stores.index') }}" class="web-card no-underline block">
            <h3 class="web-panel-title">Ver negocios</h3>
            <p class="web-panel-subtitle">Tabla completa con modales.</p>
        </a>
        <a href="{{ route('categories.index') }}" class="web-card no-underline block">
            <h3 class="web-panel-title">Ver categorías</h3>
            <p class="web-panel-subtitle">Tabla completa con modales.</p>
        </a>
        <a href="{{ route('units.index') }}" class="web-card no-underline block">
            <h3 class="web-panel-title">Ver unidades</h3>
            <p class="web-panel-subtitle">Tabla completa con modales.</p>
        </a>

        <button type="button" data-open-profile data-current-name="{{ auth()->user()->name }}" class="web-card text-left border-none cursor-pointer w-full">
            <div class="w-11 h-11 rounded-xl flex items-center justify-center mb-4" style="background: var(--primary-muted); color: #c4b5fd;">
                <i class="fa-solid fa-user"></i>
            </div>
            <h3 class="web-panel-title">Mi perfil</h3>
            <p class="web-panel-subtitle">Editar nombre de usuario.</p>
        </button>
    </div>
@endsection
