@include('layouts.partials.libs.select2')

<script>
    $(function() {

        // Inicializa la tabla principal de Sanitary
        datatableData('table_sanitary', false, '#table_sanitary', null);

        /**
         * Filtro de tipo sanitario
         */
        $('.select_type_sanitary').on('change', function() {
            const typeSanitary = $(this).val();

            // Actualiza la tabla según el tipo de sanitario
            datatableData('table_sanitary', false, '#table_sanitary', {
                type_sanitary: typeSanitary
            });

            // Inicializa el filtro de Rodeo
            dinamicSelect(
                '#select_rodeo_filter',
                'Seleccione un rodeo',
                'getRodeos',
                @json(session('user')->id),
                0, null, false, null,
                function(selectedRodeo) {
                    const selectedRodeoId = selectedRodeo.id;

                    // Actualiza tabla según rodeo y tipo sanitario
                    datatableData('table_sanitary', false, '#table_sanitary', {
                        rodeo: selectedRodeoId,
                        type_sanitary: typeSanitary
                    });

                    // Filtro de Stocks según Rodeo
                    dinamicSelect(
                        '#select_stocks_filter',
                        'Seleccione un stock',
                        'getStocks',
                        selectedRodeoId,
                        0, null, false, null,
                        function(selectedStock) {
                            const selectedStockId = selectedStock.id;

                            datatableData('table_sanitary', false, '#table_sanitary', {
                                rodeo: selectedRodeoId,
                                stock: selectedStockId,
                                type_sanitary: typeSanitary
                            });
                        }
                    );
                }
            );
        });

        /**
         * Botón "Mostrar todos" para resetear filtros
         */
        $('.show-all').on('click', function() {
            datatableData('table_sanitary', false, '#table_sanitary', null);

            // Resetea selects
            resetSelect('#select_rodeo_filter');
            resetSelect('#select_stocks_filter', 'Seleccione un rodeo primero', true, true);
            $('.select_type_sanitary').val('');
        });

        /**
         * Mostrar/ocultar campos según tipo de registro
         */
        $('#select_type').on('change', function() {
            const isCollective = $(this).val() == 0;

            $('.collective').toggleClass('d-none', !isCollective);
            $('.individual').toggleClass('d-none', isCollective);
        });

        /**
         * Botón "Agregar Sanitary" para abrir modal y seleccionar Rodeo + Stock
         */
        $('.add-sanitary').click(function() {
            // Resetear formulario del modal
            resetDynamicModalForm('#createModalSanitary', '#sanitary_form');

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
                            // Aquí puedes usar selectedStockId si es necesario
                        }
                    );
                }
            );
        });

    });
</script>
