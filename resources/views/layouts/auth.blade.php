<!doctype html>
<html lang="{{ str_replace('_', '-', app()->getLocale()) }}">

@include('layouts.partials.head')

<body>
    <div class="container-scroller">
        <div class="container-fluid page-body-wrapper full-page-wrapper">
            <div class="row w-100 m-0">
                <div class="content-wrapper full-page-wrapper d-flex align-items-center auth login-bg">
                    <div class="card col-lg-4 mx-auto">
                        <div class="card-body px-5 py-5">
                            @yield('content')
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    @include('layouts.partials.script')
    <!-- Service worker registration -->
    @RegisterServiceWorkerScript
</body>

</html>
