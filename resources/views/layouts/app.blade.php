<!DOCTYPE html>
<html lang="{{ str_replace('_', '-', app()->getLocale()) }}">
    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1, viewport-fit=cover">
        <meta name="csrf-token" content="{{ csrf_token() }}">

        <script>
            // Immediate check for dark mode to prevent flicker
            if (localStorage.getItem('theme') === 'dark' || (!('theme' in localStorage) && window.matchMedia('(prefers-color-scheme: dark)').matches)) {
                document.documentElement.classList.add('dark');
            } else {
                document.documentElement.classList.remove('dark');
            }
        </script>

        <title>@yield('title', config('app.name', 'Laravel'))</title>

        <!-- Local Styles -->
        <link rel="stylesheet" href="{{ asset('css/tailwind/tailwind.min.css') }}">
        <link rel="stylesheet" href="{{ asset('css/lib/fontawesome/css/all.min.css') }}">
        <link rel="stylesheet" href="{{ asset('css/custom.css') }}">

        <!-- Local Scripts -->
        <script src="{{ asset('js/lib/jquery.min.js') }}"></script>
        <script src="{{ asset('js/lib/sweetalert2.all.min.js') }}"></script>

        <!-- DataTables Local -->
        <link rel="stylesheet" href="{{ asset('css/lib/datatables/jquery.dataTables.min.css') }}">
        <link rel="stylesheet" href="{{ asset('css/lib/datatables/responsive.dataTables.min.css') }}">
        <script src="{{ asset('js/lib/datatables/jquery.dataTables.min.js') }}"></script>
        <script src="{{ asset('js/lib/datatables/dataTables.responsive.min.js') }}"></script>

    </head>
    <body class="bg-surface text-on-surface antialiased transition-colors duration-300">
        <div class="app-layout">
            <!-- Sidebar Overlay (Mobile) -->
            <div id="sidebar-overlay" class="sidebar-overlay"></div>

            <!-- Sidebar -->
            <aside id="main-sidebar" class="botanical-sidebar botanical-sidebar-mobile p-6 flex flex-col">
                <!-- Sidebar Branding -->
                <div class="flex items-center gap-3 mb-10 px-2">
                    <div class="w-10 h-10 logo-gradient rounded-xl flex items-center justify-center shadow-lg">
                        <i class="fa-solid fa-bag-shopping text-white text-xl"></i>
                    </div>
                    <span class="text-xl font-black tracking-tight text-on-surface">List Market</span>
                </div>

                <!-- Sidebar Nav -->
                <nav class="flex-grow space-y-1">
                    <a href="{{ route('dashboard') }}" class="nav-vertical-link {{ request()->routeIs('dashboard') ? 'nav-vertical-link-active' : '' }}">
                        <i class="fa-solid fa-list-check"></i>
                        <span>Mis Listas</span>
                    </a>
                    <a href="#" class="nav-vertical-link opacity-50">
                        <i class="fa-solid fa-basket-shopping"></i>
                        <span>Productos</span>
                    </a>
                    <a href="#" class="nav-vertical-link {{ request()->is('analisis*') ? 'nav-vertical-link-active' : '' }} opacity-50">
                        <i class="fa-solid fa-chart-pie"></i>
                        <span>Análisis</span>
                    </a>

                    <!-- Submenu: Configuración -->
                    <div class="pt-4 border-t border-outline-variant/5">
                        <button class="nav-vertical-link w-full flex items-center justify-between group cursor-pointer border-none bg-transparent" id="sidebar-config-toggle">
                            <div class="flex items-center gap-3">
                                <i class="fa-solid fa-gear group-hover:rotate-45 transition-transform"></i>
                                <span>Configuración</span>
                            </div>
                            <i class="fa-solid fa-chevron-down text-[10px] transition-transform duration-300" id="sidebar-config-chevron"></i>
                        </button>
                        
                        <div id="sidebar-config-menu" class="hidden pl-9 space-y-1 mt-1 overflow-hidden transition-all duration-300">
                            <a href="{{ route('stores.index') }}" class="nav-vertical-link py-2 h-auto text-xs {{ request()->routeIs('stores.*') ? 'nav-vertical-link-active' : 'opacity-60 hover:opacity-100' }}">
                                <i class="fa-solid fa-store scale-75"></i>
                                <span>Negocios</span>
                            </a>
                            <a href="{{ route('categories.index') }}" class="nav-vertical-link py-2 h-auto text-xs {{ request()->routeIs('categories.*') ? 'nav-vertical-link-active' : 'opacity-60 hover:opacity-100' }}">
                                <i class="fa-solid fa-tags scale-75"></i>
                                <span>Categorías</span>
                            </a>
                            <a href="{{ route('units.index') }}" class="nav-vertical-link py-2 h-auto text-xs {{ request()->routeIs('units.*') ? 'nav-vertical-link-active' : 'opacity-60 hover:opacity-100' }}">
                                <i class="fa-solid fa-scale-balanced scale-75"></i>
                                <span>Unidades</span>
                            </a>
                        </div>
                    </div>
                </nav>
            </aside>


            <!-- Main Content Area -->
            <div id="content-container" class="main-content flex flex-col min-h-screen">
                <!-- App Header (Unified PC & Mobile) -->
                <header class="flex items-center justify-between px-6 py-4 botanical-header sticky top-0 z-40 w-full">
                    <div class="flex items-center gap-4">
                        <!-- Sidebar Toggle (PC only) -->
                        <button id="sidebar-toggle" class="hidden sm:flex p-2 text-primary hover:bg-surface-container-low rounded-xl transition-all active:scale-90 border-none bg-transparent cursor-pointer">
                            <i class="fa-solid fa-bars-staggered text-xl"></i>
                        </button>

                        <!-- Logo & Brand (Mobile only) -->
                        <div class="flex sm:hidden items-center gap-2">
                            <i class="fa-solid fa-bag-shopping text-primary text-2xl"></i>
                            <h1 class="text-xl font-black tracking-tight text-on-surface">List Market</h1>
                        </div>

                        <h1 class="hidden sm:block text-sm font-black uppercase tracking-widest text-on-surface-variant opacity-60">Control Panel</h1>
                    </div>

                    <!-- Right Side: Theme Switch & Profile (Unified PC & Mobile) -->
                    <div class="flex items-center gap-2 sm:gap-4">
                        <!-- Theme Toggle Switch -->
                        <div class="theme-switch-wrapper scale-50 sm:scale-75 origin-right">
                            <label class="theme-switch-label" for="theme-toggle-switch-header">
                                <input type="checkbox" id="theme-toggle-switch-header" class="theme-toggle-input" />
                                <div class="theme-switch-stars"></div>
                                <div class="theme-switch-thumb anim-thumb">
                                    <i class="fa-solid fa-sun thumb-icon"></i>
                                </div>
                            </label>
                        </div>

                        <!-- Profile Dropdown Menu -->
                        <div class="dropdown-wrapper relative">
                            <button data-toggle="dropdown" class="flex items-center p-1 hover:bg-surface-container-low rounded-2xl transition-all cursor-pointer border-none bg-transparent">
                                <div class="w-10 h-10 rounded-xl border-2 border-primary/10 overflow-hidden shadow-sm">
                                    <img src="https://ui-avatars.com/api/?name={{ urlencode(Auth::user()->name) }}&color=006b1b&background=d1ffc8" alt="{{ Auth::user()->name }}">
                                </div>
                            </button>

                            <div class="dropdown-menu hidden absolute right-0 mt-3 w-64 botanical-dropdown rounded-2xl p-2 shadow-2xl">
                                <div class="px-4 py-3 border-b border-outline-variant/10 mb-2">
                                    <span class="block text-sm font-bold text-on-surface truncate">{{ Auth::user()->name }}</span>
                                    <span class="block text-[11px] text-on-surface-variant truncate">{{ Auth::user()->email }}</span>
                                </div>
                                
                                <form method="POST" action="{{ route('logout') }}">
                                    @csrf
                                    <button type="submit" class="w-full flex items-center gap-3 px-4 py-3 text-sm font-bold border-none bg-transparent text-left cursor-pointer logout-button rounded-xl transition-all">
                                        <i class="fa-solid fa-right-from-bracket opacity-70"></i>
                                        Cerrar Sesión
                                    </button>
                                </form>
                            </div>
                        </div>
                    </div>
                </header>

                <main class="p-4 sm:p-6 md:p-12 w-full max-w-screen-xl mx-auto flex-grow">
                    <div class="mb-10">
                        <span class="text-primary font-bold tracking-widest text-[10px] uppercase mb-2 block">@yield('category', 'Dashboard')</span>
                        <h2 class="text-4xl md:text-5xl font-black text-on-surface tracking-tighter leading-none mb-4">@yield('header_title', 'Mis Listas')</h2>
                        <p class="text-on-surface-variant max-w-md font-medium text-sm">@yield('header_description', 'Organiza tus compras con la precisión de un editor.')</p>
                    </div>

                    @yield('content')
                </main>
            </div>

            <!-- Bottom NavBar (Mobile Only) -->
            <nav class="fixed bottom-0 left-0 w-full bottom-nav sm:hidden z-50 rounded-t-[2rem]">
                <div class="flex justify-around items-center px-1 pt-3 pb-6 w-full">
                    <a href="{{ route('dashboard') }}" class="flex flex-col items-center justify-center gap-1 {{ request()->routeIs('dashboard') ? 'nav-item-active' : 'text-on-surface-variant' }} flex-1 py-1 no-underline active:scale-95 transition-all">
                        <i class="fa-solid fa-list-check bottom-nav-icon"></i>
                        <span class="font-bold tracking-tighter w-full text-center bottom-nav-text">Listas</span>
                    </a>
                    <a href="#" class="flex flex-col items-center justify-center gap-1 text-on-surface-variant/40 flex-1 py-1 no-underline active:scale-95 transition-all">
                        <i class="fa-solid fa-basket-shopping bottom-nav-icon"></i>
                        <span class="font-bold tracking-tighter w-full text-center bottom-nav-text">Productos</span>
                    </a>
                    <a href="#" class="flex flex-col items-center justify-center gap-1 text-on-surface-variant/40 flex-1 py-1 no-underline active:scale-95 transition-all">
                        <i class="fa-solid fa-chart-pie bottom-nav-icon"></i>
                        <span class="font-bold tracking-tighter w-full text-center bottom-nav-text">Analisis</span>
                    </a>
                    <a href="{{ route('settings') }}" class="flex flex-col items-center justify-center gap-1 {{ request()->routeIs('settings') ? 'nav-item-active' : 'text-on-surface-variant' }} flex-1 py-1 no-underline active:scale-95 transition-all">
                        <i class="fa-solid fa-gear bottom-nav-icon"></i>
                        <span class="font-bold tracking-tighter w-full text-center bottom-nav-text">Configuración</span>
                    </a>
                </div>
            </nav>
        </div>

        <!-- jQuery UI Logic -->
        <script>
            $(document).ready(function() {
                // Theme Toggle Logic
                const themeInputs = $('.theme-toggle-input');
                const thumbIcons = $('.thumb-icon');

                function updateThemeUI() {
                    const isDark = document.documentElement.classList.contains('dark');
                    themeInputs.prop('checked', isDark);
                    if (isDark) {
                        thumbIcons.removeClass('fa-sun').addClass('fa-moon');
                    } else {
                        thumbIcons.removeClass('fa-moon').addClass('fa-sun');
                    }
                }

                updateThemeUI();

                themeInputs.on('change', function() {
                    const isDark = $(this).prop('checked');
                    if (isDark) {
                        document.documentElement.classList.add('dark');
                    } else {
                        document.documentElement.classList.remove('dark');
                    }
                    localStorage.setItem('theme', isDark ? 'dark' : 'light');
                    updateThemeUI();
                });

                // Sidebar Config Submenu Toggle
                $('#sidebar-config-toggle').on('click', function() {
                    const menu = $('#sidebar-config-menu');
                    const chevron = $('#sidebar-config-chevron');
                    menu.toggleClass('hidden');
                    chevron.toggleClass('rotate-180');
                });

                // Sidebar Toggle Logic (PC)
                const sidebar = $('#main-sidebar');
                const content = $('#content-container');
                const sidebarToggle = $('#sidebar-toggle');

                sidebarToggle.on('click', function() {
                    sidebar.toggleClass('collapsed');
                    content.toggleClass('expanded');
                });

                // Profile Dropdown Logic (Mobile)
                $('[data-toggle="dropdown"]').on('click', function(e) {
                    e.stopPropagation();
                    const target = $(this).siblings('.dropdown-menu');
                    $('.dropdown-menu').not(target).addClass('hidden');
                    target.toggleClass('hidden');
                });

                $(document).on('click', function() {
                    $('.dropdown-menu').addClass('hidden');
                });
            });

            // SweetAlert2 Global Configuration
            const BotanicalSwal = Swal.mixin({
                confirmButtonColor: '#006b1b',
                cancelButtonColor: '#d33',
                customClass: {
                    popup: 'rounded-3xl border-none shadow-2xl',
                    confirmButton: 'rounded-xl font-bold py-3 px-6 px-10',
                    cancelButton: 'rounded-xl font-bold py-3 px-6'
                }
            });

            @if (session('status'))
                BotanicalSwal.fire({
                    icon: 'success',
                    title: '¡Operación Exitosa!',
                    text: '{{ session('status') }}',
                    timer: 3000,
                    showConfirmButton: false,
                    toast: true,
                    position: 'top-end'
                });
            @endif

            window.confirmDelete = function(formId, message = '¿Estás seguro de que deseas eliminar este elemento?') {
                BotanicalSwal.fire({
                    title: '¿Confirmar acción?',
                    text: message,
                    icon: 'warning',
                    showCancelButton: true,
                    confirmButtonText: 'Sí, eliminar',
                    cancelButtonText: 'Cancelar',
                    reverseButtons: true
                }).then((result) => {
                    if (result.isConfirmed) {
                        document.getElementById(formId).submit();
                    }
                });
            }
        </script>
    </body>
</html>
