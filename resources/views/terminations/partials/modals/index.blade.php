{{-- crear --}}
<div class="modal fade modal-md" id="createModalTermination" data-bs-backdrop="static" data-bs-keyboard="false"
    tabindex="-1" aria-labelledby="createModalTerminationLabel">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header bg-dark text-white">
                <h1 class="modal-title fs-5" id="createModalTerminationLabel">Agregar Porción</h1>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <form action="{{ route('terminations.store') }}" method="POST" enctype="multipart/form-data"
                id="termination_form">
                @csrf
                <div class="modal-body">
                    <div class="row">

                        <div class="col-md-12 mb-4">
                            <label class="form__label">Nombre de alimentación</label>
                            <input class="form__input form-control required" type="text" name="reason_name" />
                        </div>

                        <div class="col-md-5 mb-4">
                            <label class="form__label">Tipo</label>
                            <select class="form__input form-control food" name="type">
                                <option value="null" selected>Elegir un tipo</option>
                                <option value="0">Recría</option>
                                <option value="1">Terminación</option>
                            </select>
                        </div>

                        <div class="col-md-4 mb-4">
                            <label class="form__label">Fecha</label>
                            <input class="form__input form-control required" type="date" name="date"
                                value="{{ date('Y-m-d') }}" />
                        </div>

                        <div class="col-md-3 mb-4">
                            <label class="form__label">CMS</label>
                            <input class="form__input form-control required" type="number" name="cms" />
                        </div>

                        <div class="col-md-3 mb-4">
                            <label class="form__label">PV</label>
                            <input class="form__input form-control required" type="number" name="pv" />
                        </div>

                        <div class="col-md-3 mb-4">
                            <label class="form__label">GPD en KG</label>
                            <input class="form__input form-control required" type="number" name="gdp" />
                        </div>

                        <div class="col-md-3 mb-4">
                            <label class="form__label">Animales</label>
                            <input class="form__input form-control required" type="number" name="animals" />
                        </div>

                        <div class="col-md-3 mb-4">
                            <label class="form__label">Dias</label>
                            <input class="form__input form-control required" type="number" name="days" />
                        </div>

                    </div>
                </div>

                <div class="modal-footer bg-secondary">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                    <a href="javascript:void(0)"
                        onclick="formPostAjax('#termination_form', '{{ route('terminations.store') }}', '#table_terminations', '#createModalTermination')"
                        class="btn btn-primary">Crear Registro</a>
                </div>
            </form>
        </div>
    </div>
</div>

{{-- editar --}}
<div class="modal fade modal-md" id="editModalTermination" data-bs-backdrop="static" data-bs-keyboard="false"
    tabindex="-1" aria-labelledby="editModalTerminationLabel">
    <div class="modal-dialog">
        <div class="modal-content" id="edit_modal_content_termination"></div>
    </div>
</div>
