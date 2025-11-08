<!DOCTYPE html>
<html lang="{{ str_replace('_', '-', app()->getLocale()) }}">

<head>
    <meta charset="utf-8">
    <title>{{ config('app.name') }} - Autenticación</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="favicon.ico" rel="icon">

    <!-- Inclusión de estilos principales -->
    @include('auth.partials.styles') <!-- Estilos personalizados para autenticación -->
    @include('layouts.partials.styles.main') <!-- Estilos personalizados para autenticación -->
    @include('layouts.partials.libs.bootstrap')

</head>

<body>

    <!-- Loader general, mostrado mientras la página carga -->
    @include('layouts.partials.spinner')

    <!-- Contenedor principal con fondo y formulario centrado -->
    <div class="bg-form d-flex align-items-center justify-content-center">
        <div class="bg-img"></div> <!-- Imagen o fondo decorativo -->
        <div class="form-container">

            <div class="main d-flex align-items-center justify-content-center flexbox-container">

                {{-- LOGIN --}}
                <div class="container b-container" id="b-container">
                    <form class="form" id="b-form" method="POST" action="{{ route('login') }}">
                        @csrf
                        <a href="{{ route('home') }}">
                            <img src="{{ asset('img/proganadero/logo/negro.png') }}" alt="logo" width="300px"
                                class="mb-3">
                        </a>
                        <p class="description text-dark">Mantenerse conectado con nosotros,
                            inicie sesión</p>

                        <div class="row d-flex justify-content-center">
                            <div class="col-12">
                                <input class="form__input form-control required" type="email"
                                    placeholder="Correo electrónico" name="email_login" value="testing@itoeste.com">
                            </div>

                            <!-- Asegúrate de tener FontAwesome cargado -->
                            <div class="col-12 position-relative">
                                <input id="password_login" class="form__input form-control required" type="password"
                                    placeholder="Contraseña" name="password_login" style="padding-right: 40px;">
                                <span id="togglePassword"
                                    style="position: absolute; right: 5%; top: 35%; transform: translateY(-50%); cursor: pointer; color: #999;">
                                    <i class="fa-solid fa-eye"></i>
                                </span>
                            </div>

                            <script>
                                const togglePassword = document.querySelector('#togglePassword');
                                const passwordInput = document.querySelector('#password_login');

                                togglePassword.addEventListener('click', function() {
                                    const type = passwordInput.getAttribute('type') === 'password' ? 'text' : 'password';
                                    passwordInput.setAttribute('type', type);

                                    // Cambiar icono
                                    this.innerHTML = type === 'password' ?
                                        '<i class="fa-solid fa-eye"></i>' :
                                        '<i class="fa-solid fa-eye-slash"></i>';
                                });
                            </script>


                        </div>

                        <a href="javascript:void(0)" onclick="formPostAjax('#b-form')"
                            class="form__button btn submit btn-dark rounded-pill">Iniciar Sesión</a>

                        <p class="description text-dark">Si aun no tienes una cuenta <a href="#"
                                class="switch-btn">Registrarse</a></p>
                    </form>
                </div>

                {{-- REGISTER --}}
                <div class="container a-container" id="a-container">

                    <div class="row">
                        <div class="col-12 mb-3">
                            <div class="text-center">
                                <img src="img/proganadero/logo/negro.png" alt="logo" width="300px">
                                {{-- <h2 class="title">¡Bienvenido!</h2> --}}
                                <p class="description text-dark">Introduce tus datos personales y
                                    comienza con
                                    nosotros
                                </p>
                            </div>
                        </div>

                        <div class="col-12">
                            <!--Datos-->
                            <div class="form-container" data-animation="scaleIn">
                                <!-- Contenedor con scroll -->
                                <div class="d-flex justify-content-center">
                                    <form class="form" id="a-form" method="POST" action="{{ route('register') }}">
                                        @csrf
                                        <div class="row">
                                            <div class="col-12 col-sm-6">
                                                <input class="form__input form-control required" type="text"
                                                    name="name" plac eholder="Nombres" />
                                            </div>

                                            <div class="col-12 col-sm-6">
                                                <input class="form__input form-control required" type="text"
                                                    name="last_name" placeholder="Apellidos" />
                                            </div>

                                            <div class="col-12 col-sm-6">
                                                <input class="form__input form-control required" type="email"
                                                    name="email" placeholder="Correo electrónico" />
                                            </div>

                                            <div class="col-12 col-sm-6">
                                                <input class="form__input form-control required" type="password"
                                                    name="password" placeholder="Contraseña" />
                                            </div>

                                            <div class="col-12 col-sm-6">
                                                <input class="form__input form-control required" type="text"
                                                    name="phone" placeholder="Teléfono" />
                                            </div>

                                            <div class="col-12 col-sm-6">
                                                <input class="form__input form-control required" type="password"
                                                    name="password_confirmation" placeholder="Confirmar Contraseña" />
                                            </div>

                                            <div class="col-12 col-sm-6">
                                                <input class="form__input form-control required" type="text"
                                                    name="address" placeholder="Dirección" />
                                            </div>

                                            <div class="col-12 col-sm-6">
                                                <input class="form__input form-control required" type="text"
                                                    name="cuit" placeholder="CUIT (11 dígitos)" maxlength="11"
                                                    pattern="\d{11}" inputmode="numeric"
                                                    oninput="this.value = this.value.replace(/\D/g, '').slice(0, 11)" />
                                            </div>

                                            <div class="col-12 col-sm-6">
                                                <select class="regions required" name="region">
                                                </select>
                                            </div>

                                            <div class="col-12 col-sm-6">
                                                <input class="form__input form-control required" type="text"
                                                    name="seller" placeholder="Vendedor" />
                                            </div>
                                        </div>
                                        <a href="javascript:void(0)" onclick="formPostAjax('#a-form')"
                                            class="form__button btn submit btn-dark rounded-pill">Registrarse</a>

                                        <p class="description text-dark mt-4">¿Ya tienes una cuenta? <a href="#"
                                                class="switch-btn">Iniciar Sesion</a></p>
                                    </form>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Inclusión de librerías necesarias -->

    <script src="{{ asset('libs/jquery/jquery.min.js') }}"></script>
    <script src="{{ asset('libs/bootstrap/bootstrap.bundle.min.js') }}"></script>

    @include('layouts.partials.libs.sweetalert')
    @include('layouts.partials.libs.select2')
    @include('layouts.partials.scripts.main') <!-- Scripts personalizados generales -->
    @include('auth.partials.scripts') <!-- Scripts personalizados para autenticación -->
</body>

</html>
