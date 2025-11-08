<style>
    /********** Template CSS **********/
    :root {
        --primary: #171718;
        --secondary: #f5f6fa;
        --light: #f5f6fa;
        --dark: #1f2124;
        text-align: justify !important;
    }

    .back-to-top {
        position: fixed;
        display: none;
        right: 30px;
        bottom: 30px;
        z-index: 99;
    }

    .fw-bold {
        font-weight: 700 !important;
    }

    .fw-medium {
        font-weight: 600 !important;
    }

    .fw-semi-bold {
        font-weight: 500 !important;
    }

    /*** Button ***/
    .btn {
        transition: 0.5s;
        font-weight: 500;
    }

    .btn-primary,
    .btn-outline-primary:hover {
        color: var(--light);
    }

    .btn-secondary,
    .btn-outline-secondary:hover {
        color: var(--dark);
    }

    .btn-square {
        width: 38px;
        height: 38px;
    }

    .btn-sm-square {
        width: 32px;
        height: 32px;
    }

    .btn-lg-square {
        width: 48px;
        height: 48px;
    }

    .btn-square,
    .btn-sm-square,
    .btn-lg-square {
        padding: 0;
        display: flex;
        align-items: center;
        justify-content: center;
        font-weight: normal;
    }

    /*** Navbar ***/
    .navbar.sticky-top {
        top: -100px;
        transition: 0.5s;
    }

    .navbar .navbar-nav .nav-link {
        margin-right: 35px;
        padding: 25px 0;
        color: var(--dark);
        font-size: 18px;
        font-weight: 500;
        outline: none;
    }

    .navbar .navbar-nav .nav-link:hover,
    .navbar .navbar-nav .nav-link.active {
        color: var(--primary);
    }

    .navbar .dropdown-toggle::after {
        border: none;
        content: "\f107";
        font-family: "Font Awesome 5 Free";
        font-weight: 900;
        vertical-align: middle;
        margin-left: 8px;
    }

    @media (max-width: 991.98px) {
        .navbar .navbar-nav .nav-link {
            margin-right: 0;
            padding: 10px 0;
        }

        .navbar .navbar-nav {
            border-top: 1px solid #eeeeee;
        }
    }

    @media (min-width: 992px) {
        .navbar .nav-item .dropdown-menu {
            display: block;
            border: none;
            margin-top: 0;
            top: 150%;
            opacity: 0;
            visibility: hidden;
            transition: 0.5s;
        }

        .navbar .nav-item:hover .dropdown-menu {
            top: 100%;
            visibility: visible;
            transition: 0.5s;
            opacity: 1;
        }
    }

    /*** Header ***/
    .carousel-caption {
        width: 100rem !important;
        height: 100rem !important;
        display: flex;
        align-items: center;
        z-index: 1;
    }

    .carousel-control-prev,
    .carousel-control-next {
        width: 15%;
    }

    .carousel-control-prev-icon,
    .carousel-control-next-icon {
        width: 3rem;
        height: 3rem;
        border-radius: 3rem;
        background-color: var(--primary);
        border: 10px solid var(--primary);
    }

    @media (max-width: 768px) {
        #header-carousel .carousel-item {
            position: relative;
            min-height: 450px;
        }

        #header-carousel .carousel-item img {
            position: absolute;
            width: 100%;
            height: 100%;
            object-fit: cover;
        }
    }

    .page-header {
        background: url(../img/banner.jpg) center center no-repeat;
        background-size: cover;
    }

    .page-header .breadcrumb-item+.breadcrumb-item::before {
        color: var(--light);
    }

    .page-header .breadcrumb-item,
    .page-header .breadcrumb-item a {
        font-size: 18px;
        color: var(--light);
    }

    /*** Section Title ***/
    .section-title {
        position: relative;
        display: inline-block;
        text-transform: uppercase;
        font-weight: 600;
    }

    .section-title::before {
        position: absolute;
        content: "";
        width: calc(100% + 80px);
        height: 2px;
        top: 5px;
        left: -40px;
        background: var(--primary);
        z-index: -1;
    }

    .section-title::after {
        position: absolute;
        content: "";
        width: calc(100% + 120px);
        height: 2px;
        bottom: 6px;
        left: -60px;
        background: var(--primary);
        z-index: -1;
    }

    .section-title.text-start::before {
        width: calc(100% + 40px);
        left: 0;
    }

    .section-title.text-start::after {
        width: calc(100% + 60px);
        left: 0;
    }

    /*** About ***/
    .about-experience {
        position: absolute;
        width: 100%;
        height: 100%;
        right: -45px;
        bottom: -45px;
        display: flex;
        flex-direction: column;
        align-items: center;
        justify-content: center;
    }

    /*** Footer ***/
    .footer {
        color: #9fa3a9;
    }

    .footer .btn.btn-link {
        display: block;
        margin-bottom: 5px;
        padding: 0;
        text-align: left;
        color: #9fa3a9;
        font-weight: normal;
        text-transform: capitalize;
        transition: 0.3s;
    }

    .footer .btn.btn-link::before {
        position: relative;
        content: "\f105";
        font-family: "Font Awesome 5 Free";
        font-weight: 900;
        margin-right: 10px;
    }

    .footer .btn.btn-link:hover {
        color: var(--light);
        letter-spacing: 1px;
        box-shadow: none;
    }

    .carousel-overlay {
        position: absolute;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        background: rgba(0, 0, 0, 0.55);
        z-index: 1;
    }
</style>
