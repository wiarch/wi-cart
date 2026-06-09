@extends('layouts.app')

@section('title', 'Dashboard - Wi Cart')
@section('header_title', 'Dashboard')
@section('header_meta')
    {{ now()->locale('es')->translatedFormat('F \d\e Y') }}
@endsection
@section('header_description', 'Resumen de tus listas, compras y catálogo.')

@section('header_actions')
    <div class="web-pill-group">
        <a href="{{ route('dashboard') }}" class="web-pill {{ empty($status) ? 'active' : '' }} no-underline">Todas</a>
        <a href="{{ route('dashboard', ['status' => 'active']) }}" class="web-pill {{ ($status ?? '') === 'active' ? 'active' : '' }} no-underline">Activas</a>
        <a href="{{ route('dashboard', ['status' => 'archived']) }}" class="web-pill {{ ($status ?? '') === 'archived' ? 'active' : '' }} no-underline">Archivadas</a>
    </div>
@endsection

@section('content')
    <div class="web-stat-grid animate-slide-up">
        <div class="web-stat-card">
            <div class="web-stat-label">Listas activas</div>
            <div class="web-stat-value">{{ $stats['active_lists'] }}</div>
            <div class="web-stat-meta">{{ $stats['archived_lists'] }} archivadas</div>
        </div>
        <div class="web-stat-card">
            <div class="web-stat-label">Artículos pendientes</div>
            <div class="web-stat-value text-success">{{ $stats['pending_items'] }}</div>
        </div>
        <div class="web-stat-card">
            <div class="web-stat-label">Negocios</div>
            <div class="web-stat-value text-warning">{{ $stats['stores'] }}</div>
        </div>
        <div class="web-stat-card">
            <div class="web-stat-label">Presupuesto pendiente</div>
            <div class="web-stat-value text-danger">{{ number_format((float) $stats['budget'], 2) }}</div>
        </div>
    </div>

    <div class="web-dashboard-grid animate-slide-up">
        <div class="web-card">
            <h2 class="web-panel-title">Mis listas recientes</h2>
            <p class="web-panel-subtitle">Acceso rápido a tus colecciones</p>

            @forelse($recentLists as $list)
                <div class="web-list-item">
                    <div>
                        <div class="font-semibold">{{ $list->name }}</div>
                        <div class="text-sm" style="color: var(--on-surface-muted);">
                            {{ $list->items_count }} artículos · {{ $list->pending_items_count }} pendientes · {{ $list->updated_at?->diffForHumans() }}
                        </div>
                    </div>
                    <span class="{{ $list->status === 'active' ? 'web-badge' : 'web-badge-muted' }}">
                        {{ $list->status === 'active' ? 'Activa' : 'Archivada' }}
                    </span>
                </div>
            @empty
                <p class="text-sm" style="color: var(--on-surface-muted);">Aún no tienes listas. Crea la primera.</p>
            @endforelse
        </div>

        <div class="flex flex-col gap-4">
            <div class="web-card web-card-sm">
                <h3 class="web-panel-title">Resumen del catálogo</h3>
                <div class="web-mini-stats mt-3">
                    <div class="web-mini-stat">
                        <div class="web-mini-stat-label">Categorías</div>
                        <div class="web-mini-stat-value">{{ $stats['categories'] }}</div>
                    </div>
                    <div class="web-mini-stat">
                        <div class="web-mini-stat-label">Unidades</div>
                        <div class="web-mini-stat-value">{{ $stats['units'] }}</div>
                    </div>
                    <div class="web-mini-stat">
                        <div class="web-mini-stat-label">Productos</div>
                        <div class="web-mini-stat-value">{{ $stats['products'] }}</div>
                    </div>
                </div>
            </div>

            <div class="web-card web-card-sm">
                <h3 class="web-panel-title">Accesos rápidos</h3>
                <div class="flex flex-col gap-2 mt-3">
                    <button type="button" class="web-nav-link border-none bg-transparent cursor-pointer" data-crud-create="category" style="margin:0; width:100%; text-align:left;">
                        <i class="fa-solid fa-tags"></i><span>Nueva categoría</span>
                    </button>
                    <button type="button" class="web-nav-link border-none bg-transparent cursor-pointer" data-crud-create="store" style="margin:0; width:100%; text-align:left;">
                        <i class="fa-solid fa-store"></i><span>Nuevo negocio</span>
                    </button>
                    <button type="button" class="web-nav-link border-none bg-transparent cursor-pointer" data-crud-create="list" style="margin:0; width:100%; text-align:left;">
                        <i class="fa-solid fa-list"></i><span>Nueva lista</span>
                    </button>
                </div>
            </div>
        </div>
    </div>

    <button type="button" class="web-fab" data-crud-create="list" aria-label="Nueva lista">
        <i class="fa-solid fa-plus"></i>
    </button>
@endsection
