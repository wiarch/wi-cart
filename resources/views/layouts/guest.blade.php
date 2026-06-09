<!DOCTYPE html>
<html lang="{{ str_replace('_', '-', app()->getLocale()) }}">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="csrf-token" content="{{ csrf_token() }}">
    <title>@yield('title', 'Wi Cart')</title>

    <script>
        if (localStorage.getItem('theme') === 'light') {
            document.documentElement.classList.add('light');
        } else {
            document.documentElement.classList.add('dark');
        }
    </script>

    <link rel="stylesheet" href="{{ asset('css/tailwind/tailwind.min.css') }}">
    <link rel="stylesheet" href="{{ asset('css/lib/fontawesome/css/all.min.css') }}">
    <link rel="stylesheet" href="{{ asset('css/custom.css') }}">
    <script src="{{ asset('js/lib/jquery.min.js') }}"></script>
    <script src="{{ asset('js/lib/sweetalert2.all.min.js') }}"></script>
</head>
<body>
    <div class="auth-shell">
        <div class="w-full max-w-md animate-slide-up">
            <div class="auth-brand">
                <div class="auth-brand-icon logo-gradient">
                    <i class="fa-solid fa-cart-shopping"></i>
                </div>
                <h1 class="text-xl font-bold tracking-tight">Wi Cart</h1>
                <p class="text-sm mt-1" style="color: var(--on-surface-muted);">Listas de compra inteligentes</p>
            </div>

            @yield('content')
        </div>
    </div>

    <script>
        @if (session('status'))
            Swal.fire({
                icon: 'info',
                title: 'Aviso',
                text: @json(session('status')),
                confirmButtonColor: '#7c3aed',
            });
        @endif
    </script>
</body>
</html>
