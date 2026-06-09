<!DOCTYPE html>
<html lang="{{ str_replace('_', '-', app()->getLocale()) }}">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="csrf-token" content="{{ csrf_token() }}">

    <script>
        if (localStorage.getItem('theme') === 'light') {
            document.documentElement.classList.add('light');
        } else {
            document.documentElement.classList.add('dark');
        }
    </script>

    <title>@yield('title', 'Wi Cart')</title>

    <link rel="stylesheet" href="{{ asset('css/tailwind/tailwind.min.css') }}">
    <link rel="stylesheet" href="{{ asset('css/lib/fontawesome/css/all.min.css') }}">
    <link rel="stylesheet" href="{{ asset('css/custom.css') }}">

    <script src="{{ asset('js/lib/jquery.min.js') }}"></script>
    <script src="{{ asset('js/lib/sweetalert2.all.min.js') }}"></script>

    <link rel="stylesheet" href="{{ asset('css/lib/datatables/jquery.dataTables.min.css') }}">
    <link rel="stylesheet" href="{{ asset('css/lib/datatables/responsive.dataTables.min.css') }}">
    <script src="{{ asset('js/lib/datatables/jquery.dataTables.min.js') }}"></script>
    <script src="{{ asset('js/lib/datatables/dataTables.responsive.min.js') }}"></script>
    <script src="{{ asset('js/web-datatable.js') }}"></script>
</head>
<body>
@php
    $user = Auth::user();
    $avatarUrl = 'https://ui-avatars.com/api/?name=' . urlencode($user->name) . '&background=7c3aed&color=fff&size=128';
@endphp

<div class="web-app" id="web-app">
    <div id="sidebar-overlay" class="web-sidebar-overlay"></div>

    <aside id="web-sidebar" class="web-sidebar">
        <a href="{{ route('dashboard') }}" class="web-brand">
            <div class="web-brand-icon">
                <i class="fa-solid fa-cart-shopping"></i>
            </div>
            <span class="web-brand-text">Wi Cart</span>
        </a>

        <nav class="web-nav">
            <div class="web-nav-section">
                <span class="web-nav-label">Principal</span>
                <a href="{{ route('dashboard') }}" class="web-nav-link {{ request()->routeIs('dashboard') ? 'active' : '' }}">
                    <i class="fa-solid fa-gauge-high"></i>
                    <span>Dashboard</span>
                </a>
                <a href="{{ route('lists.index') }}" class="web-nav-link {{ request()->routeIs('lists.*') ? 'active' : '' }}">
                    <i class="fa-solid fa-list-check"></i>
                    <span>Mis listas</span>
                </a>
                <a href="{{ route('analytics.index') }}" class="web-nav-link {{ request()->routeIs('analytics.*') ? 'active' : '' }}">
                    <i class="fa-solid fa-chart-line"></i>
                    <span>Análisis</span>
                </a>
            </div>

            <div class="web-nav-section">
                <span class="web-nav-label">Gestión diaria</span>
                <a href="{{ route('stores.index') }}" class="web-nav-link {{ request()->routeIs('stores.*') ? 'active' : '' }}">
                    <i class="fa-solid fa-store"></i>
                    <span>Negocios</span>
                </a>
                <a href="{{ route('products.index') }}" class="web-nav-link {{ request()->routeIs('products.*') ? 'active' : '' }}">
                    <i class="fa-solid fa-box"></i>
                    <span>Productos</span>
                </a>
            </div>

            <div class="web-nav-section">
                <span class="web-nav-label">Administración</span>
                <a href="{{ route('categories.index') }}" class="web-nav-link {{ request()->routeIs('categories.*') ? 'active' : '' }}">
                    <i class="fa-solid fa-tags"></i>
                    <span>Categorías</span>
                </a>
                <a href="{{ route('units.index') }}" class="web-nav-link {{ request()->routeIs('units.*') ? 'active' : '' }}">
                    <i class="fa-solid fa-scale-balanced"></i>
                    <span>Unidades</span>
                </a>
                <a href="{{ route('settings') }}" class="web-nav-link {{ request()->routeIs('settings') ? 'active' : '' }}">
                    <i class="fa-solid fa-sliders"></i>
                    <span>Configuración</span>
                </a>
            </div>
        </nav>

        <div class="web-sidebar-footer">
            <a href="#" data-open-profile data-current-name="{{ $user->name }}" class="web-nav-link">
                <i class="fa-solid fa-user"></i>
                <span>Mi perfil</span>
            </a>
        </div>
    </aside>

    <div class="web-main">
        <header class="web-topbar">
            <button id="sidebar-toggle" type="button" class="web-icon-btn web-menu-toggle" aria-label="Menú" aria-expanded="true">
                <i class="fa-solid fa-bars" id="sidebar-toggle-icon"></i>
            </button>

            <div class="web-search" id="global-search">
                <i class="fa-solid fa-magnifying-glass"></i>
                <input
                    type="search"
                    id="global-search-input"
                    placeholder="Buscar listas, productos, negocios..."
                    aria-label="Buscar"
                    autocomplete="off"
                >
                <button type="button" id="global-search-clear" class="web-search-clear hidden" aria-label="Limpiar búsqueda">
                    <i class="fa-solid fa-xmark"></i>
                </button>
                <div id="global-search-results" class="web-search-dropdown hidden"></div>
            </div>

            <div class="web-topbar-actions">
                <button type="button" class="web-icon-btn" aria-label="Notificaciones">
                    <i class="fa-regular fa-bell"></i>
                </button>

                <div class="dropdown-wrapper relative">
                    <button type="button" data-toggle="dropdown" class="web-user-chip border-none">
                        <img src="{{ $avatarUrl }}" alt="{{ $user->name }}" class="web-user-avatar">
                        <div class="hidden sm:block text-left">
                            <div class="web-user-name">{{ $user->name }}</div>
                            <div class="web-user-email">{{ $user->email }}</div>
                        </div>
                        <i class="fa-solid fa-chevron-down text-xs text-on-surface-muted hidden sm:inline"></i>
                    </button>

                    <div class="dropdown-menu web-dropdown hidden">
                        <div style="padding: 0.5rem 0.75rem 0.75rem; border-bottom: 1px solid var(--border); margin-bottom: 0.25rem;">
                            <div class="web-user-name">{{ $user->name }}</div>
                            <div class="web-user-email" style="max-width: none;">{{ $user->email }}</div>
                        </div>
                        <form method="POST" action="{{ route('logout') }}">
                            @csrf
                            <button type="submit" class="logout-button">
                                <i class="fa-solid fa-right-from-bracket"></i>
                                Cerrar sesión
                            </button>
                        </form>
                    </div>
                </div>
            </div>
        </header>

        <div class="web-page">
            @unless (View::hasSection('header_inside_card'))
                <div class="web-page-header">
                    <div>
                        <h1 class="web-page-title">@yield('header_title', 'Dashboard')</h1>
                        @hasSection('header_meta')
                            <div class="web-page-meta">@yield('header_meta')</div>
                        @endif
                        <p class="web-page-subtitle">@yield('header_description', 'Panel de control de tus compras.')</p>
                    </div>
                    @hasSection('header_actions')
                        <div class="flex items-center gap-2 flex-wrap">@yield('header_actions')</div>
                    @endif
                </div>
            @endunless

            @yield('content')
        </div>
    </div>
</div>

@include('partials.modals')

<script src="{{ asset('js/web-crud.js') }}"></script>
<script src="{{ asset('js/web-search.js') }}"></script>
<script>
    $(function () {
        const app = document.getElementById('web-app');
        const toggleBtn = document.getElementById('sidebar-toggle');
        const toggleIcon = document.getElementById('sidebar-toggle-icon');
        const storageKey = 'wi-cart-sidebar-collapsed';

        const updateToggleUi = () => {
            const collapsed = app.classList.contains('sidebar-collapsed');
            toggleBtn?.setAttribute('aria-expanded', collapsed ? 'false' : 'true');
            if (toggleIcon) {
                toggleIcon.className = collapsed ? 'fa-solid fa-angles-right' : 'fa-solid fa-bars';
            }
        };

        if (localStorage.getItem(storageKey) === '1') {
            app.classList.add('sidebar-collapsed');
        }
        updateToggleUi();

        toggleBtn?.addEventListener('click', function (e) {
            e.preventDefault();
            e.stopPropagation();
            app.classList.toggle('sidebar-collapsed');
            localStorage.setItem(storageKey, app.classList.contains('sidebar-collapsed') ? '1' : '0');
            updateToggleUi();
        });

        $('[data-toggle="dropdown"]').on('click', function (e) {
            e.stopPropagation();
            const menu = $(this).siblings('.dropdown-menu');
            $('.dropdown-menu').not(menu).addClass('hidden');
            menu.toggleClass('hidden');
        });

        $(document).on('click', function () {
            $('.dropdown-menu').addClass('hidden');
        });
    });

    const AppSwal = Swal.mixin({
        confirmButtonColor: '#7c3aed',
        cancelButtonColor: '#64748b',
        customClass: {
            popup: 'rounded-xl',
            confirmButton: 'rounded-lg font-semibold px-5 py-2',
            cancelButton: 'rounded-lg font-semibold px-5 py-2',
        },
    });

    @if (session('status'))
        AppSwal.fire({
            icon: 'success',
            title: 'Listo',
            text: @json(session('status')),
            timer: 3000,
            showConfirmButton: false,
            toast: true,
            position: 'top-end',
        });
    @endif

    window.confirmDelete = function (formId, message = '¿Eliminar este elemento?') {
        AppSwal.fire({
            title: 'Confirmar',
            text: message,
            icon: 'warning',
            showCancelButton: true,
            confirmButtonText: 'Eliminar',
            cancelButtonText: 'Cancelar',
            reverseButtons: true,
        }).then((result) => {
            if (result.isConfirmed) {
                document.getElementById(formId).submit();
            }
        });
    };
</script>
</body>
</html>
