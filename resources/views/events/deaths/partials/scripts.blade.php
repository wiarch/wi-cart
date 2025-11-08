@include('layouts.partials.libs.select2')

<script>
    $(function() {

        // Inicializa la tabla principal de Deaths
        datatableData('table_deaths', false, '#table_deaths', null);

        /**
         * Filtro tipo de muerte
         */
        $('.select_type_death_filter').on('change', function() {
            const typeDeath = $(this).val();

            // Actualiza la datatable según el tipo de muerte
            datatableData('table_deaths', false, '#table_deaths', {
                type_death: typeDeath
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

                    datatableData('table_deaths', false, '#table_deaths', {
                        rodeo: selectedRodeoId,
                        type_death: typeDeath
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

                            datatableData('table_deaths', false, '#table_deaths', {
                                rodeo: selectedRodeoId,
                                stock: selectedStockId,
                                type_death: typeDeath
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
            datatableData('table_deaths', false, '#table_deaths', null);
            resetSelect('#select_rodeo_filter');
            resetSelect('#select_stocks_filter', 'Seleccione un rodeo primero', true, true);
            $('.select_type_death_filter').val('');
        });

        /**
         * Mostrar/ocultar campos según tipo de muerte
         */
        $('.type_death').on('change', function() {
            const val = $(this).val();

            $('.diagnostic').toggleClass('d-none', val != 0);
            $('.date_sale, .guide_number, .observations').toggleClass('d-none', val == 0);
        });

        /**
         * Botón "Agregar Death" para abrir modal y seleccionar Rodeo + Stock
         */
        $('.add-death').click(function() {
            // Resetear formulario del modal
            resetDynamicModalForm('#createModalDeath', '#death_form');

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
