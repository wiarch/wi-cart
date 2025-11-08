{{-- crear --}}
<div class="modal fade modal-md" id="createModalGrazing" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1"
    aria-labelledby="createModalGrazingLabel">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header bg-dark text-white">
                <h1 class="modal-title fs-5" id="createModalGrazingLabel">Agregar Pastoreos</h1>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <form action="{{ route('grazings.store') }}" method="POST" enctype="multipart/form-data" id="grazing_form">
                @csrf

                <input id="rodeo_select" type="hidden" name="rodeo_id" />

                <div class="modal-body">
                    <div class="row">

                        <div class="col-md-6 mb-4">
                            <label class="form__label">Regions</label>
                            <select class="form__input form-control select_region" name="region_id">
                                <option value="" selected disabled>Seleccione una categoría</option>
                                @foreach ($regions as $region)
                                    <option value="{{ $region->id }}">{{ $region->name }}</option>
                                @endforeach
                            </select>
                        </div>

                        <div class="col-md-6 mb-4">
                            <label class="form__label">Base Recursos</label>
                            <select class="form__input form-control" id="select_ajax_forage_resources" name="forage_resource_id">
                                <option value="" selected disabled>Seleccione una region primero</option>
                            </select>
                        </div>

                        <div class="col-md-12 mb-4">
                            <label class="form__label">Tipo de Pastoreo</label>
                            <select class="form__input form-control" name="grazing_id">
                                <option value="" selected disabled>Seleccione una categoría</option>
                                @foreach ($type_grazings as $type_grazing)
                                    <option value="{{ $type_grazing->id }}">{{ $type_grazing->name }}</option>
                                @endforeach
                            </select>
                        </div>

                        <div class="col-md-6 mb-4">
                            <label class="form__label">Fecha de Entrada</label>
                            <input class="form__input form-control required" type="date" name="input_date"
                                value="{{ date('Y-m-d') }}" />
                        </div>

                        <div class="col-md-6 mb-4">
                            <label class="form__label">Fecha de Salida</label>
                            <input class="form__input form-control required" type="date" name="output_date"
                                value="{{ date('Y-m-d') }}" />
                        </div>
                    </div>
                </div>

                <div class="modal-footer bg-secondary">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                    <a href="javascript:void(0)"
                        onclick="formPostAjax('#grazing_form', '{{ route('events.store') }}', '#table_grazings', '#createModalGrazing')"
                        class="btn btn-primary">Crear Pastoreo</a>
                </div>
            </form>
        </div>
    </div>
</div>

{{-- editar --}}

<div class="modal fade modal-md" id="editRowModalGrazing" data-bs-backdrop="static" data-bs-keyboard="false"
    tabindex="-1" aria-labelledby="editRowModalGrazingLabel">
    <div class="modal-dialog">
        <div class="modal-content" id="edit_modal_content_grazing"></div>
    </div>
</div>
