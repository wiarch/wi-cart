<div class="modal-header bg-dark text-white">
    <h1 class="modal-title fs-5" id="editRowModalFieldLabel">Actualizar Campo</h1>
    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
</div>
<form action="#" method="POST" enctype="multipart/form-data" id="edit_field_form">
    @csrf
    @method('PUT')
    <div class="modal-body">
        <div class="col-12 mt-3">
            <div class="row">
                <div class="col-md-12 mt-4">
                    <input class="form__input form-control input-campo required" type="text" name="edit_name"
                        placeholder="Nombre del Campo" value="{{ $data->name }}" />
                </div>

                <div class="col-md-12 mt-4">
                    <a href="#" class="text-primary text-decoration-none small d-block mb-1 btn-geolocalizar"
                        data-input-location-id="location" data-input-coordinate-id="coordinate">
                        Geolocalización (opcional)
                    </a>
                    <div class="input-group">
                        <input id="location" class="form__input form-control input-location label_none" type="text"
                            name="edit_location" placeholder="Ubicación del Campo" value="{{ $data->location }}" />
                    </div>
                    <input type="hidden" name="edit_coordinate" id="coordinate" value="{{ $data->coordinate }}" />
                </div>
            </div>
        </div>
    </div>
    <div class="modal-footer bg-secondary">
        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
        <a href="javascript:void(0)" class="btn btn-primary" id="update_field_btn">Actualizar Campo</a>
    </div>
</form>
