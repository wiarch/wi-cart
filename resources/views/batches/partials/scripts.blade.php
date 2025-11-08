<script>
    $(function() {

        datatableData('table_batches', false, '#table_batches', null);

        // === FUNCIONES ===

        let batchCount = 0;

        function addBatch() {
            batchCount++;

            const batchHTML = `
            <div class="col-12 mt-3" id="batch_${batchCount}">
                <div class="row">
                    <div class="col-md-6 mt-4">
                        <input class="form__input form-control input-campo required" type="text" name="batch[]"
                            placeholder="Nombre del Lote #${batchCount}" />
                    </div>
                
                    <div class="col-md-6 mt-4">
                        <input class="form__input form-control" type="text" name="surface[]" placeholder="Superficie #${batchCount}" />
                    </div>
                </div>
            </div>`;

            $("#batch_container").append(batchHTML);
            convertPlaceholdersToFloatingLabels('#batch_' + batchCount);

        }

        function removeBatch() {
            if (batchCount > 1) {
                const $input = $(`#batch_${batchCount} input`);
                const nombre = $input.val().trim();

                $(`#batch_${batchCount}`).remove();

                batchCount--;
            }
        }

        // === INICIAL ===
        // Registrar eventos al abrir el modal
        $('#addRowModalBatch').on('show.bs.modal', function() {
            // Reiniciar contenedor de inputs
            $('#batch_container').empty();

            // Reiniciar contador
            batchCount = 0;

            // Agregar uno o más lotes al abrir el modal
            for (let i = 0; i < 1; i++) {
                addBatch();
            }
        });

        window.addBatch = addBatch;
        window.removeBatch = removeBatch;



        const $selectField = $('.select_field');
        const $showAllBtn = $('.show-all');
        const $addBatchBtn = $('.add-batch');

        $selectField.on('change', function() {
            const fieldId = $(this).val();

            $('#field_select').val(fieldId);

            const data = {
                field: $selectField.val(),
            };

            if (fieldId !== '0') {
                datatableData('table_batches', false, '#table_batches', data);

                $addBatchBtn.removeClass('d-none');
                $showAllBtn.removeClass('d-none');
            } else {
                datatableData('table_batches', false, '#table_batches', null);
                $addBatchBtn.addClass('d-none');
                $showAllBtn.addClass('d-none');
            }
        });

        $showAllBtn.on('click', function() {
            $selectField.val('0').trigger('change.select2');
            datatableData('table_batches', false, '#table_batches', null);
            $addBatchBtn.addClass('d-none');
            $showAllBtn.addClass('d-none');
        });
    });
</script>
