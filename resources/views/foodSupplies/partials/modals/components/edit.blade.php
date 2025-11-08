<div class="modal-header bg-dark text-white">
    <h1 class="modal-title fs-5">Editar Insumo Alimentario</h1>
    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
</div>
<form action="{{ route('food-supplies.update', $foodSupply->id) }}" method="POST" enctype="multipart/form-data"
    id="edit_food_supply_form">
    @csrf
    @method('PUT')

    <div class="modal-body">
        <div class="row">
            <div class="col-md-12 mb-3">
                <label class="form__label">Código de tratamiento</label>
                <select class="form__input form-control required" name="code_tratment_id" id="code_tratment_id_edit">
                    <option value="" disabled>Seleccione un código</option>
                </select>
            </div>
            <div class="col-md-4 mb-3">
                <label class="form__label">Stock inicial</label>
                <input class="form__input form-control required" type="number" name="stock_init" min="0"
                    step="0.01" value="{{ $foodSupply->stock_init }}" />
            </div>
            <div class="col-md-4 mb-3">
                <label class="form__label">Consumidas</label>
                <input class="form__input form-control required" type="number" name="consumed" min="0"
                    step="0.01" value="{{ $foodSupply->consumed }}" />
            </div>
            <div class="col-md-4 mb-3">
                <label class="form__label">Stock restante</label>
                <input class="form__input form-control required" type="number" name="stock_end" min="0"
                    step="0.01" value="{{ $foodSupply->stock_end }}" />
            </div>
            <div class="col-md-6 mb-3">
                <label class="form__label">Lote</label>
                <select class="form__input form-control" name="batch_id" id="batch_id_edit">
                    @foreach ($batches as $batch)
                        <option value="{{ $batch->id }}" @selected($batch->id == $foodSupply->batch_id)>{{ $batch->name }}</option>
                    @endforeach
                </select>
            </div>
        </div>
    </div>

    <div class="modal-footer bg-secondary">
        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
        <a href="javascript:void(0)" id="update_food_supply_btn"
            onclick="formPostAjax('#edit_food_supply_form', '{{ route('food-supplies.update', $foodSupply->id) }}', '#table_food_supplies', '#editRowModalFoodSupply', true)"
            class="btn btn-primary">Actualizar</a>
    </div>
</form>
