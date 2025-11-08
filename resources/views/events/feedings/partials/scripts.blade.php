@include('layouts.partials.libs.select2')

<script>
    $(function() {

        // Inicializa la tabla principal de Feedings
        datatableData('table_feedings', false, '#table_feedings', null);

        /**
         * Inicializa el filtro de Rodeo
         */
        dinamicSelect(
            '#select_rodeo_filter', // Selector del <select>
            'Seleccione un rodeo', // Placeholder
            'getRodeos', // Ruta AJAX para obtener rodeos
            @json(session('user')->id), // Parámetro de ruta (ID usuario)
            0, null, false, null, // Otros parámetros (id, data, disabled, modal)
            function(selectedRodeo) { // Callback al seleccionar un rodeo
                const selectedRodeoId = selectedRodeo.id;

                // Actualiza la datatable con el rodeo seleccionado
                datatableData('table_feedings', false, '#table_feedings', {
                    rodeo: selectedRodeoId
                });

                // Inicializa el filtro de Stocks según el rodeo seleccionado
                dinamicSelect(
                    '#select_stocks_filter',
                    'Seleccione un stock',
                    'getStocks',
                    selectedRodeoId, // Parámetro: ID del rodeo
                    0, null, false, null,
                    function(selectedStock) { // Callback al seleccionar un stock
                        const selectedStockId = selectedStock.id;

                        // Actualiza la datatable con rodeo + stock
                        datatableData('table_feedings', false, '#table_feedings', {
                            rodeo: selectedRodeoId,
                            stock: selectedStockId
                        });
                    }
                );
            }
        );

        /**
         * Botón "Mostrar todos" para resetear filtros
         */
        $('.show-all').on('click', function() {
            // Resetea datatable sin filtros
            datatableData('table_feedings', false, '#table_feedings', null);

            // Opcional: resetear selects si lo deseas
            resetSelect('#select_rodeo_filter');
            resetSelect('#select_stocks_filter', 'Seleccione un rodeo primero', true, true);
        });

        /**
         * Botón "Agregar Feeding" para abrir modal y seleccionar Rodeo + Stock
         */
        $('.add-feeding').click(function() {
            // Resetear formulario del modal
            resetDynamicModalForm('#createModalFeeding', '#feeding_form');

            // Selección de Rodeo
            dinamicSelect(
                '#select_ajax_rodeo',
                'Seleccione un rodeo',
                'getRodeos',
                @json(session('user')->id),
                0, null, false, null,
                function(selectedRodeo) {
                    const selectedRodeoId = selectedRodeo.id;

                    // Selección de Stock basado en el Rodeo seleccionado
                    dinamicSelect(
                        '#select_ajax_stocks',
                        'Seleccione un stock',
                        'getStocks',
                        selectedRodeoId,
                        0, null, false, null,
                        function(selectedStock) {
                            const selectedStockId = selectedStock.id;
                            // Aquí puedes usar selectedStockId para asignar valores en el modal
                        }
                    );
                }
            );
        });

    });
</script>
