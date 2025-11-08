<!DOCTYPE html>
<html lang="{{ str_replace('_', '-', app()->getLocale()) }}">

<head>
    <meta charset="utf-8">
    <title>{{ config('app.name') }}</title>
    <meta content="width=device-width, initial-scale=1.0" name="viewport">
    <meta content="" name="keywords">
    <meta content="" name="description">

    <!-- Favicon -->
    <link href="favicon.ico" rel="icon">

    <!-- Libraries Stylesheet -->
    <link href="libs/owlcarousel/assets/owl.carousel.min.css" rel="stylesheet"> <!-- Owl Carousel -->

    <!-- Template Stylesheet -->
    @include('layouts.partials.libs.bootstrap')

    @include('layouts.partials.styles.main')
    @include('layouts.partials.styles.welcome')
</head>

<body>
    <!-- Spinner Start -->
    @include('layouts.partials.spinner')
    <!-- Spinner End -->

    <!-- Topbar Start -->
    <div class="container-fluid bg-dark px-0">
        <div class="row g-0 d-none d-lg-flex">
            <div class="col-lg-6 ps-5 text-start">
                <div class="h-100 d-inline-flex align-items-center text-light">
                    <span>Siguenos:</span>
                    <a class="btn btn-link text-light" href=""><i class="fab fa-facebook-f"></i></a>
                    <a class="btn btn-link text-light" href=""><i class="fab fa-twitter"></i></a>
                    <a class="btn btn-link text-light" href=""><i class="fab fa-instagram"></i></a>
                </div>
            </div>
            <div class="col-lg-6 text-end">
                <div class="h-100 bg-secondary d-inline-flex align-items-center text-white py-2 px-4">
                    <span class="me-2 fw-semi-bold"><i class="fa fa-phone-alt me-2"></i>Llamanos:</span>
                    <span>+54 123456789</span>
                </div>
            </div>
        </div>
    </div>
    <!-- Topbar End -->

    <!-- Navbar Start -->
    <nav class="navbar navbar-expand-lg bg-white navbar-light sticky-top">
        <a href="index.html" class="navbar-brand d-flex align-items-center">
            <h1 class="m-0"><img src="img/proganadero/logo/negro.png" alt="logo" width="200px"></h1>
        </a>
        <button type="button" class="navbar-toggler me-0" data-bs-toggle="collapse" data-bs-target="#navbarCollapse">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarCollapse">
            <div class="navbar-nav ms-auto p-4 p-lg-0">
                <a href="#" class="nav-item nav-link active">Inicio</a>
                <a href="#about" class="nav-item nav-link">Quienes Somos</a>
            </div>
            <div class="border-start ps-4 d-none d-lg-block navbar-nav">
                <a href="{{ route('auth.form') }}" class="nav-item nav-link">Registro</a>
            </div>
        </div>
    </nav>
    <!-- Navbar End -->

    <!-- Carousel Start -->
    <div class="container-fluid px-0 mb-5">
        <div class="owl-carousel owl-theme" id="header-carousel">

            <!-- Slide 1 -->
            <div class="item position-relative" style="max-height: 50rem;">
                <img class="img-fluid w-100" src="img/proganadero/galleria/12.jpg" alt="Image">

                <!-- Overlay oscuro -->
                <div class="position-absolute top-0 start-0 w-100 h-100"
                    style="background: rgba(0,0,0,0.55); z-index: 1;"></div>

                <!-- Contenido -->
                <div class="carousel-caption position-absolute top-50 start-0 translate-middle-y w-100"
                    style="z-index: 2;">
                    <div class="container">
                        <div class="row justify-content-start">
                            <div class="col-lg-8 text-start">
                                <p class="fs-4 text-white">
                                    <img src="img/proganadero/logo/blanco.png" alt="logo" width="500px">
                                </p>
                                <h1 class="display-1 text-white mb-5 animate__animated animate__slideInRight gobold"
                                    style="margin-left: 3rem;">
                                    Ganadería en la palma de tu mano
                                </h1>
                                <h5 class="fs-4 fw-light text-white mb-4 gobold-lowplus animate__animated animate__fadeIn"
                                    style="margin-left: 3rem;">
                                    PROGANADERO te permite llevar el control de tu producción de carne.
                                </h5>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Slide 2 -->
            <div class="item position-relative" style="max-height: 50rem;">
                <img class="img-fluid w-100" src="img/proganadero/galleria/6.jpg" alt="Image">

                <!-- Overlay oscuro -->
                <div class="position-absolute top-0 start-0 w-100 h-100"
                    style="background: rgba(0,0,0,0.55); z-index: 1;"></div>

                <!-- Contenido -->
                <div class="carousel-caption position-absolute top-50 end-0 translate-middle-y w-100"
                    style="z-index: 2;">
                    <div class="container">
                        <div class="row justify-content-end">
                            <div class="col-lg-8 text-end">
                                <p class="fs-4 text-white">
                                    <img src="img/proganadero/logo/blanco.png" alt="logo" width="500px">
                                </p>
                                <h1 class="display-1 text-white mb-5 animate__animated animate__slideInRight gobold"
                                    style="margin-right: 2rem;">
                                    Tu campo, tus números, todo en un solo lugar
                                </h1>
                                <h5 class="fs-4 fw-light text-white mb-4 gobold-lowplus animate__animated animate__fadeIn"
                                    style="margin-right: 2.5rem;">
                                    Hecha en el campo, para el campo.
                                </h5>
                                <a href="#" class="btn btn-dark py-md-3 px-md-5 me-3">
                                    <i class="fa fa-search me-2"></i> Ver Como Funciona
                                </a>
                                <a href="#" class="btn btn-dark py-md-3 px-md-5 me-3">
                                    <i class="fa fa-phone-alt me-2"></i> Solicitar Demo
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

        </div>
    </div>
    <!-- Carousel End -->

    <!-- About Start -->
    <div class="container-xxl py-5 gobold-light" id="about">
        <div class="container">
            <div class="row g-5 align-items-end">
                <div class="col-lg-6">
                    <div class="row g-2">
                        <div class="col-6 position-relative wow fadeIn" data-wow-delay="0.7s">
                            <div class="about-experience bg-secondary rounded">
                                <h1 class="display-1 mb-0">25</h1>
                                <small class="fs-5 fw-bold">Años de Experiencia</small>
                            </div>
                        </div>
                        <div class="col-6 wow fadeIn" data-wow-delay="0.1s">
                            <img class="img-fluid rounded" src="img/proganadero/galleria/15.jpg">
                        </div>
                        <div class="col-6 wow fadeIn" data-wow-delay="0.3s">
                            <img class="img-fluid rounded" src="img/proganadero/galleria/24.jpg">
                        </div>
                        <div class="col-6 wow fadeIn" data-wow-delay="0.5s">
                            <img class="img-fluid rounded" src="img/proganadero/galleria/22.jpg">
                        </div>
                    </div>
                </div>
                <div class="col-lg-6 wow fadeIn" data-wow-delay="0.5s">
                    <p class="section-title bg-white text-start text-dark pe-3">Quienes Somos</p>
                    <h1 class="mb-4">Bienvenido a ProGanadero</h1>
                    <div class="row g-5 pt-2 mb-5">
                        <div class="col-sm-6">
                            <h5 class="mb-3">Visión</h5>
                            <span>Impulsar la transformación digital del productor ganadero, brindándole una herramienta
                                tecnológica que le permita generar, recopilar y analizar datos clave para mejorar su
                                producción, eficiencia y rentabilidad.</span>
                        </div>
                        <div class="col-sm-6">
                            <h5 class="mb-3">Misión</h5>
                            <span>Ayudar al productor ganadero a tener todo su campo organizado en una sola aplicación,
                                fácil de usar, hecha para el trabajo real. Con ejes en reproducción, nutrición, sanidad
                                y administración; nuestra herramienta permite tomar mejores decisiones, ahorrar tiempo y
                                hacer que el negocio sea más rentable.</span>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <!-- About End -->

    <!-- Features Start -->
    <div class="container-xxl py-5 gobold-light">
        <div class="container">
            <div class="row g-5 align-items-center">
                <div class="col-lg-6 wow fadeInUp" data-wow-delay="0.1s">
                    <p class="section-title bg-white text-start text-dark pe-3">Por qué nosotros!</p>
                    <h1 class="mb-4">¿Por qué elegir PROGANADERO?</h1>
                    <p class="mb-4">Más de 15 años de experiencia en asesoramiento, administración y producción en
                        sistemas de cría de ciclo completo. Identificando limitantes y oportunidades de mejora. Con la
                        firme convicción de buscar elevar los estándares productivos de la actividad ganadera con una
                        visión integral del sistema.</p>
                    <a class="btn btn-secondary rounded-pill py-3 px-5 mt-3" href="#">Ver Como Funciona</a>
                </div>
                <div class="col-lg-6">
                    <div class="row g-2">
                        <div class="col-6 wow fadeIn" data-wow-delay="0.1s">
                            <img class="img-fluid rounded" src="img/proganadero/galleria/21.jpg">
                        </div>
                        <div class="col-6 wow fadeIn" data-wow-delay="0.1s">
                            <img class="img-fluid rounded" src="img/proganadero/galleria/6.jpg">
                        </div>
                        <div class="col-6 wow fadeIn" data-wow-delay="0.3s">
                            <img class="img-fluid rounded" src="img/proganadero/galleria/8.jpg">
                        </div>
                        <div class="col-6 wow fadeIn" data-wow-delay="0.5s">
                            <img class="img-fluid rounded" src="img/proganadero/galleria/12.jpg">
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <!-- Features End -->

    <!-- Copyright Start -->
    <div class="container-fluid bg-dark text-body copyright py-4 gobold-light">
        <div class="container">
            <div class="row">
                <div class="col-md-6 text-center text-md-start mb-3 mb-md-0 text-white">
                    &copy; <a class="fw-semi-bold" href="#">ProGanadero</a>, All Right Reserved.
                </div>
                <div class="col-md-6 text-center text-md-end text-white">
                    Designed By <a class="fw-semi-bold" href="https://itoeste.com/">It Oeste</a>
                </div>
            </div>
        </div>
    </div>
    <!-- Copyright End -->

    <!-- JavaScript Libraries -->

    <script src="{{ asset('libs/jquery/jquery.min.js') }}"></script>
    <script src="{{ asset('libs/bootstrap/bootstrap.bundle.min.js') }}"></script>

    @include('layouts.partials.libs.sweetalert')
    <script src="libs/owlcarousel/owl.carousel.min.js"></script>

    <script>
        const $spinner = $("#spinner");

        // Mostrar spinner inmediatamente
        $spinner.addClass("show").fadeIn(300);

        // Ocultar después de 2 segundos con efecto suave
        setTimeout(() => {
            $spinner.fadeOut(500, function() {
                $spinner.removeClass("show");
            });
        }, 2000); // 2000ms = 2 segundos
    </script>

    <!-- Template Javascript -->
    @include('layouts.partials.scripts.welcome')

</body>

</html>
