@include('layouts.partials.libs.select2')

<script>
    $(function() {

        // === ELEMENTOS DOM GLOBALES ===
        const spinner = document.getElementById("spinner");

        // Botones y selects
        const $selectField = $('.select_field');
        const $selectRodeo = $('.select_rodeo');
        const $showAllBtn = $('.show-all');
        const $addStockBtn = $('.add-stock');
        const $transferAllBtn = $('.transfer-all');
        const $transferSelected = $('.transfer-selected');
        const $exportTable = $('.export-table');

        // Contador de filas de stock
        let stockCount = 0;

        // Inicializa la tabla sin filtros
        datatableData('table_stocks', false, '#table_stocks', null);

        // ===============================
        // FUNCIONES DE AGREGAR / REMOVER STOCK
        // ===============================

        /**
         * Agrega una nueva fila de stock con IDV, EID y tipo de animal
         */
        function addStock() {
            stockCount++;

            const stockHTML = `
        <div class="col-12 mt-3" id="stock_${stockCount}">
            <div class="row align-items-end g-3">

                <!-- SELECT DE IDENTIFICADOR -->
                <div class="col-md-3" id="index_select_${stockCount}">
                    <label class="form__label">Identificador</label>
                    <select class="form__input form-control index_select" name="index[]" data-index="${stockCount}">
                        <option value="null" selected>Elegir un Identificador</option>
                        <option value="IDV (identificación visual)">IDV (identificación visual)</option>
                        <option value="EID (identificación electrónica)">EID (identificación electrónica)</option>
                        <option value="IDV (identificación visual) y EID (identificación electrónica)">Ambos</option>
                    </select>
                </div>

                <!-- INPUT IDV -->
                <div class="col-md-3 d-none idv_field" id="idv_field_${stockCount}">
                    <label class="form__label">N° de IDV</label>
                    <input class="form__input form-control" type="text" name="index_idv[]" placeholder="N° de IDV" />
                </div>

                <!-- INPUT EID -->
                <div class="col-md-3 d-none eid_field" id="eid_field_${stockCount}">
                    <label class="form__label">N° de EID</label>
                    <input class="form__input form-control" type="text" name="index_eid[]" placeholder="N° de EID" />
                </div>

                <!-- SELECT DE TIPO -->
                <div class="col-md-3 d-none type_field" id="type_field_${stockCount}">
                    <label class="form__label">Tipo</label>
                    <select class="form__input form-control type_animal_${stockCount}" name="type_animal[]">
                        <option value="null" selected>Elegir un Tipo</option>
                        @foreach ($type_animals as $type_animal)
                            <option value="{{ $type_animal->id }}">{{ $type_animal->name }}</option>
                        @endforeach
                    </select>
                </div>

            </div>
        </div>`;

            $("#stock_container").append(stockHTML);
        }

        /**
         * Elimina la última fila de stock si hay más de una
         */
        function removeStock() {
            if (stockCount > 1) {
                $(`#stock_${stockCount}`).remove();
                stockCount--;
            }
        }

        // Exponer funciones globalmente para botones u otros scripts
        window.addStock = addStock;
        window.removeStock = removeStock;

        // ===============================
        // CAMBIO DE IDENTIFICADOR (IDV / EID / Ambos)
        // ===============================
        $(document).on('change', '.index_select', function() {
            const index = $(this).data('index');
            const value = $(this).val();

            const $stock = $(`#index_select_${index}`);
            const $idv = $(`#idv_field_${index}`);
            const $eid = $(`#eid_field_${index}`);
            const $type = $(`#type_field_${index}`);

            // Reset clases y ocultar inputs
            $stock.removeClass('col-md-4 col-md-3');
            $idv.addClass('d-none').removeClass('col-md-4 col-md-3');
            $eid.addClass('d-none').removeClass('col-md-4 col-md-3');
            $type.addClass('d-none').removeClass('col-md-4 col-md-3');

            // Mostrar inputs según selección
            if (value.includes('IDV') && value.includes('EID')) {
                $stock.addClass('col-md-3');
                $idv.removeClass('d-none').addClass('col-md-3');
                $eid.removeClass('d-none').addClass('col-md-3');
                $type.removeClass('d-none').addClass('col-md-3');
            } else if (value.includes('IDV')) {
                $stock.addClass('col-md-4');
                $idv.removeClass('d-none').addClass('col-md-4');
                $type.removeClass('d-none').addClass('col-md-4');
            } else if (value.includes('EID')) {
                $stock.addClass('col-md-4');
                $eid.removeClass('d-none').addClass('col-md-4');
                $type.removeClass('d-none').addClass('col-md-4');
            }
        });

        // ===============================
        // INICIALIZACIÓN DEL MODAL
        // ===============================
        $('#addRowModalStock').on('show.bs.modal', function() {
            $('#stock_container').empty();
            stockCount = 0;
            addStock();
        });

        // ===============================
        // FUNCIONES DE FILTROS EN CASCADA (Campo → Rodeo)
        // ===============================
        function resetRodeoSelect(placeholder = 'Debe elegir un Campo') {
            dinamicSelect('.select_rodeo', placeholder, 'select2', null, 0, null, false);
            dinamicSelect('.select_batch', placeholder, 'select2', null, 0, null, false);
            $selectRodeo.prop('disabled', true).trigger('change.select2');
        }

        dinamicSelect(
            '.select_field',
            'Seleccione un Campo',
            'getFields',
            @json(session('user')->id),
            0, null, false, null,
            function(selectedField) {
                const fieldId = selectedField.id;

                // Actualiza tabla solo con campo
                datatableData('table_stocks', false, '#table_stocks', {
                    field: fieldId
                });

                // Mostrar botón "Ver Todos"
                $showAllBtn.removeClass('d-none');

                // Configura rodeo según campo
                dinamicSelect(
                    '.select_rodeo',
                    'Seleccione un Rodeo',
                    'getRodeos', {
                        id: fieldId,
                        batch: true
                    },
                    0, null, false, null,
                    function(selectedRodeo) {
                        const rodeoId = selectedRodeo.id;

                        // Actualiza tabla con campo + rodeo
                        datatableData('table_stocks', false, '#table_stocks', {
                            field: fieldId,
                            rodeo: rodeoId
                        });

                        // Mostrar botones de acciones
                        $addStockBtn.removeClass('d-none');
                        $transferAllBtn.removeClass('d-none');

                        // Actualiza export
                        const exportUrl =
                            `{{ route('stocks.export') }}?field=${fieldId}&rodeo=${rodeoId}`;
                        $exportTable.attr('href', exportUrl);

                        // Configura Transfer All
                        $transferAllBtn.attr('onclick', `formGetAjax(
                        '{{ route('stocks.transfer.all') }}',
                        '{{ route('stocks.move') }}',
                        '#transfer_stock_form',
                        '#transfer_stock_btn',
                        '#table_stocks',
                        '#transferRowModalStock',
                        ${JSON.stringify({ field: fieldId, rodeo: rodeoId })}
                    )`);
                    }
                );
            }
        );

        // ===============================
        // BOTÓN MOSTRAR TODOS
        // ===============================
        $showAllBtn.on('click', function() {
            $selectField.val('0').trigger('change.select2');
            resetRodeoSelect();
            $addStockBtn.addClass('d-none');
            $showAllBtn.addClass('d-none');
            $transferAllBtn.addClass('d-none');
            $('.transfer_all').val(false);
            datatableData('table_stocks', false, '#table_stocks', null);
        });

        // ===============================
        // TRANSFERIR SELECCIONADOS
        // ===============================
        $transferSelected.on('click', function() {
            const ids = $('.selected_stock_ids').val();
            const idsArray = ids ? ids.split(',') : [];

            formGetAjax(
                '{{ route('stocks.transfer') }}',
                '{{ route('stocks.move') }}',
                '#transfer_stock_form',
                '#transfer_stock_btn',
                '#table_stocks',
                '#transferRowModalStock', {
                    ids: idsArray
                }
            );
        });

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
                url: "{{ route('stocks.import') }}",
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
                        text: 'Por favor, espere mientras se cargan los stocks',
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
                    $('#table_stocks').DataTable().ajax.reload();
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
