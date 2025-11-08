<!DOCTYPE html>
<html lang="en">

<head>
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <title>{{ config('app.name') }} - @yield('title')</title>
    <meta content="width=device-width, initial-scale=1.0, shrink-to-fit=no" name="viewport" />
    <meta name="csrf-token" content="{{ csrf_token() }}">

    <!-- Favicon -->
    <link href="{{ asset('favicon.ico') }}" rel="icon">

    <!-- Fonts and icons -->
    <script src="{{ asset('dashboard/assets/js/plugin/webfont/webfont.min.js') }}"></script>
    <script>
        WebFont.load({
            google: {
                families: ["Public Sans:300,400,500,600,700"]
            },
            custom: {
                families: [
                    "Font Awesome 5 Solid",
                    "Font Awesome 5 Regular",
                    "Font Awesome 5 Brands",
                    "simple-line-icons",
                ],
                urls: ["{{ asset('dashboard/assets/css/fonts.min.css') }}"],
            },
            active: function() {
                sessionStorage.fonts = true;
            },
        });
    </script>

    @yield('css')

    <!--   Core JS Files   -->
    @include('layouts.partials.libs.bootstrap')
    <link rel="stylesheet" href="{{ asset('dashboard/assets/css/kaiadmin.min.css') }}" />


</head>

<body>

    @include('layouts.partials.spinner')

    <div class="wrapper">

        @include('layouts.partials.sidebar')

        <div class="main-panel">
            @include('layouts.partials.navbar')
            <div class="container">
                <div class="page-inner">
                    @yield('content')
                </div>
            </div>

            @include('layouts.partials.footer')

        </div>
    </div>



    <script src="{{ asset('libs/jquery/jquery.min.js') }}"></script>
    <script src="{{ asset('libs/bootstrap/bootstrap.bundle.min.js') }}"></script>


    @yield('styles')

    <!-- jQuery Scrollbar -->
    <script src="{{ asset('dashboard/assets/js/plugin/jquery-scrollbar/jquery.scrollbar.min.js') }}"></script>

    <!-- Kaiadmin JS -->
    <script src="{{ asset('dashboard/assets/js/kaiadmin.min.js') }}"></script>

    @include('layouts.partials.libs.datatables')
    @include('layouts.partials.libs.sweetalert')
    @include('layouts.partials.libs.select2')
    @include('layouts.partials.scripts.main')
    @include('layouts.partials.libs.intro')

    @yield('scripts')

    @include('layouts.partials.styles.main')

</body>

</html>
