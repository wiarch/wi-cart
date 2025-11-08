{{-- Estilos y librería de Intro.js --}}
<link href="{{ asset('libs/intro/intro.min.css') }}" rel="stylesheet">
<link href="{{ asset('libs/intro/themes/introjs-modern.css') }}" rel="stylesheet">
<script src="{{ asset('libs/intro/intro.js') }}"></script>

<script>
    /**
     * Clave en localStorage para controlar si el tour ya se completó
     */
    const TOUR_KEY = "proganadero_intro_done";
    let tour; // variable global del tour

    /**
     * Reinicia el tour forzando borrar la clave en localStorage
     */
    function restartTour() {
        localStorage.removeItem(TOUR_KEY);
        tour.start();
    }

    $(window).on("load", function() {

        // Inicialización de Intro.js con configuración y pasos
        tour = introJs().setOptions({
            tooltipClass: "customIntroTheme", // Clase personalizada de tooltips
            highlightClass: "customIntroHighlight", // Clase de resalte de elementos
            overlayOpacity: 0.6, // Opacidad del overlay
            showProgress: true, // Barra de progreso
            showBullets: false, // Ocultar bullets
            exitOnOverlayClick: false, // No salir al hacer click en overlay
            nextLabel: "Siguiente →",
            prevLabel: "← Anterior",
            doneLabel: "¡Entendido!",
            steps: [{
                    intro: "Bienvenido a ProGanadero 👋. Desde aquí podrás gestionar toda la producción ganadera."
                },
                {
                    element: ".logo",
                    intro: "Este es el logo de la aplicación. Desde aquí siempre podés volver al inicio."
                },
                {
                    element: ".nav-home",
                    intro: "O desde aquí también podés volver al inicio."
                },
                {
                    element: "#li-panel",
                    intro: "O desde aquí también podés volver al inicio."
                },
                {
                    element: "#li-fields",
                    intro: "Listado de Campos"
                },
                {
                    element: "#li-batches",
                    intro: "Listado de lotes"
                },
                {
                    element: "#li-rodeos",
                    intro: "Listado de Rodeos"
                },
                {
                    element: "#li-stocks",
                    intro: "Listado de Stocks"
                },
                {
                    element: ".navbar-nav .profile-pic",
                    intro: "Accede a opciones como este Tutorial o Cerrar sesión."
                }
            ]
        });

        /**
         * Abrir automáticamente submenús antes de cambiar de paso
         * (para que los tooltips de elementos dentro de menús colapsados funcionen)
         */
        tour.onbeforechange(function(el) {
            const $li = $(el).closest("li.has-treeview");
            const $collapse = $li.find(".collapse");
            if ($li.length && $collapse.length && !$collapse.hasClass("show")) {
                $collapse.collapse('show'); // Bootstrap 5
                tour.refresh(); // actualizar la posición del tooltip
            }
        });

        /**
         * Inicializa el tour si no se ha completado previamente
         */
        function initTour() {
            if (!localStorage.getItem(TOUR_KEY)) {
                // Guardar como completado al finalizar o salir
                tour.oncomplete(() => localStorage.setItem(TOUR_KEY, "yes"));
                tour.onexit(() => localStorage.setItem(TOUR_KEY, "yes"));
                tour.start();
            }
        }

        // Espera 300ms para asegurar que todo el DOM esté cargado
        setTimeout(initTour, 300);
    });
</script>
