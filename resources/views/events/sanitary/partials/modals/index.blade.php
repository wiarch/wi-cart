{{-- crear --}}
<div class="modal fade modal-md" id="createModalSanitary" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1"
    aria-labelledby="createModalSanitaryLabel">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header bg-dark text-white">
                <h1 class="modal-title fs-5" id="createModalSanitaryLabel">Agregar Evento</h1>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <form action="{{ route('events.store') }}" method="POST" enctype="multipart/form-data" id="sanitary_form">
                @csrf
                <div class="modal-body">
                    <div class="row">

                        <input type="hidden" name="type" value="2">


                        <div class="col-md-4 mb-4">
                            <label class="form__label">Tipo de evento</label>
                            <select class="form__input form-control" id="select_type" name="type_sanitary">
                                <option value="" selected disabled>Seleccionar un tipo</option>
                                <option value="0">Colectivo</option>
                                <option value="1">Individual</option>
                            </select>
                        </div>

                        <div class="col-md-4 mb-4 collective d-none">
                            <label class="form__label">Rodeo</label>
                            <select class="form__input form-control" id="select_ajax_rodeo" name="rodeo_id">
                                <option value="" selected disabled>Seleccione un rodeo</option>
                                {{-- <option value="" selected disabled>Buscar rodeo</option> --}}
                                @foreach ($rodeos as $rodeo)
                                    <option value="{{ $rodeo->id }}">{{ $rodeo->name }}</option>
                                @endforeach
                            </select>
                        </div>

                        <div class="col-md-4 mb-4 individual d-none">
                            <label class="form__label">Caravana</label>
                            <select class="form__input form-control" id="select_ajax_stocks" name="stock_id">
                                <option value="" selected disabled>Seleccione un rodeo primero</option>
                                @foreach ($stocks as $stock)
                                    <option value="{{ $stock->id }}">{{ $stock->name }}</option>
                                @endforeach
                            </select>
                        </div>


                        <div class="col-md-4 mb-4">
                            <label class="form__label">Categoría</label>
                            <select class="form__input form-control" name="type_animal_id">
                                <option value="" selected disabled>Seleccione una categoría</option>
                                @foreach ($type_animals as $animal_type)
                                    <option value="{{ $animal_type->id }}">{{ $animal_type->name }}</option>
                                @endforeach
                            </select>
                        </div>

                        <div class="col-md-4 mb-4">
                            <label class="form__label">Cod. tratamiento</label>
                            <select class="form__input form-control" name="treatment_code_id">
                                <option value="" selected disabled>Seleccione un codigo</option>
                                @foreach ($treatment_codes as $treatment_code)
                                    <option value="{{ $treatment_code->id }}">{{ $treatment_code->name }}</option>
                                @endforeach
                            </select>
                        </div>


                        <div class="col-md-4 mb-4">
                            <label class="form__label">Fecha</label>
                            <input class="form__input form-control required" type="date" name="date"
                                value="{{ date('Y-m-d') }}" />
                        </div>

                        <div class="col-md-4 mb-4">
                            <label class="form__label">Dosis</label>
                            <input class="form__input form-control required" type="number" name="dose" />
                        </div>

                        <div class="col-md-4 mb-4">
                            <label class="form__label">N° de serie</label>
                            <input class="form__input form-control required" type="number" name="serial_number" />
                        </div>

                        <div class="col-md-4 mb-4">
                            <label class="form__label">Vencimiento</label>
                            <input class="form__input form-control required" type="date" name="date_expiration"
                                value="{{ date('Y-m-d') }}" />
                        </div>

                        <div class="col-md-4 mb-4">
                            <label class="form__label">Marca</label>
                            <input class="form__input form-control required" type="text" name="mark" />
                        </div>

                        <div class="col-md-12 mb-4">
                            <label class="form__label">Retiro</label>
                            <input class="form__input form-control required" type="text" name="retirement" />
                        </div>

                        <div class="col-md-6">
                            <label class="form__label">Diagnóstico</label>
                            <textarea class="form__input form-control required" name="diagnostic" cols="30" rows="3"></textarea>
                        </div>

                        <div class="col-md-6">
                            <label class="form__label">Observacion</label>
                            <textarea class="form__input form-control required" name="observation" cols="30" rows="3"></textarea>
                        </div>


                    </div>
                </div>

                <div class="modal-footer bg-secondary">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                    <a href="javascript:void(0)"
                        onclick="formPostAjax('#sanitary_form', '{{ route('events.store') }}', '#table_sanitary', '#createModalSanitary')"
                        class="btn btn-primary">Crear Evento</a>
                </div>
            </form>
        </div>
    </div>
</div>

{{-- editar --}}
<div class="modal fade modal-md" id="editModalSanitary" data-bs-backdrop="static" data-bs-keyboard="false"
    tabindex="-1" aria-labelledby="editModalSanitaryLabel">
    <div class="modal-dialog">
        <div class="modal-content" id="edit_modal_content_sanitary"></div>
    </div>
</div>
