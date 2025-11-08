<div class="modal-header bg-dark text-white">
    <h1 class="modal-title fs-5">Editar Insumo</h1>
    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
</div>
<form action="{{ route('supplies.update', $supply->id) }}" method="POST" enctype="multipart/form-data"
    id="edit_supply_form">
    @csrf
    @method('PUT')

    <div class="modal-body">
        <div class="row">
            <div class="col-md-12 mb-3">
                <label class="form__label">Insumo</label>
                <input class="form__input form-control required" type="text" name="name"
                    value="{{ $supply->name }}" />
            </div>
            <div class="col-md-6 mb-3">
                <label class="form__label">Cantidad</label>
                <input class="form__input form-control required" type="number" name="quantity" min="0"
                    step="1" value="{{ $supply->quantity }}" />
            </div>
            <div class="col-md-6 mb-3">
                <label class="form__label">UMedida</label>
                <input class="form__input form-control required" type="text" name="unit"
                    value="{{ $supply->unit }}" />
            </div>
            <div class="col-md-6 mb-3">
                <label class="form__label">Fecha</label>
                <input class="form__input form-control required" type="date" name="date"
                    value="{{ $supply->date }}" />
            </div>
            <div class="col-md-6 mb-3">
                <label class="form__label">Lote</label>
                <select class="form__input form-control" name="batch_id">
                    @foreach ($batches as $batch)
                        <option value="{{ $batch->id }}" @selected($batch->id == $supply->batch_id)>{{ $batch->name }}</option>
                    @endforeach
                </select>
            </div>
        </div>
    </div>

    <div class="modal-footer bg-secondary">
        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
        <a href="javascript:void(0)" id="update_supply_btn"
            onclick="formPostAjax('#edit_supply_form', '{{ route('supplies.update', $supply->id) }}', '#table_supplies', '#editRowModalSupply', true)"
            class="btn btn-primary">Actualizar</a>
    </div>
</form>
