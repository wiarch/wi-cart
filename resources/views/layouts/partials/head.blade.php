<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="csrf-token" content="{{ csrf_token() }}">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=0, minimal-ui">
    <meta name="description" content="ryes">
    <meta name="keywords" content="admin ryes">
    <meta name="author" content="ITOeste">

    <title>{{ config('app.name', 'List Market') }} - @yield('title')</title>

    <link rel="shortcut icon" href="assets/images/favicon.png" />

    <!-- Fonts -->
    <link rel="preconnect" href="https://fonts.bunny.net">
    <link href="https://fonts.bunny.net/css?family=figtree:400,600&display=swap" rel="stylesheet" />

    @include('layouts.partials.style')

    @yield('css')
</head>