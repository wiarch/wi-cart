<script>
    $(document).ready(function() {
        datatableData('table_veterinary_supplies', false, '#table_veterinary_supplies', null);

        // Select2 simple para código de tratamiento (crear)
        initTreatmentCode('#code_tratment_id', false, '#createModalVeterinarySupply');

        // Cuando se abre el modal de edición, inicializar y preseleccionar
        $('#editRowModalVeterinarySupply').on('shown.bs.modal', function() {
            initTreatmentCode('#code_tratment_id_edit', true, '#editRowModalVeterinarySupply');
        });

        function initTreatmentCode(selector, isEdit = false, modalSelector = null) {
            dinamicSelectAjax({
                selector: selector,
                url: "{{ route('ajax.select.treatment_codes') }}",
                placeholder: 'Seleccione un código de tratamiento',
                minLength: 0,
                mapResult: item => ({
                    id: item.id,
                    text: item.name
                }),
                dropdownParent: modalSelector
            });

            // Preseleccionar en edición (valor único)
            if (isEdit) {
                const id = $('#selected_code_id').val();
                setTimeout(() => {
                    $(selector).val(id).trigger('change');
                }, 400);
            }
        }
    });
</script>
