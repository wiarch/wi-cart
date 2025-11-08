<div class="modal-header bg-dark text-white">
    <h1 class="modal-title fs-5">Editar Insumo Veterinario</h1>
    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
</div>
<form action="{{ route('veterinary-supplies.update', $veterinarySupply->id) }}" method="POST"
    enctype="multipart/form-data" id="edit_veterinary_supply_form">
    @csrf
    @method('PUT')

    <div class="modal-body">
        <div class="row">
            <div class="col-md-12 mb-3">
                <label class="form__label">Código de tratamiento</label>
                <select class="form__input form-cont
                rol required select2" name="code_tratment_id"
                    id="code_tratment_id_edit"></select>
                <input type="hidden" id="selected_code_id" value='{{ $veterinarySupply->code_tratment_id }}'>
            </div>
            <div class="col-md-4 mb-3">
                <label class="form__label">Stock inicial</label>
                <input class="form__input form-control required" type="number" name="stock_init" min="0"
                    step="0.01" value="{{ $veterinarySupply->stock_init }}" />
            </div>

        </div>
    </div>

    <div class="modal-footer bg-secondary">
        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
        <a href="javascript:void(0)" id="update_veterinary_supply_btn"
            onclick="formPostAjax('#edit_veterinary_supply_form', '{{ route('veterinary-supplies.update', $veterinarySupply->id) }}', '#table_veterinary_supplies', '#editRowModalVeterinarySupply', true)"
            class="btn btn-primary">Actualizar</a>
    </div>
</form>
