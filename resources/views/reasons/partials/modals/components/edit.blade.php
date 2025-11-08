<div class="modal-header bg-dark text-white">
    <h1 class="modal-title fs-5" id="editModalReasonLabel">Actualizar Ración</h1>
    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
</div>
<form action="#" method="POST" enctype="multipart/form-data" id="edit_reason_form">
    @csrf
    @method('PUT')
    <div class="modal-body">
        <div class="col-12 mt-3">
            <div class="row">
                <div class="col-md-6 mb-4">
                    <label class="form__label">Rodeo</label>
                    <select class="form__input form-control" id="select_ajax_rodeo" name="edit_rodeo_id">
                        <option value="" selected disabled>Seleccione un rodeo</option>
                        @foreach ($rodeos as $rodeo)
                            <option value="{{ $rodeo->id }}" {{ $rodeo->id == $data->rodeo_id ? 'selected' : '' }}>
                                {{ $rodeo->name }}</option>
                        @endforeach
                    </select>
                </div>

                <div class="col-md-6 mb-4">
                    <label class="form__label">Alimentación</label>
                    <select class="form__input form-control food" name="edit_food_id">
                        <option value="null" selected>Elegir una Alimentación</option>
                        @foreach ($foods as $food)
                            <option value="{{ $food->id }}" {{ $food->id == $data->rearing_finishing_bases_id ? 'selected' : '' }}>
                                {{ $food->detail }}</option>
                        @endforeach
                    </select>
                </div>

                <div class="col-md-6 mb-4">
                    <label class="form__label">Detalle</label>
                    <textarea class="form__input form-control required" name="edit_detail" cols="30" rows="3">{{ $data->detail }}</textarea>
                </div>

                <div class="col-md-6 mb-4">
                    <label class="form__label">Porción</label>
                    <input class="form__input form-control required" type="number" name="edit_reason_value" value="{{ $data->reason_value }}"/>
                </div>

            </div>
        </div>
    </div>
    <div class="modal-footer bg-secondary">
        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
        <a href="javascript:void(0)" class="btn btn-primary" id="update_reason_btn">Actualizar Ración</a>
    </div>
</form>
