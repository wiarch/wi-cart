@include('layouts.partials.libs.select2')

<script>
    $(function() {

        // Inicializa la tabla principal de Reasons
        datatableData('table_reasons', false, '#table_reasons', null);

        /**
         * Botón "Agregar Reason" para abrir modal y seleccionar Rodeo + Stock
         */
        $('.add-reason').click(function() {
            // Resetear formulario del modal
            resetDynamicModalForm('#createModalReason', '#reason_form');

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
