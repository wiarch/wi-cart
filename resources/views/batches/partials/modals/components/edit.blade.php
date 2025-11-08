<div class="modal-header bg-dark text-white">
    <h1 class="modal-title fs-5" id="editRowModalBatchLabel">Actualizar Lote</h1>
    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
</div>
<form action="#" method="POST" enctype="multipart/form-data" id="edit_batch_form">
    @csrf
    @method('PUT')
    <div class="modal-body">
        <div class="col-12 mt-3">

            <div class="row">

                <div class="col-md-12 mb-4">
                    <label class="form__label">Campo</label>
                    <select class="form__input form-control select_field" name="field">
                        <option value="0" disabled selected>Elegir un Campo</option>
                        @foreach ($fields as $field)
                            <option value="{{ $field->id }}" {{ $field->id == $data->field_id ? 'selected' : '' }}>
                                {{ $field->name }}</option>
                        @endforeach
                    </select>
                </div>

                <div class="col-md-12 mt-4">
                    <input class="form__input form-control input-lote required" type="text" name="edit_batch"
                        placeholder="Nombre del Lote" value="{{ $data->name }}" />
                </div>

                <div class="col-md-12 mt-4">
                    <input class="form__input form-control" type="text" name="edit_surface" placeholder="Superficie"
                        value="{{ $data->surface }}" />
                </div>

            </div>
        </div>
    </div>
    <div class="modal-footer bg-secondary">
        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
        <a href="javascript:void(0)" class="btn btn-primary" id="update_batch_btn">Actualizar Lote</a>
    </div>
</form>
