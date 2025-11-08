{{-- crear --}}
<div class="modal fade modal-md" id="createModalFeeding" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1"
    aria-labelledby="createModalFeedingLabel">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header bg-dark text-white">
                <h1 class="modal-title fs-5" id="createModalFeedingLabel">Agregar Evento</h1>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <form action="{{ route('events.store') }}" method="POST" enctype="multipart/form-data" id="feeding_form">
                @csrf
                <div class="modal-body">
                    <div class="row">

                        <input type="hidden" name="type" value="4">

                        <div class="col-md-12">
                            <label class="form__label">Rodeo</label>
                            <select class="form__input form-control" id="select_ajax_rodeo" name="rodeo_id">
                                <option value="" selected disabled>Seleccione un rodeo</option>
                                @foreach ($rodeos as $rodeo)
                                    <option value="{{ $rodeo->id }}">{{ $rodeo->name }}</option>
                                @endforeach
                            </select>
                        </div>

                        <div class="col-md-12 my-4">
                            <label class="form__label">Stock</label>
                            <select class="form__input form-control" id="select_ajax_stocks" name="stock_id">
                                <option value="" selected disabled>Seleccione un rodeo primero</option>
                            </select>
                        </div>


                        <div class="col-md-6 mt-4">
                            <input class="form__input form-control required" type="number" name="weight"
                                placeholder="Peso en KG" />
                        </div>

                        <div class="col-md-6">
                            <label class="form__label">Fecha</label>
                            <input class="form__input form-control required" type="date" name="date"
                                value="{{ date('Y-m-d') }}" />
                        </div>


                    </div>
                </div>

                <div class="modal-footer bg-secondary">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                    <a href="javascript:void(0)"
                        onclick="formPostAjax('#feeding_form', '{{ route('events.store') }}', '#table_feedings', '#createModalFeeding')"
                        class="btn btn-primary">Crear Evento</a>
                </div>
            </form>
        </div>
    </div>
</div>

{{-- editar --}}
<div class="modal fade modal-md" id="editModalFeeding" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1"
    aria-labelledby="editModalFeedingLabel">
    <div class="modal-dialog">
        <div class="modal-content" id="edit_modal_content_feeding"></div>
    </div>
</div>
