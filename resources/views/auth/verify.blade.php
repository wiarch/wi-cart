<!DOCTYPE html>
<html lang="{{ str_replace('_', '-', app()->getLocale()) }}">

<head>
    <meta charset="utf-8">
    <title>{{ config('app.name') }} - Verificación</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="{{ asset('favicon.ico') }}" rel="icon">

    <!-- Inclusión de estilos principales -->
    @include('auth.partials.styles') <!-- Estilos personalizados para autenticación -->

</head>

<body>
    <!-- Loader general, mostrado mientras la página carga -->
    @include('layouts.partials.spinner')

    <!-- Contenedor principal con fondo y formulario centrado -->
    <div class="bg-form d-flex align-items-center justify-content-center">
        <div class="bg-img"></div> <!-- Imagen o fondo decorativo -->
        <div class="form-container">

            <div class="main d-flex align-items-center justify-content-center flexbox-container shrink">

                <div class="container b-container" id="b-container">
                    <form class="form" id="code-form" method="POST" action="{{ route('login') }}">
                        @csrf
                        <input type="hidden" name="email" value="{{ $email }}">
                        <a href="{{ route('home') }}">
                            <img src="{{ asset('img/proganadero/logo/negro.png') }}" alt="logo" width="300px"
                                class="mb-2">
                        </a>
                        <small class="text-dark text-center mb-2">Se le enviara
                            un código
                            al Email proporcionado para verificar que tenga la propiedad de esta cuenta <b>(Solo se hara
                                una
                                unica vez)</b></small>

                        <label for="code" class="text-dark"
                            style="font-size: 1.2rem; font-weight: bold; display: block; margin-bottom: 5px;">
                            Código de verificación
                        </label>
                        <input id="code" class="form__input"
                            style="width: 22% !important; font-size: 1.5rem !important" type="text" maxlength="6" name="code">

                        <a href="javascript:void(0)" onclick="formPostAjax('#code-form')"
                            class="form__button btn submit btn-dark rounded-pill mt-4">Verificar</a>

                        <small class="text-dark text-center mt-4">Si no recibiste el correo, revisa tu bandeja de spam,
                            si no encuentras el correo, puedes <br>
                            <a href="{{ route('login.verify.resend', ['email' => $email]) }}"
                                class="switch-btn mt-4">Reenviar Código</a></small>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <!-- Inclusión de librerías necesarias -->
    @include('layouts.partials.libs.bootstrap')
    @include('layouts.partials.libs.sweetalert')
    @include('layouts.partials.scripts.main') <!-- Scripts personalizados generales -->

</body>

</html>
