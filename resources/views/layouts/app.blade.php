<!doctype html>
<html lang="{{ str_replace('_', '-', app()->getLocale()) }}">

@include('layouts.partials.head')

<body>
    <div class="container-scroller">

        @include('layouts.partials.menu')

        <div class="container-fluid page-body-wrapper">
            @include('layouts.partials.navbar')

            @yield('content')

        </div>

    </div>
    @include('layouts.partials.script')
</body>

</html>