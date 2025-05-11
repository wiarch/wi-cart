<!doctype html>
<html lang="{{ str_replace('_', '-', app()->getLocale()) }}">

<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="csrf-token" content="{{ csrf_token() }}">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=0, minimal-ui">
    <meta name="description" content="ryes">
    <meta name="keywords" content="admin ryes">
    <meta name="author" content="ITOeste">

    <title>{{ config('app.name', 'Ryes') }} - @yield('title')</title>

    {{-- <link rel="apple-touch-icon" href="{{ asset('assets/template/images/ico/apple-icon-120.png') }}"> --}}
    <link rel="shortcut icon" type="image/x-icon" href="{{ asset('assets/template/images/ico/favicon.ico') }}">
    <link href="https://fonts.googleapis.com/css?family=Montserrat:300,400,500,600" rel="stylesheet">

    <!-- BEGIN: Vendor CSS-->
    <link rel="stylesheet" href="{{ asset('assets/template/css/vendors.min.css') }}">
    <!-- END: Vendor CSS-->

    <!-- BEGIN: Theme CSS-->
    <link rel="stylesheet" href="{{ asset('assets/template/css/bootstrap.css') }}">
    <link rel="stylesheet" href="{{ asset('assets/template/css/bootstrap-extended.css') }}">
    <link rel="stylesheet" href="{{ asset('assets/template/css/colors.css') }}">
    <link rel="stylesheet" href="{{ asset('assets/template/css/components.css') }}">
    <link rel="stylesheet" href="{{ asset('assets/template/css/themes/dark-layout.css') }}">
    <link rel="stylesheet" href="{{ asset('assets/template/css/themes/semi-dark-layout.css') }}">

    <!-- BEGIN: Page CSS-->
    <link rel="stylesheet" href="{{ asset('assets/template/css/core/menu/menu-types/horizontal-menu.css') }}">
    <link rel="stylesheet" href="{{ asset('assets/template/css/core/colors/palette-gradient.css') }}">
    <link rel="stylesheet" href="{{ asset('assets/template/css/pages/authentication.css') }}">
    <!-- END: Page CSS-->

    <!-- BEGIN: Custom CSS-->
    {{-- <link rel="stylesheet" href="{{ asset('') }}"> --}}
    <!-- END: Custom CSS-->

</head>

<body
    class="horizontal-layout horizontal-menu 1-column  navbar-floating footer-static bg-full-screen-image  blank-page blank-page"
    data-open="hover" data-menu="horizontal-menu" data-col="1-column">

    <div id="app">

        <!-- BEGIN: Content-->
        <div class="app-content content">
            <div class="content-overlay"></div>
            <div class="header-navbar-shadow"></div>
            <div class="content-wrapper">
                <div class="content-header row">
                </div>
                <div class="content-body">

                    @yield('content')

                </div>
            </div>
        </div>

    </div>

    @include('layouts.components.sweetalert')

    <!-- BEGIN: Vendor JS-->
    <script src="{{ asset('assets/template/js/vendors.min.js') }}"></script>
    <!-- BEGIN Vendor JS-->

    <!-- BEGIN: Page Vendor JS-->
    <script src="{{ asset('assets/template/js/ui/jquery.sticky.js') }}"></script>
    <!-- END: Page Vendor JS-->

    <!-- BEGIN: Theme JS-->
    <script src="{{ asset('assets/template/js/core/app-menu.js') }}"></script>
    <script src="{{ asset('assets/template/js/core/app.js') }}"></script>
    <script src="{{ asset('assets/template/js/scripts/components.js') }}"></script>
    <!-- END: Theme JS-->
</body>

</html>
