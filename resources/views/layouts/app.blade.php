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
        @include('layouts.partials.fab')
    </div>


    @include('layouts.partials.script')
    
    <!-- Service worker registration -->
    @RegisterServiceWorkerScript
</body>

</html>
