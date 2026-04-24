<!DOCTYPE html>
<html lang="{{ str_replace('_', '-', app()->getLocale()) }}">
    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1, viewport-fit=cover">
        <meta name="csrf-token" content="{{ csrf_token() }}">

        <title>@yield('title', config('app.name', 'Laravel'))</title>

        <script>
            if (localStorage.getItem('theme') === 'dark' || (!('theme' in localStorage) && window.matchMedia('(prefers-color-scheme: dark)').matches)) {
                document.documentElement.classList.add('dark');
            } else {
                document.documentElement.classList.remove('dark');
            }
        </script>

        <!-- Local Styles -->
        <link rel="stylesheet" href="{{ asset('css/tailwind/tailwind.min.css') }}">
        <link rel="stylesheet" href="{{ asset('css/lib/fontawesome/css/all.min.css') }}">
        <link rel="stylesheet" href="{{ asset('css/custom.css') }}">

        <!-- Scripts -->
        <script src="{{ asset('js/lib/jquery.min.js') }}"></script>
        <script src="{{ asset('js/lib/sweetalert2.all.min.js') }}"></script>

    <body class="bg-surface text-on-surface antialiased min-h-screen selection:bg-primary/20">
        <!-- Premium Theme Switch -->
        <div class="fixed top-8 right-8 z-50">
            <div class="theme-switch-wrapper">
                <label class="theme-switch-label" for="theme-toggle-switch">
                    <input type="checkbox" id="theme-toggle-switch" class="theme-toggle-input" />
                    <div class="theme-switch-stars"></div>
                    <div class="theme-switch-thumb anim-thumb">
                        <i id="thumb-icon" class="fa-solid fa-sun"></i>
                    </div>
                </label>
            </div>
        </div>

        <div class="relative min-h-screen flex items-center justify-center p-6 bg-surface">
            <div class="w-full max-w-lg z-10 animate-slide-up">
                <div class="flex flex-col items-center mb-8 text-center">
                    <div class="w-20 h-20 logo-gradient flex items-center justify-center shadow-2xl mb-4 border border-white/10 ring-4 ring-primary/5">
                        <i class="fa-solid fa-bag-shopping text-white text-4xl"></i>
                    </div>
                    <h1 class="text-2xl font-black tracking-tight text-on-surface">List Market</h1>
                </div>

                @yield('content')
            </div>
        </div>

        <script>
            $(document).ready(function() {
                const themeSwitch = $('#theme-toggle-switch');
                const thumbIcon = $('#thumb-icon');

                function updateThemeUI() {
                    const isDark = document.documentElement.classList.contains('dark');
                    themeSwitch.prop('checked', isDark);
                    if (isDark) {
                        thumbIcon.removeClass('fa-sun').addClass('fa-moon');
                    } else {
                        thumbIcon.removeClass('fa-moon').addClass('fa-sun');
                    }
                }

                updateThemeUI();

                themeSwitch.on('change', function() {
                    document.documentElement.classList.toggle('dark');
                    const isDark = document.documentElement.classList.contains('dark');
                    localStorage.setItem('theme', isDark ? 'dark' : 'light');
                    updateThemeUI();
                });
            });

            // SweetAlert2 Configuration for Guest
            const BotanicalSwal = Swal.mixin({
                confirmButtonColor: '#006b1b',
                cancelButtonColor: '#d33',
                customClass: {
                    popup: 'rounded-3xl border-none shadow-2xl bg-surface',
                    confirmButton: 'rounded-xl font-bold py-3 px-6 px-10',
                }
            });

            @if (session('status'))
                BotanicalSwal.fire({
                    icon: 'success',
                    title: 'Mensaje',
                    text: '{{ session('status') }}',
                    timer: 4000
                });
            @endif
        </script>
    </body>
</html>
