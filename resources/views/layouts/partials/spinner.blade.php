<!-- Spinner Start -->
<div id="spinner"
    class="bg-white position-fixed translate-middle w-100 vh-100 top-50 start-50 d-flex align-items-center justify-content-center show">
    <img src="{{ asset('img/proganadero/logo/negro.png') }}" alt="Cargando..." class="loader-img" />
</div>
<!-- Spinner End -->

<style>
    #spinner {
        z-index: 99999;
        opacity: 1;
        visibility: visible;
        transition: opacity 0.5s ease-out, visibility 0s linear 0.5s;
    }

    #spinner.hide {
        opacity: 0;
        visibility: hidden;
    }

    .loader-img {
        width: 400px;
        animation: scale 1.5s infinite ease-in-out;
    }

    @keyframes scale {
        0%, 100% {
            transform: scale(1);
        }
        50% {
            transform: scale(1.2);
        }
    }
</style>

<script>
    // Cuando todo (incluidas imágenes) haya cargado
    window.onload = function () {
        const spinner = document.getElementById("spinner");
        spinner.classList.add("hide");
    };
</script>
