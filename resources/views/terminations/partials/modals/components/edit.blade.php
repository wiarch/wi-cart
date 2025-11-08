<div class="modal-header bg-dark text-white">
    <h1 class="modal-title fs-5" id="editModalTerminationLabel">Actualizar Ración</h1>
    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
</div>
<form action="#" method="POST" enctype="multipart/form-data" id="edit_termination_form">
    @csrf
    @method('PUT')
    <div class="modal-body">
        <div class="col-12 mt-3">
            <div class="row">

                <div class="col-md-12 mb-4">
                    <label class="form__label">Nombre de alimentación</label>
                    <input class="form__input form-control required" type="text" name="edit_reason_name" value="{{ $data->reason_name }}" />
                </div>

                <div class="col-md-5 mb-4">
                    <label class="form__label">Tipo</label>
                    <select class="form__input form-control food" name="edit_type">
                        <option value="0" {{ $data->type == 0 ? 'selected' : '' }}>Recría</option>
                        <option value="1" {{ $data->type == 1 ? 'selected' : '' }}>Terminación</option>
                    </select>
                </div>

                <div class="col-md-4 mb-4">
                    <label class="form__label">Fecha</label>
                    <input class="form__input form-control required" type="date" name="edit_date"
                        value="{{ $data->date }}" />
                </div>

                <div class="col-md-3 mb-4">
                    <label class="form__label">CMS</label>
                    <input class="form__input form-control required" type="number" name="edit_cms" value="{{ $data->cms }}" />
                </div>

                <div class="col-md-3 mb-4">
                    <label class="form__label">PV</label>
                    <input class="form__input form-control required" type="number" name="edit_pv" value="{{ $data->pv }}" />
                </div>

                <div class="col-md-3 mb-4">
                    <label class="form__label">GPD en KG</label>
                    <input class="form__input form-control required" type="number" name="edit_gdp" value="{{ $data->gdp }}" />
                </div>

                <div class="col-md-3 mb-4">
                    <label class="form__label">Animales</label>
                    <input class="form__input form-control required" type="number" name="edit_animals" value="{{ $data->animals }}" />
                </div>

                <div class="col-md-3 mb-4">
                    <label class="form__label">Dias</label>
                    <input class="form__input form-control required" type="number" name="edit_days" value="{{ $data->days }}" />
                </div>


            </div>
        </div>
    </div>
    <div class="modal-footer bg-secondary">
        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
        <a href="javascript:void(0)" class="btn btn-primary" id="update_termination_btn">Actualizar Ración</a>
    </div>
</form>
