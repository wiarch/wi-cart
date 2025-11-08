<div class="modal-header bg-dark text-white">
    <h1 class="modal-title fs-5" id="editRowModalRodeoLabel">Actualizar Rodeo</h1>
    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
</div>
<form action="#" method="POST" enctype="multipart/form-data" id="edit_rodeo_form">
    @csrf
    @method('PUT')
    <div class="modal-body">
        <div class="col-12 mt-3">
            <div class="row">
                <div class="col-md-6 mt-4">
                    <input class="form__input form-control input-campo required" type="text" name="edit_rodeo"
                        placeholder="Nombre del Rodeo" value="{{ $data->name }}" />
                </div>

                <div class="col-md-6">
                    <label class="form__label">Campo</label>
                    <select class="form__input form-control edit_field_select" name="edit_field">
                        <option value="0" disabled selected>Elegir un Campo</option>
                        @foreach ($fields as $field)
                            <option value="{{ $field->id }}" {{ $field->id == $data->field_id ? 'selected' : '' }}>
                                {{ $field->name }}</option>
                        @endforeach
                    </select>
                </div>


                <div class="col-md-6">
                    <label class="form__label">Lote</label>
                    <select class="form__input form-control edit_batch_select" name="edit_batch">
                        <option value="0" selected>Elegir un Lote</option>
                        @foreach ($batches as $batch)
                            <option value="{{ $batch->id }}" {{ $batch->id == $data->batch_id ? 'selected' : '' }}>
                                {{ $batch->name }}</option>
                        @endforeach
                    </select>
                </div>

                <div class="col-md-6">
                    <label class="form__label">Región</label>
                    <select class="form__input form-control" name="edit_region">
                        <option value="0" disabled selected>Elegir una Región</option>
                        @foreach ($regions as $region)
                            <option value="{{ $region->id }}" {{ $region->id == $data->region_id ? 'selected' : '' }}>
                                {{ $region->name }}</option>
                        @endforeach
                    </select>
                </div>

                <div class="col-md-6 mt-4">
                    <label class="form__label">Servicio</label>
                    <select class="form__input form-control" name="edit_service">
                        <option value="0" disabled selected>Elegir un Servicio</option>
                        @foreach ($services as $service)
                            <option value="{{ $service->id }}"
                                {{ $service->id == $data->service_id ? 'selected' : '' }}>
                                {{ $service->name . ' - ' . $service->description }}
                            </option>
                        @endforeach
                    </select>
                </div>

                <div class="col-md-6 mt-4">
                    <label class="form__label">Raza</label>
                    <select class="form__input form-control" name="edit_animal_breed">
                        <option value="0" disabled selected>Elegir una Raza</option>
                        @foreach ($animalBreeds as $animalBreed)
                            <option value="{{ $animalBreed->id }}"
                                {{ $animalBreed->id == $data->animal_breed_id ? 'selected' : '' }}>
                                {{ $animalBreed->name }}</option>
                        @endforeach
                    </select>
                </div>
            </div>
        </div>
    </div>
    <div class="modal-footer bg-secondary">
        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
        <a href="javascript:void(0)" class="btn btn-primary" id="update_rodeo_btn">Actualizar Rodeo</a>
    </div>
</form>

<script>
    $('.edit_field_select').on('change', function() {
        const fieldId = $(this).val();

        dinamicSelect('.edit_batch_select', 'Seleccione un Lote', 'getbatches', fieldId, 0,
            null, null, '#editRowModalRodeo');

    });
</script>
