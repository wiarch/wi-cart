@include('layouts.partials.libs.select2')
<script>
    $(function() {

        datatableData('table_rodeos', false, '#table_rodeos', null);

        // === FUNCIONES ===

        let rodeoCount = 0;

        function addRodeo() {
            rodeoCount++;

            const rodeoHTML = `
            <div class="col-12 mt-3" id="rodeo_${rodeoCount}">
                <div class="row">
                    <div class="col-md-2 mt-4">
                        <input class="form__input form-control input-campo required" type="text" name="rodeo[]"
                            placeholder="Nombre del Rodeo #${rodeoCount}" />
                    </div>
                
                    <div class="col-md-2">
                        <label class="form__label">Campo</label>
                        <select class="form__input form-control fields_${rodeoCount}" name="field[]" data-id="${rodeoCount}">
                            <option value="null" selected>Elegir un Campo</option>
                            @foreach ($fields as $field)
                                <option value="{{ $field->id }}">{{ $field->name }}</option>
                            @endforeach
                        </select>
                    </div>

                    <div class="col-md-2">
                        <label class="form__label">Lote</label>
                        <select class="form__input form-control batches_${rodeoCount}" name="batch[]">
                            <option value="0" selected>Elegir un Lote</option>
                        </select>
                    </div>

                    <div class="col-md-2">
                        <label class="form__label">Región</label>
                        <select class="form__input form-control regions_${rodeoCount}" name="region[]">
                            <option value="null" selected>Elegir una Región</option>
                            @foreach ($regions as $region)
                                <option value="{{ $region->id }}">{{ $region->name }}</option>
                            @endforeach
                        </select>
                    </div>

                    <div class="col-md-2">
                        <label class="form__label">Servicio</label>
                        <select class="form__input form-control services_${rodeoCount}" name="service[]">
                            <option value="null" selected>Elegir un Servicio</option>
                            @foreach ($services as $service)
                                <option value="{{ $service->id }}">{{ $service->name . ' - ' . $service->description }}</option>
                            @endforeach
                        </select>
                    </div>

                    <div class="col-md-2">
                        <label class="form__label">Raza</label>
                        <select class="form__input form-control animalBreed_${rodeoCount}" name="animal_breed[]">
                            <option value="null" selected>Elegir una Raza</option>
                            @foreach ($animalBreeds as $animalBreed)
                                <option value="{{ $animalBreed->id }}">{{ $animalBreed->name }}</option>
                            @endforeach
                        </select>
                    </div>

                </div>
            </div>`;

            $("#rodeo_container").append(rodeoHTML);
            convertPlaceholdersToFloatingLabels('#rodeo_' + rodeoCount);

            $('.fields_' + rodeoCount).on('change', function() {
                const fieldId = $(this).val();
                const id = $(this).attr('data-id');

                dinamicSelect('.batches', 'Seleccione un Lote', 'getbatches', fieldId, id,
                    null, null, '#addRowModalRodeo');

            });

        }

        function removeRodeo() {
            if (rodeoCount > 1) {
                const $input = $(`#rodeo_${rodeoCount} input`);
                const nombre = $input.val().trim();

                $(`#rodeo_${rodeoCount}`).remove();

                rodeoCount--;
            }
        }

        // === INICIAL ===
        // Registrar eventos al abrir el modal
        $('#addRowModalRodeo').on('show.bs.modal', function() {
            // Reiniciar contenedor de inputs
            $('#rodeo_container').empty();

            // Reiniciar contador
            rodeoCount = 0;

            // Agregar uno o más campos al abrir el modal
            for (let i = 0; i < 1; i++) {
                addRodeo();
            }
        });

        window.addRodeo = addRodeo;
        window.removeRodeo = removeRodeo;

    });
</script>
