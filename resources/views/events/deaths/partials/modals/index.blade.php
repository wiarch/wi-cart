{{-- crear --}}
<div class="modal fade modal-md" id="createModalDeath" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1"
    aria-labelledby="createModalDeathLabel">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header bg-dark text-white">
                <h1 class="modal-title fs-5" id="createModalDeathLabel">Agregar Evento</h1>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <form action="{{ route('events.store') }}" method="POST" enctype="multipart/form-data" id="death_form">
                @csrf
                <div class="modal-body">
                    <div class="row">

                        <input type="hidden" name="type" value="3">

                        <div class="col-md-6 mb-4">
                            <label class="form__label">Rodeo</label>
                            <select class="form__input form-control" id="select_ajax_rodeo" name="rodeo_id">
                                <option value="" selected disabled>Seleccione un rodeo</option>
                                {{-- <option value="" selected disabled>Buscar rodeo</option> --}}
                                @foreach ($rodeos as $rodeo)
                                    <option value="{{ $rodeo->id }}">{{ $rodeo->name }}</option>
                                @endforeach
                            </select>
                        </div>

                        <div class="col-md-6 mb-4">
                            <label class="form__label">Caravana</label>
                            <select class="form__input form-control" id="select_ajax_stocks" name="stock_id">
                                <option value="" selected disabled>Seleccione un rodeo primero</option>
                            </select>
                        </div>

                        <div class="col-md-6 mb-4">
                            <label class="form__label">Categoría</label>
                            <select class="form__input form-control type_animal" name="type_animal_id">
                                <option value="null" selected>Elegir una categoría</option>
                                @foreach ($type_animals as $type_animal)
                                    <option value="{{ $type_animal->id }}">{{ $type_animal->name }}</option>
                                @endforeach
                            </select>
                        </div>

                        <div class="col-md-6 mb -4">
                            <label class="form__label">Fecha</label>
                            <input class="form__input form-control required" type="date" name="date"
                                value="{{ date('Y-m-d') }}" />
                        </div>

                        <div class="col-md-12 mb-4">
                            <label class="form__label">Tipo de baja</label>
                            <select class="form__input form-control type_death" name="type_death">
                                <option value="null" selected>Elegir un tipo</option>
                                <option value="0">Muerte</option>
                                <option value="1">Venta</option>
                            </select>
                        </div>

                        {{-- muerte --}}
                        <div class="col-md-12 d-none diagnostic">
                            <label class="form__label">Diagnóstico</label>
                            <textarea class="form__input form-control required" name="diagnostic" cols="30" rows="3"></textarea>
                        </div>


                        {{-- venta --}}
                        <div class="col-md-6 mb-4 d-none date_sale">
                            <label class="form__label">Fecha de venta</label>
                            <input class="form__input form-control required" type="date" name="date_sale"
                                value="{{ date('Y-m-d') }}" />
                        </div>

                        <div class="col-md-6 mb-4 d-none guide_number">
                            <label class="form__label">Precio de venta</label>
                            <input class="form__input form-control required" type="number" name="guide_number" />
                        </div>

                        <div class="col-md-12 d-none observations">
                            <label class="form__label">Observaciones</label>
                            <textarea class="form__input form-control required" name="observation" cols="30" rows="3"></textarea>
                        </div>

                    </div>
                </div>

                <div class="modal-footer bg-secondary">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                    <a href="javascript:void(0)"
                        onclick="formPostAjax('#death_form', '{{ route('events.store') }}', '#table_deaths', '#createModalDeath')"
                        class="btn btn-primary">Crear Evento</a>
                </div>
            </form>
        </div>
    </div>
</div>

{{-- editar --}}
<div class="modal fade modal-md" id="editModalDeath" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1"
    aria-labelledby="editModalDeathLabel">
    <div class="modal-dialog">
        <div class="modal-content" id="edit_modal_content_death"></div>
    </div>
</div>
