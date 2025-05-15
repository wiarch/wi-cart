<script src="{{ asset('template/vendors/js/vendor.bundle.base.js') }}"></script>
<script src="{{ asset('template/vendors/chart.js/Chart.min.js') }}"></script>
<script src="{{ asset('template/vendors/progressbar.js/progressbar.min.js') }}"></script>
<script src="{{ asset('template/vendors/jvectormap/jquery-jvectormap.min.js') }}"></script>
<script src="{{ asset('template/vendors/jvectormap/jquery-jvectormap-world-mill-en.js') }}"></script>
<script src="{{ asset('template/vendors/owl-carousel-2/owl.carousel.min.js') }}"></script>
<script src="{{ asset('template/js/off-canvas.js') }}"></script>
<script src="{{ asset('template/js/hoverable-collapse.js') }}"></script>
<script src="{{ asset('template/js/misc.js') }}"></script>
<script src="{{ asset('template/js/settings.js') }}"></script>
<script src="{{ asset('template/js/todolist.js') }}"></script>
<script src="{{ asset('template/js/dashboard.js') }}"></script>

<script src="{{ asset('assets/js/fab.js') }}"></script>


@yield('scripts')


{{-- script para formato de importe --}}
<script>
    const numeroInput = $('.input-import');

    numeroInput.on('input', function() {
        let valor = $(this).val();
        valor = valor.replace(/[^\d,]/g, '');

        // Eliminar comas adicionales
        valor = valor.replace(/(,.?),(.,)/g, '$1$2');

        // Separar parte entera y decimal
        let partes = valor.split(',');
        let parteEntera = partes[0];
        let parteDecimal = partes[1] || '';

        // Formatear parte entera con separador de miles
        parteEntera = parteEntera.replace(/\B(?=(\d{3})+(?!\d))/g, '.');

        // Limitar parte decimal a dos dígitos
        // if (parteDecimal.length > 2) {
        //     parteDecimal = parteDecimal.substring(0, 2);
        // }

        // Agregar ceros iniciales si es necesario
        // if (parteDecimal.length === 1) {
        //     parteDecimal += '0';
        // } else if (parteDecimal.length === 0 && valor.includes(',')) {
        //     parteDecimal = '00';
        // }

        // Unir parte entera y decimal
        // let numeroFormateado = parteEntera;
        // if (parteDecimal) {
        //     numeroFormateado += ',' + parteDecimal;
        // }

        // Actualizar valor del input
        $(this).val(parteEntera);
    });

    numeroInput.on('blur', function() {
        if (!$(this).val().includes(',')) {
            $(this).val($(this).val());
            // $(this).val($(this).val() + ',00');
        }
    });
</script>
<!-- END: Custom JS-->
