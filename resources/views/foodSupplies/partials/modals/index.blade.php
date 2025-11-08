{{-- crear --}}
<div class="modal fade modal-md" id="createModalFoodSupply" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1"
    aria-labelledby="createModalFoodSupplyLabel">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header bg-dark text-white">
                <h1 class="modal-title fs-5" id="createModalFoodSupplyLabel">Agregar Insumo Alimentario</h1>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <form action="{{ route('food-supplies.store') }}" method="POST" enctype="multipart/form-data"
                id="food_supply_form">
                @csrf

                <div class="modal-body">
                    <div class="row">
                        <div class="col-md-12 mb-3">
                            <label class="form__label">Código de tratamiento</label>
                            <select class="form__input form-control required" name="code_tratment_id"
                                id="code_tratment_id">
                                <option value="" selected disabled>Seleccione un código</option>
                            </select>
                        </div>
                        <div class="col-md-4 mb-3">
                            <label class="form__label">Stock inicial</label>
                            <input class="form__input form-control required" type="number" name="stock_init"
                                min="0" step="0.01" placeholder="0.00" />
                        </div>
                        <div class="col-md-4 mb-3">
                            <label class="form__label">Consumidas</label>
                            <input class="form__input form-control required" type="number" name="consumed"
                                min="0" step="0.01" placeholder="0.00" />
                        </div>
                        <div class="col-md-4 mb-3">
                            <label class="form__label">Stock restante</label>
                            <input class="form__input form-control required" type="number" name="stock_end"
                                min="0" step="0.01" placeholder="0.00" />
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
                        onclick="formPostAjax('#food_supply_form', '{{ route('food-supplies.store') }}', '#table_food_supplies', '#createModalFoodSupply')"
                        class="btn btn-primary">Crear Insumo Alimentario</a>
                </div>
            </form>
        </div>
    </div>
</div>

{{-- editar --}}
<div class="modal fade modal-md" id="editRowModalFoodSupply" data-bs-backdrop="static" data-bs-keyboard="false"
    tabindex="-1" aria-labelledby="editRowModalFoodSupplyLabel">
    <div class="modal-dialog">
        <div class="modal-content" id="edit_modal_content_food_supply">
            @isset($foodSupply)
                @include('foodSupplies.partials.modals.components.edit')
            @endisset
        </div>
    </div>
</div>
