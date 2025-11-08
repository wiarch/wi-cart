<div class="modal-header bg-dark text-white">
    <h1 class="modal-title fs-5" id="editModalDeathLabel">Actualizar Evento</h1>
    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
</div>
<form action="#" method="POST" enctype="multipart/form-data" id="edit_death_form">
    @csrf
    @method('PUT')
    <div class="modal-body">
        <div class="col-12 mt-3">
            <div class="row">
                <input type="hidden" name="type" value="3">

                <div class="col-md-6 mb-4">
                    <label class="form__label">Tipo</label>
                    <select class="form__input form-control type_animal" name="type_animal_id">
                        <option value="null" selected>Elegir un Tipo</option>
                        @foreach ($type_animals as $type_animal)
                            <option value="{{ $type_animal->id }}"
                                {{ $data->type_animal_id === $type_animal->id ? 'selected' : '' }}>
                                {{ $type_animal->name }}</option>
                        @endforeach
                    </select>
                </div>

                <div class="col-md-6 mb-4">
                    <label class="form__label">Fecha</label>
                    <input class="form__input form-control required" type="date" name="date"
                        value="{{ $data->date }}" />
                </div>

                @if ($data->type_death == 0)
                    <div class="col-md-12">
                        <label class="form__label">Diagnóstico</label>
                        <textarea class="form__input form-control required" name="diagnostic" cols="30" rows="3">{{ $data->diagnostic }}</textarea>
                    </div>
                @else
                    <div class="col-md-6 mb-4 date_sale">
                        <label class="form__label">Fecha de venta</label>
                        <input class="form__input form-control required" type="date" name="date_sale"
                            value="{{ $data->date_sale }}" />
                    </div>

                    <div class="col-md-6 mb-4 guide_number">
                        <label class="form__label">Precio de venta</label>
                        <input class="form__input form-control required" type="number" name="guide_number" value="{{ $data->guide_number }}" />
                    </div>

                    <div class="col-md-12 observations">
                        <label class="form__label">Observaciones</label>
                        <textarea class="form__input form-control required" name="observation" cols="30" rows="3">{{ $data->observation }}</textarea>
                    </div>
                @endif

            </div>
        </div>
    </div>
    <div class="modal-footer bg-secondary">
        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
        <a href="javascript:void(0)" class="btn btn-primary" id="update_death_btn">Actualizar Evento</a>
    </div>
</form>
