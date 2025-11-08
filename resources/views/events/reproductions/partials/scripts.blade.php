@include('layouts.partials.libs.select2')

<script>
    $(function() {

        // Inicializa la tabla principal
        datatableData('table_reproductions', false, '#table_reproductions', null);

        /**
         * FILTROS EN CASCADA (Campo → Rodeo → Stock)
         */
        dinamicSelect(
            '#select_field_filter',
            'Seleccione un campo',
            'getFields',
            @json(session('user')->id),
            0, null, false, null,
            function(selectedField) {
                const selectedFieldId = selectedField.id;

                // Actualiza tabla con el campo seleccionado
                datatableData('table_reproductions', false, '#table_reproductions', {
                    field: selectedFieldId
                });

                // Filtro de rodeos según el campo
                dinamicSelect(
                    '#select_rodeo_filter',
                    'Seleccione un rodeo',
                    'getRodeos',
                    selectedFieldId,
                    0, null, false, null,
                    function(selectedRodeo) {
                        const selectedRodeoId = selectedRodeo.id;

                        // Actualiza tabla con campo + rodeo
                        datatableData('table_reproductions', false, '#table_reproductions', {
                            field: selectedFieldId,
                            rodeo: selectedRodeoId
                        });

                        // Filtro de stocks según el rodeo
                        dinamicSelect(
                            '#select_stocks_filter',
                            'Seleccione un stock',
                            'getStocks',
                            selectedRodeoId,
                            0, null, false, null,
                            function(selectedStock) {
                                const selectedStockId = selectedStock.id;

                                // Actualiza tabla con campo + rodeo + stock
                                datatableData('table_reproductions', false,
                                    '#table_reproductions', {
                                        field: selectedFieldId,
                                        rodeo: selectedRodeoId,
                                        stock: selectedStockId
                                    });
                            }
                        );
                    }
                );
            }
        );

        /**
         * BOTÓN MOSTRAR TODO
         */
        $('.show-all').on('click', function() {
            datatableData('table_reproductions', false, '#table_reproductions', null);
            resetSelect('#select_field_filter');
            resetSelect('#select_rodeo_filter', 'Seleccione un campo primero', true, true);
            resetSelect('#select_stocks_filter', 'Seleccione un rodeo primero', true, true);
        });

        /**
         * SELECCIÓN EN MODAL (Agregar reproducción)
         */
        $('.add-reproduction').click(function() {
            resetDynamicModalForm('#createModalReproduction', '#reproduction_form');

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

        /**
         * CAMBIO DE TIPO DE REPRODUCCIÓN
         */
        $('#select_type').on('change', function() {
            const type = $(this).val();

            // Ocultar todas las secciones
            const sections = ['tacto', 'parto', 'pre-servicio', 'ecografia'];
            sections.forEach(cls => $('.' + cls).addClass('d-none'));

            // Reset del ancho
            $('.diagnostic_div').removeClass('col-md-6');

            // Configuración por tipo
            const config = {
                1: {
                    section: 'parto',
                    date: 'date_birth',
                    diagnostic: 'diagnostic_birth',
                    cc: null,
                    fullWidth: false
                },
                2: {
                    section: 'pre-servicio',
                    date: 'date_pre_service',
                    diagnostic: 'diagnostic_pre_service',
                    cc: 'cc_pre_service',
                    fullWidth: true
                },
                3: {
                    section: 'ecografia',
                    date: 'date_ecography',
                    diagnostic: 'diagnostic_ecography',
                    cc: 'cc_ecography',
                    fullWidth: true
                },
                4: {
                    section: 'tacto',
                    date: 'date_touch',
                    diagnostic: 'diagnostic_touch',
                    cc: 'cc_touch',
                    fullWidth: true
                }
            };

            if (config[type]) {
                const cfg = config[type];

                // Mostrar sección correspondiente
                $('.' + cfg.section).removeClass('d-none');

                // Cambiar atributos name
                $('.date').attr('name', cfg.date);
                $('.diagnostic').attr('name', cfg.diagnostic);

                if (cfg.cc) $('.cc').attr('name', cfg.cc);

                // Ajustar ancho
                if (cfg.fullWidth) {
                    $('.diagnostic_div').addClass('col-md-6').removeClass('col-md-12');
                }
            }
        });

        const $exportTable = $('.export-table');

        // ===============================
        // EXPORTAR CON SPINNER
        // ===============================
        $exportTable.on('click', function(e) {
            e.preventDefault();
            spinner.classList.add('show');

            const url = $(this).attr('href');
            const form = document.createElement('form');
            form.action = url;
            form.method = 'GET';
            form.style.display = 'none';
            document.body.appendChild(form);
            form.submit();

            // Oculta spinner tras 3s
            setTimeout(() => {
                spinner.classList.remove('show');
                document.body.removeChild(form);
            }, 3000);
        });

        // ===============================
        // IMPORTACIÓN DE STOCKS
        // ===============================
        $('.import-table-btn').on('click', function() {
            $('.import-table-input').click();
        });

        $('.import-table-input').on('change', function() {
            const formData = new FormData();
            formData.append('file', $(this)[0].files[0]);

            $.ajax({
                url: "{{ route('reproductions.import') }}",
                type: "POST",
                data: formData,
                contentType: false,
                processData: false,
                headers: {
                    'X-CSRF-TOKEN': '{{ csrf_token() }}'
                },
                beforeSend: function() {
                    Swal.fire({
                        title: 'Importando...',
                        text: 'Por favor, espere mientras se cargan los registros',
                        allowOutsideClick: false,
                        didOpen: () => Swal.showLoading()
                    });
                },
                success: function(response) {
                    Swal.close();
                    Swal.fire({
                        title: response.title,
                        text: response.text || '',
                        icon: 'success',
                        showConfirmButton: true,
                        confirmButtonText: 'Continuar',
                        confirmButtonColor: '#3085d6',
                    });
                    $('#table_reproductions').DataTable().ajax.reload();
                    $('.import-table-input').val('');
                },
                error: function(xhr) {
                    Swal.close();
                    Swal.fire({
                        title: xhr.responseJSON?.title || 'Error',
                        text: xhr.responseJSON?.error || 'Ocurrió un error',
                        icon: 'error'
                    });
                    $('.import-table-input').val('');
                }
            });
        });
    });
</script>
