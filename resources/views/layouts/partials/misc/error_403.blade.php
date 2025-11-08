<style>
    /*==SCSS coded by rajeshdas.com==*/
    /*font import from google fonts*/
    @import url("https://fonts.googleapis.com/css?family=Montserrat:100,200,300,400,500,600,700,800,900|Nunito:200,300,400,600,700,800,900&display=swap");

    body {
        height: 100vh;
        background-image: radial-gradient(closest-side, #e2e2e2, #585858);
        text-align: center;
        color: #505050;
        font-family: "Helvetica Neue";
        font-size: 16px;
        line-height: 1.5;
        overflow: hidden;
        transition: all 0.5s ease;
    }

    h1,
    h2,
    h3,
    h4,
    h5,
    h6 {
        font-family: "Montserrat", sans-serif;
    }

    .page-wrap {
        padding: 30px 15px;
        text-align: center;
        display: flex;
        align-items: center;
    }

    .page-wrap .page-not-found {
        width: 400px;
        margin-left: auto;
        margin-right: auto;
        position: relative;
        margin-top: 50px;
        margin-bottom: 50px;
        text-align: center;
    }

    .page-wrap .page-not-found .img-key {
        margin-bottom: 0px;
    }

    .page-wrap .page-not-found h1.text-xl {
        color: #000;
        text-transform: uppercase;
        line-height: 50px;
        font-size: 160px;
        font-weight: 800;
        letter-spacing: -28px;
        text-shadow: -6px 4px 0px #fff;
        margin-left: -20px;
        margin-top: 50px;
        margin-bottom: 50px;
    }

    .page-wrap .page-not-found h1.text-xl span {
        transition: all 1s ease;
        display: inline-block;
        animation: pulse 5s infinite;
    }

    .page-wrap .page-not-found h4.text-md,
    .page-wrap .page-not-found h4.text-sm {
        letter-spacing: 0.38px;
        font-weight: 300;
        line-height: 20px;
        font-size: 14px;
        text-transform: none;
        color: rgba(0, 0, 0, 0.5);
        margin-bottom: 0px;
        width: 100%;
    }

    .page-wrap .page-not-found h4.text-md a,
    .page-wrap .page-not-found h4.text-sm a {
        color: #1177bd;
        text-decoration: underline;
        font-weight: 700;
    }

    .page-wrap .page-not-found h4.text-md a:hover,
    .page-wrap .page-not-found h4.text-md a:focus,
    .page-wrap .page-not-found h4.text-sm a:hover,
    .page-wrap .page-not-found h4.text-sm a:focus {
        text-decoration: none;
    }

    .page-wrap .page-not-found h4.text-md {
        font-size: 50px;
        font-weigth: 700;
        color: #1177bd;
        text-transform: none;
    }

    .page-wrap .page-not-found h4.text-sm-btm {
        top: auto;
        bottom: 40px;
    }

    @keyframes pulse {
        from {
            color: #000;
        }

        to {
            color: #f03030;
        }
    }

    @media (max-width: 768px) {
        .page-wrap .page-not-found h1.text-xl {
            font-size: 120px;
            letter-spacing: -20px;
            margin-bottom: 30px;
        }

        .page-wrap .page-not-found h4.text-sm {
            top: 10px;
        }

        .page-wrap .page-not-found h4.text-sm-btm {
            bottom: -60px;
        }

        .page-wrap .page-not-found h4.text-md {
            font-size: 30px;
        }
    }
</style>
<div class="page-wrap">
    <div class="page-not-found">
        <img src="{{ asset('img/proganadero/logo/negro.png') }}" class="logo" width="500" style="margin-left: -3rem">

        <img src="https://res.cloudinary.com/razeshzone/image/upload/v1588316204/house-key_yrqvxv.svg" class="img-key"
            alt="">
        <h1 class="text-xl">
            <span>4</span>
            <span>0</span>
            <span class="broken">3</span>
        </h1>
        <h2 class="text-md">¡Acceso denegado!</h2>
        <b class="text-sm text-sm-btm">No tienes acceso a esta área de la web. <br> Vuelva al <a
                href="{{ route('dashboard.home') }}">Panel Principal</a></b>
    </div>
</div>
