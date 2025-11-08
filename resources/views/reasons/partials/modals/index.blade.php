{{-- crear --}}
<div class="modal fade modal-md" id="createModalReason" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1"
    aria-labelledby="createModalReasonLabel">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header bg-dark text-white">
                <h1 class="modal-title fs-5" id="createModalReasonLabel">Agregar Porción</h1>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <form action="{{ route('reasons.store') }}" method="POST" enctype="multipart/form-data" id="reason_form">
                @csrf
                <div class="modal-body">
                    <div class="row">

                        <div class="col-md-6 mb-4">
                            <label class="form__label">Rodeo</label>
                            <select class="form__input form-control" id="select_ajax_rodeo" name="rodeo_id">
                                <option value="" selected disabled>Seleccione un rodeo</option>
                                @foreach ($rodeos as $rodeo)
                                    <option value="{{ $rodeo->id }}">{{ $rodeo->name }}</option>
                                @endforeach
                            </select>
                        </div>

                        <div class="col-md-6 mb-4">
                            <label class="form__label">Alimentación</label>
                            <select class="form__input form-control food" name="food_id">
                                <option value="null" selected>Elegir una Alimentación</option>
                                @foreach ($foods as $food)
                                    <option value="{{ $food->id }}">{{ $food->detail }}</option>
                                @endforeach
                            </select>
                        </div>

                        <div class="col-md-6 mb-4">
                            <label class="form__label">Detalle</label>
                            <textarea class="form__input form-control required" name="detail" cols="30" rows="3"></textarea>
                        </div>

                        <div class="col-md-6 mb-4">
                            <label class="form__label">Porción</label>
                            <input class="form__input form-control required" type="number" name="reason_value" />
                        </div>

                    </div>
                </div>

                <div class="modal-footer bg-secondary">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                    <a href="javascript:void(0)"
                        onclick="formPostAjax('#reason_form', '{{ route('reasons.store') }}', '#table_reasons', '#createModalReason')"
                        class="btn btn-primary">Crear Evento</a>
                </div>
            </form>
        </div>
    </div>
</div>

{{-- editar --}}
<div class="modal fade modal-md" id="editModalReason" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1"
    aria-labelledby="editModalReasonLabel">
    <div class="modal-dialog">
        <div class="modal-content" id="edit_modal_content_reason"></div>
    </div>
</div>
