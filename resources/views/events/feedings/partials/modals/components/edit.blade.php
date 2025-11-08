<div class="modal-header bg-dark text-white">
    <h1 class="modal-title fs-5" id="editModalFeedingLabel">Actualizar Evento</h1>
    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
</div>
<form action="#" method="POST" enctype="multipart/form-data" id="edit_feeding_form">
    @csrf
    @method('PUT')
    <div class="modal-body">
        <div class="col-12 mt-3">
            <div class="row">
                <input type="hidden" name="type" value="4">

                {{-- <div class="col-md-12">
                    <label class="form__label">Rodeo</label>
                    <select class="form__input form-control" id="select_ajax_rodeo" name="rodeo_id">
                        <option value="{{ $data->rodeo_id }}" selected>{{ $data->rodeo_name }}</option>
                    </select>
                </div>

                <div class="col-md-12 my-4">
                    <label class="form__label">Stock</label>
                    <select class="form__input form-control" id="select_ajax_stocks" name="stock_id">
                        <option value="{{ $data->stock_id }}" selected>{{ $data->stock_name }}</option>
                    </select>
                </div> --}}

                <div class="col-md-6 mt-4">
                    <input class="form__input form-control required" type="number" name="weight"
                        value="{{ $data->weight }}" placeholder="Peso en KG" />
                </div>

                <div class="col-md-6">
                    <label class="form__label">Fecha</label>
                    <input class="form__input form-control required" type="date" name="date"
                        value="{{ $data->date }}" />
                </div>
            </div>
        </div>
    </div>
    <div class="modal-footer bg-secondary">
        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
        <a href="javascript:void(0)" class="btn btn-primary" id="update_feeding_btn">Actualizar Evento</a>
    </div>
</form>
