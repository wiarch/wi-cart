@include('layouts.partials.libs.select2')

<script>
    $(function() {

        // Inicializa la tabla principal de terminations
        datatableData('table_terminations', false, '#table_terminations', null);

        /**
         * Botón "Agregar Termination" para abrir modal y seleccionar Rodeo + Stock
         */
        $('.add-termination').click(function() {
            // Resetear formulario del modal
            resetDynamicModalForm('#createModalTermination', '#termination_form');

            // Selección de Rodeo
            dinamicSelect(
                '#select_ajax_rodeo',
                'Seleccione un rodeo',
                'getRodeos',
                @json(session('user')->id),
                0, null, false, null,
                function(selectedRodeo) {
                    const selectedRodeoId = selectedRodeo.id;

                }
            );
        });

    });
</script>
