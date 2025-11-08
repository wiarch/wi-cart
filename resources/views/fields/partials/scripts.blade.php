@include('layouts.partials.libs.leaflet')

<script>
    $(function() {

        datatableData('table_fields', false, '#table_fields', null);

        // === FUNCIONES ===

        let fieldCount = 0;

        function addField() {
            fieldCount++;

            const fieldHTML = `
            <div class="col-12 mt-3" id="field_${fieldCount}">
                <div class="row">
                    <div class="col-md-6 mt-4">
                        <input class="form__input form-control input-campo required" type="text" name="field[]"
                            placeholder="Nombre del Campo #${fieldCount}" />
                    </div>
                
                    <div class="col-md-6">
                        <a href="#" class="text-primary text-decoration-none small d-block mb-1 btn-geolocalizar"
                            data-input-location-id="location_${fieldCount}" data-input-coordinate-id="coordinate_${fieldCount}">
                            Geolocalización (opcional)
                        </a>
                        <div class="input-group">
                            <input id="location_${fieldCount}" class="form__input form-control input-location label_none"
                                type="text" name="location[]" placeholder="Ubicación del Campo #${fieldCount}" />
                        </div>
                        <input type="hidden" name="coordinate[]" id="coordinate_${fieldCount}" value="0"/>
                    </div>
                </div>
            </div>`;

            $("#field_container").append(fieldHTML);
            convertPlaceholdersToFloatingLabels('#field_' + fieldCount);

        }

        function removeField() {
            if (fieldCount > 1) {
                const $input = $(`#field_${fieldCount} input`);
                const nombre = $input.val().trim();

                $(`#field_${fieldCount}`).remove();

                fieldCount--;
            }
        }

        // === INICIAL ===
        // Registrar eventos al abrir el modal
        $('#addRowModalField').on('show.bs.modal', function() {
            // Reiniciar contenedor de inputs
            $('#field_container').empty();

            // Reiniciar contador
            fieldCount = 0;

            // Agregar uno o más campos al abrir el modal
            for (let i = 0; i < 1; i++) {
                addField();
            }
        });

        window.addField = addField;
        window.removeField = removeField;

    });
</script>
