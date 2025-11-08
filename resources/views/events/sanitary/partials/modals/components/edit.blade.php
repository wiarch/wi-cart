<div class="modal-header bg-dark text-white">
    <h1 class="modal-title fs-5" id="editModalSanitaryLabel">Actualizar Evento</h1>
    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
</div>
<form action="#" method="POST" enctype="multipart/form-data" id="edit_sanitary_form">
    @csrf
    @method('PUT')
    <div class="modal-body">
        <div class="col-12 mt-3">
            <div class="row">
                <input type="hidden" name="type" value="2">

                <div class="col-md-4 mb-4">
                    <label class="form__label">Categoría</label>
                    <select class="form__input form-control" name="type_animal_id">
                        <option value="" selected disabled>Seleccione una categoría</option>
                        @foreach ($type_animals as $animal_type)
                            <option value="{{ $animal_type->id }}"
                                {{ $animal_type->id == $data->type_animal_id ? 'selected' : '' }}>
                                {{ $animal_type->name }}</option>
                        @endforeach
                    </select>
                </div>

                <div class="col-md-4 mb-4">
                    <label class="form__label">Cod. tratamiento</label>
                    <select class="form__input form-control" name="treatment_code_id">
                        <option value="" selected disabled>Seleccione un codigo</option>
                        @foreach ($treatment_codes as $treatment_code)
                            <option value="{{ $treatment_code->id }}"
                                {{ $treatment_code->id == $data->treatment_code_id ? 'selected' : '' }}>
                                {{ $treatment_code->name }}</option>
                        @endforeach
                    </select>
                </div>


                <div class="col-md-4 mb-4">
                    <label class="form__label">Fecha</label>
                    <input class="form__input form-control required" type="date" name="date"
                        value="{{ date('Y-m-d', strtotime($data->date)) }}" />
                </div>

                <div class="col-md-4 mb-4">
                    <label class="form__label">Dosis</label>
                    <input class="form__input form-control required" type="number" name="dose"
                        value="{{ $data->dose }}" />
                </div>

                <div class="col-md-4 mb-4 collective">
                    <label class="form__label">N° de serie</label>
                    <input class="form__input form-control required" type="number" name="serial_number"
                        value="{{ $data->serial_number }}" />
                </div>

                <div class="col-md-4 mb-4 collective">
                    <label class="form__label">Vencimiento</label>
                    <input class="form__input form-control required" type="date" name="date_expiration"
                        value="{{ date('Y-m-d', strtotime($data->date_expiration)) }}" />
                </div>

                <div class="col-md-6 mb-4 collective">
                    <label class="form__label">Marca</label>
                    <input class="form__input form-control required" type="text" name="mark"
                        value="{{ $data->mark }}" />
                </div>

                <div class="col-md-6 mb-4">
                    <label class="form__label">Retiro</label>
                    <input class="form__input form-control required" type="text" name="retirement"
                        value="{{ $data->retirement }}" />
                </div>

                <div class="col-md-6">
                    <label class="form__label">Diagnóstico</label>
                    <textarea class="form__input form-control required" name="diagnostic" cols="30" rows="3">{{ $data->diagnostic }}</textarea>
                </div>

                <div class="col-md-6">
                    <label class="form__label">Observacion</label>
                    <textarea class="form__input form-control required" name="observation" cols="30" rows="3">{{ $data->observation }}</textarea>
                </div>

            </div>
        </div>
    </div>
    <div class="modal-footer bg-secondary">
        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
        <a href="javascript:void(0)" class="btn btn-primary" id="update_sanitary_btn">Actualizar Evento</a>
    </div>
</form>
