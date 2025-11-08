<!-- Sidebar -->
<div class="sidebar" data-background-color="dark">
    <div class="sidebar-logo">
        <!-- Logo Header -->
        <div class="logo-header" data-background-color="dark">
            <a href="{{ route('dashboard') }}" class="logo">
                <img src="{{ asset('img/proganadero/logo/blanco.png') }}" alt="navbar brand" class="navbar-brand"
                    height="70" width="235" />
            </a>
            <div class="nav-toggle">
                <button class="btn btn-toggle toggle-sidebar">
                    <i class="gg-menu-right"></i>
                </button>
                <button class="btn btn-toggle sidenav-toggler">
                    <i class="gg-menu-left"></i>
                </button>
            </div>
            <button class="topbar-toggler more">
                <i class="gg-more-vertical-alt"></i>
            </button>
        </div>
        <!-- End Logo Header -->
    </div>
    <div class="sidebar-wrapper scrollbar scrollbar-inner">
        <div class="sidebar-content">
            <ul class="nav nav-secondary">
                <li class="nav-item {{ Route::currentRouteName() !== 'dashboard' ? '' : 'active' }}" id="li-panel">
                    <a href="{{ route('dashboard') }}">
                        <i class="fas fa-home"></i>
                        <p>Panel</p>
                    </a>
                </li>
                <li class="nav-section">
                    <span class="sidebar-mini-icon">
                        <i class="fa fa-ellipsis-h"></i>
                    </span>
                    <h4 class="text-section">Modulos</h4>
                </li>
                @php
                    $routeName = Route::currentRouteName();
                @endphp

                <li
                    class="nav-item has-treeview {{ in_array($routeName, ['fields.index', 'rodeos.index', 'stocks.index,', 'batches.index', 'grazings.index', 'supplies.index', 'veterinary-supplies.index', 'stocks-reunion.index', 'herd-weighings.index']) ? 'menu-open' : '' }}">
                    <a data-bs-toggle="collapse" href="#fields">
                        <i class="fas fa-globe-americas"></i>
                        <p>Campos</p>
                        <span class="caret"></span>
                    </a>
                    <div class="collapse {{ in_array($routeName, ['fields.index', 'rodeos.index', 'stocks.index', 'batches.index', 'grazings.index', 'supplies.index', 'veterinary-supplies.index', 'stocks-reunion.index', 'herd-weighings.index']) ? 'show' : '' }}"
                        id="fields">
                        <ul class="nav nav-collapse">

                            <li id="li-fields" class="{{ $routeName === 'fields.index' ? 'active' : '' }}">
                                <a href="{{ route('fields.index') }}" class="nav-link">
                                    @if ($routeName === 'fields.index')
                                        <i class="fas fa-leaf"></i>
                                    @endif
                                    Listado de campos
                                </a>
                            </li>

                            <li id="li-batches" class="{{ $routeName === 'batches.index' ? 'active' : '' }}">
                                <a href="{{ route('batches.index') }}" class="nav-link">
                                    @if ($routeName === 'batches.index')
                                        <i class="fas fa-layer-group"></i>
                                    @endif
                                    Listado de lotes
                                </a>
                            </li>

                            <li id="li-rodeos" class="{{ $routeName === 'rodeos.index' ? 'active' : '' }}">
                                <a href="{{ route('rodeos.index') }}">
                                    @if ($routeName === 'rodeos.index')
                                        <i class="fas fa-kiwi-bird"></i>
                                    @endif
                                    Listado de Rodeos
                                </a>
                            </li>

                            <li id="li-stocks" class="{{ $routeName === 'stocks.index' ? 'active' : '' }}">
                                <a href="{{ route('stocks.index') }}">
                                    @if ($routeName === 'stocks.index')
                                        <i class="fas fa-boxes"></i>
                                    @endif
                                    Listado de Stocks
                                </a>
                            </li>

                            <li id="li-grazings" class="{{ $routeName === 'grazings.index' ? 'active' : '' }}">
                                <a href="{{ route('grazings.index') }}">
                                    @if ($routeName === 'grazings.index')
                                        <i class="fas fa-cow"></i>
                                    @endif
                                    Listado de Pastoreos
                                </a>
                            </li>

                            <li id="li-supplies" class="{{ $routeName === 'supplies.index' ? 'active' : '' }}">
                                <a href="{{ route('supplies.index') }}">
                                    @if ($routeName === 'supplies.index')
                                        <i class="fas fa-box-open"></i>
                                    @endif
                                    Listado de Insumos
                                </a>
                            </li>

                            <li id="li-reasons" class="{{ $routeName === 'reasons.index' ? 'active' : '' }}">
                                <a href="{{ route('reasons.index') }}">
                                    @if ($routeName === 'reasons.index')
                                        <i class="fas fa-drumstick-bite"></i>
                                    @endif
                                    Listado de Ración
                                </a>
                            </li>

                            <li id="li-terminations" class="{{ $routeName === 'terminations.index' ? 'active' : '' }}">
                                <a href="{{ route('terminations.index') }}">
                                    @if ($routeName === 'terminations.index')
                                        <i class="fas fa-seedling"></i>
                                    @endif
                                    Listado de Recría y Terminación
                                </a>
                            </li>

                            <li id="li-veterinary-supplies"
                                class="{{ $routeName === 'veterinary-supplies.index' ? 'active' : '' }}">
                                <a href="{{ route('veterinary-supplies.index') }}">
                                    @if ($routeName === 'veterinary-supplies.index')
                                        <i class="fas fa-utensils"></i>
                                    @endif
                                    Listado de Insumos Veterinarios
                                </a>
                            </li>

                            <li id="li-stocks-reunion"
                                class="{{ $routeName === 'stocks-reunion.index' ? 'active' : '' }}">
                                <a href="{{ route('stocks-reunion.index') }}">
                                    @if ($routeName === 'stocks-reunion.index')
                                        <i class="fas fa-box"></i>
                                    @endif
                                    Listado de Rencuentro de Stocks
                                </a>
                            </li>

                            <li id="li-herd-weighings"
                                class="{{ $routeName === 'herd-weighings.index' ? 'active' : '' }}">
                                <a href="{{ route('herd-weighings.index') }}">
                                    @if ($routeName === 'herd-weighings.index')
                                        <i class="fas fa-weight-hanging"></i>
                                    @endif
                                    Listado de Control de Peso
                                </a>
                            </li>
                        </ul>
                    </div>
                </li>

                <li class="nav-item has-treeview">
                    <a data-bs-toggle="collapse" href="#events">
                        <i class="fas fa-calendar"></i>
                        <p>Eventos</p>
                        <span class="caret"></span>
                    </a>
                    <div class="collapse  {{ in_array($routeName, ['events.logs.list', 'events.reproductions.list', 'events.sanitary.list', 'events.deaths.list', 'events.feedings.list']) ? 'show' : '' }}"
                        id="events">
                        <ul class="nav nav-collapse">

                            <li id="li-event-logs" class="{{ $routeName === 'events.logs.list' ? 'active' : '' }}">
                                <a href="{{ route('events.logs.list') }}" class="nav-link">
                                    @if ($routeName === 'events.logs.list')
                                        <i class="fas fa-clock"></i>
                                    @endif
                                    Lista de Historial
                                </a>
                            </li>

                            <li id="li-event-reproductions"
                                class="{{ $routeName === 'events.reproductions.list' ? 'active' : '' }}">
                                <a href="{{ route('events.reproductions.list') }}" class="nav-link">
                                    @if ($routeName === 'events.reproductions.list')
                                        <i class="fas fa-venus-mars"></i>
                                    @endif
                                    Lista de Reproducción
                                </a>
                            </li>

                            <li id="li-event-sanitary"
                                class="{{ $routeName === 'events.sanitary.list' ? 'active' : '' }}">
                                <a href="{{ route('events.sanitary.list') }}" class="nav-link">
                                    @if ($routeName === 'events.sanitary.list')
                                        <i class="fas fa-syringe"></i>
                                    @endif
                                    Lista de Sanitarios
                                </a>
                            </li>

                            <li id="li-event-deaths"
                                class="{{ $routeName === 'events.deaths.list' ? 'active' : '' }}">
                                <a href="{{ route('events.deaths.list') }}" class="nav-link">
                                    @if ($routeName === 'events.deaths.list')
                                        <i class="fas fa-skull"></i>
                                    @endif
                                    Lista de Bajas
                                </a>
                            </li>

                            <li id="li-event-feedings"
                                class="{{ $routeName === 'events.feedings.list' ? 'active' : '' }}">
                                <a href="{{ route('events.feedings.list') }}" class="nav-link">
                                    @if ($routeName === 'events.feedings.list')
                                        <i class="fas fa-apple-alt"></i>
                                    @endif
                                    Lista de Pesadas
                                </a>
                            </li>

                        </ul>
                    </div>
                </li>
            </ul>
        </div>
    </div>
</div>
<!-- End Sidebar -->
