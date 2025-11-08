{{-- crear --}}
<div class="modal fade modal-md" id="createModalReproduction" data-bs-backdrop="static" data-bs-keyboard="false"
    tabindex="-1" aria-labelledby="createModalReproductionLabel">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header bg-dark text-white">
                <h1 class="modal-title fs-5" id="createModalReproductionLabel">Agregar Evento</h1>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <form action="{{ route('events.store') }}" method="POST" enctype="multipart/form-data"
                id="reproduction_form">
                @csrf
                <div class="modal-body">
                    <div class="row">

                        <input type="hidden" name="type" value="1">

                        <div class="col-md-6 mb-4">
                            <label class="form__label">Tipo de evento</label>
                            <select class="form__input form-control" id="select_type" name="type_reproduction">
                                <option value="" selected disabled>Seleccionar un tipo</option>
                                <option value="1">Parto</option>
                                <option value="2">Pre-servicio</option>
                                <option value="3">Ecografía</option>
                                <option value="4">Tacto</option>
                            </select>
                        </div>

                        <div class="col-md-6 mb-4">
                            <label class="form__label">Fecha</label>
                            <input class="form__input form-control required date" type="date" name="date"
                                value="{{ date('Y-m-d') }}" />
                        </div>

                        <div class="col-md-6 mb-4">
                            <label class="form__label">Rodeo</label>
                            <select class="form__input form-control" id="select_ajax_rodeo" name="rodeo_id">
                                <option value="" selected disabled>Seleccione un rodeo</option>
                            </select>
                        </div>

                        <div class="col-md-6 mb-4">
                            <label class="form__label">Caravana</label>
                            <select class="form__input form-control" id="select_ajax_stocks" name="stock_id">
                                <option value="" selected disabled>Seleccione un rodeo primero</option>
                            </select>
                        </div>

                        <div class="col-md-12 mb-4 diagnostic_div">
                            <label class="form__label">Diagnóstico</label>
                            <textarea class="form__input form-control required diagnostic" name="diagnostic" cols="30" rows="3"></textarea>
                        </div>


                        {{-- Parto --}}
                        <div class="col-md-6 mb-4 d-none parto">
                            <label class="form__label">Sexo</label>
                            <select class="form__input form-control" id="select_type" name="gender">
                                <option value="" selected disabled>Seleccionar un sexo</option>
                                <option value="0">Hembra</option>
                                <option value="1">Macho</option>
                            </select>
                        </div>

                        <div class="col-md-6 mb-4 d-none parto">
                            <label class="form__label">Peso</label>
                            <input class="form__input form-control required" type="number" name="weight" />
                        </div>

                        <div class="col-md-12 mb-4 d-none parto">
                            <label class="form__label">Observacion</label>
                            <textarea class="form__input form-control required" name="observation_birth" cols="30" rows="3"></textarea>
                        </div>

                        {{-- Pre-servicio --}}
                        <div class="col-md-6 mb-4 d-none pre-servicio ecografia tacto">
                            <label class="form__label">CC</label>
                            <input class="form__input form-control required cc" type="number" name="cc" />
                        </div>

                        <div class="col-md-6 mb-4 d-none pre-servicio">
                            <label class="form__label">Fecha de inseminación</label>
                            <input class="form__input form-control required" type="date" name="date_insemination" />
                        </div>

                        <div class="col-md-6 mb-4 d-none pre-servicio">
                            <label class="form__label">Toro</label>
                            <input class="form__input form-control required" type="text" name="bull" />
                        </div>

                    </div>
                </div>

                <div class="modal-footer bg-secondary">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                    <a href="javascript:void(0)"
                        onclick="formPostAjax('#reproduction_form', '{{ route('events.store') }}', '#table_reproductions', '#createModalReproduction')"
                        class="btn btn-primary">Crear Evento</a>
                </div>
            </form>
        </div>
    </div>
</div>

{{-- editar --}}
<div class="modal fade modal-md" id="editModalReproduction" data-bs-backdrop="static" data-bs-keyboard="false"
    tabindex="-1" aria-labelledby="editModalReproductionLabel">
    <div class="modal-dialog">
        <div class="modal-content" id="edit_modal_content_reproduction"></div>
    </div>
</div>
