<div class="modal-header bg-dark text-white">
    <h1 class="modal-title fs-5" id="editRowModalGrazingLabel">Actualizar Pastoreo</h1>
    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
</div>
<form action="#" method="POST" enctype="multipart/form-data" id="edit_grazing_form">
    @csrf
    @method('PUT')
    <div class="modal-body">
        <div class="col-12 mt-3">

            <div class="row">

                <div class="col-md-12 mb-4">
                    <label class="form__label">Tipo de Pastoreo</label>
                    <select class="form__input form-control" name="grazing_id">
                        <option value="" selected disabled>Seleccione una categoría</option>
                        @foreach ($type_grazings as $type_grazing)
                            <option value="{{ $type_grazing->id }}"
                                {{ $data->grazing_id == $type_grazing->id ? 'selected' : '' }}>
                                {{ $type_grazing->name }}</option>
                        @endforeach
                    </select>
                </div>

                <div class="col-md-6 mb-4">
                    <label class="form__label">Fecha de Entrada</label>
                    <input class="form__input form-control required" type="date" name="input_date"
                        value="{{ date('Y-m-d', strtotime($data->input_date)) }}" />
                </div>

                <div class="col-md-6 mb-4">
                    <label class="form__label">Fecha de Salida</label>
                    <input class="form__input form-control required" type="date" name="output_date"
                        value="{{ date('Y-m-d', strtotime($data->output_date)) }}" />
                </div>

            </div>
        </div>
    </div>
    <div class="modal-footer bg-secondary">
        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
        <a href="javascript:void(0)" class="btn btn-primary" id="update_grazing_btn">Actualizar Pastoreo</a>
    </div>
</form>
