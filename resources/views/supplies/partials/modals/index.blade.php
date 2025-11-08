{{-- crear --}}
<div class="modal fade modal-md" id="createModalSupply" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1"
    aria-labelledby="createModalSupplyLabel">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header bg-dark text-white">
                <h1 class="modal-title fs-5" id="createModalSupplyLabel">Agregar Insumo</h1>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <form action="{{ route('supplies.store') }}" method="POST" enctype="multipart/form-data" id="supply_form">
                @csrf

                <div class="modal-body">
                    <div class="row">
                        <div class="col-md-12 mb-3">
                            <label class="form__label">Insumo</label>
                            <input class="form__input form-control required" type="text" name="name"
                                placeholder="Nombre del insumo" />
                        </div>
                        <div class="col-md-6 mb-3">
                            <label class="form__label">Cantidad</label>
                            <input class="form__input form-control required" type="number" name="quantity"
                                min="0" step="1" placeholder="0" />
                        </div>
                        <div class="col-md-6 mb-3">
                            <label class="form__label">UMedida</label>
                            <input class="form__input form-control required" type="text" name="unit"
                                placeholder="kg, l, u, etc." />
                        </div>
                        <div class="col-md-6 mb-3">
                            <label class="form__label">Fecha</label>
                            <input class="form__input form-control required" type="date" name="date"
                                value="{{ date('Y-m-d') }}" />
                        </div>
                        <div class="col-md-6 mb-3">
                            <label class="form__label">Lote</label>
                            <select id="batch_id" class="form__input form-control batches" name="batch_id">
                                <option value="" selected disabled>Seleccione un Lote</option>
                                @isset($batches)
                                    @foreach ($batches as $batch)
                                        <option value="{{ $batch->id }}">{{ $batch->name }}</option>
                                    @endforeach
                                @endisset
                            </select>
                        </div>
                    </div>
                </div>

                <div class="modal-footer bg-secondary">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                    <a href="javascript:void(0)"
                        onclick="formPostAjax('#supply_form', '{{ route('supplies.store') }}', '#table_supplies', '#createModalSupply')"
                        class="btn btn-primary">Crear Insumo</a>
                </div>
            </form>
        </div>
    </div>
</div>

{{-- editar --}}
<div class="modal fade modal-md" id="editRowModalSupply" data-bs-backdrop="static" data-bs-keyboard="false"
    tabindex="-1" aria-labelledby="editRowModalSupplyLabel">
    <div class="modal-dialog">
        <div class="modal-content" id="edit_modal_content_supply">
            @isset($supply)
                @include('supplies.partials.modals.components.edit')
            @endisset
        </div>
    </div>
</div>
