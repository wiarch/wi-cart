@extends('layouts.app')

@section('title', 'Análisis - Wi Cart')
@section('header_title', 'Análisis')
@section('header_meta')
    {{ now()->locale('es')->translatedFormat('F \d\e Y') }}
@endsection
@section('header_description', 'Métricas de listas, artículos y catálogo.')

@section('content')
    <div class="web-stat-grid animate-slide-up">
        <div class="web-stat-card">
            <div class="web-stat-label">Listas totales</div>
            <div class="web-stat-value">{{ $stats['total_lists'] }}</div>
        </div>
        <div class="web-stat-card">
            <div class="web-stat-label">Artículos pendientes</div>
            <div class="web-stat-value text-warning">{{ $stats['pending_items'] }}</div>
        </div>
        <div class="web-stat-card">
            <div class="web-stat-label">Artículos comprados</div>
            <div class="web-stat-value text-success">{{ $stats['checked_items'] }}</div>
        </div>
        <div class="web-stat-card">
            <div class="web-stat-label">Estimado pendiente</div>
            <div class="web-stat-value text-danger">{{ number_format((float) $stats['estimated_total'], 2) }}</div>
        </div>
    </div>

    <div class="web-dashboard-grid animate-slide-up">
        <div class="web-card">
            <h2 class="web-panel-title">Actividad reciente</h2>
            <p class="web-panel-subtitle">Últimas listas modificadas</p>
            @forelse($recentActivity as $list)
                <div class="web-list-item">
                    <div>
                        <div class="font-semibold">{{ $list->name }}</div>
                        <div class="text-sm" style="color: var(--on-surface-muted);">
                            {{ $list->items_count }} artículos · {{ $list->updated_at?->diffForHumans() }}
                        </div>
                    </div>
                    <span class="{{ $list->status === 'active' ? 'web-badge' : 'web-badge-muted' }}">
                        {{ $list->status === 'active' ? 'Activa' : 'Archivada' }}
                    </span>
                </div>
            @empty
                <p class="text-sm" style="color: var(--on-surface-muted);">Sin actividad aún.</p>
            @endforelse
        </div>

        <div class="flex flex-col gap-4">
            <div class="web-card web-card-sm">
                <h3 class="web-panel-title">Catálogo</h3>
                <div class="web-mini-stats mt-3">
                    <div class="web-mini-stat">
                        <div class="web-mini-stat-label">Productos</div>
                        <div class="web-mini-stat-value">{{ $stats['products'] }}</div>
                    </div>
                    <div class="web-mini-stat">
                        <div class="web-mini-stat-label">Categorías</div>
                        <div class="web-mini-stat-value">{{ $stats['categories'] }}</div>
                    </div>
                    <div class="web-mini-stat">
                        <div class="web-mini-stat-label">Negocios</div>
                        <div class="web-mini-stat-value">{{ $stats['stores'] }}</div>
                    </div>
                </div>
            </div>

            <div class="web-card web-card-sm">
                <h3 class="web-panel-title">Top categorías en listas</h3>
                @forelse($topCategories as $row)
                    <div class="web-list-item">
                        <span>{{ $row->category?->name ?? 'Sin categoría' }}</span>
                        <strong>{{ $row->total }}</strong>
                    </div>
                @empty
                    <p class="text-sm" style="color: var(--on-surface-muted);">Sin datos de categorías.</p>
                @endforelse
            </div>
        </div>
    </div>
@endsection
