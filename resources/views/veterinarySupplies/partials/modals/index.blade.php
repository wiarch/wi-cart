{{-- crear --}}
<div class="modal fade" id="createModalVeterinarySupply" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1"
    aria-labelledby="createModalVeterinarySupplyLabel">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header bg-dark text-white">
                <h1 class="modal-title fs-5" id="createModalVeterinarySupplyLabel">Agregar Insumo Veterinario</h1>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <form action="{{ route('veterinary-supplies.store') }}" method="POST" enctype="multipart/form-data"
                id="veterinary_supply_form">
                @csrf

                <div class="modal-body">
                    <div class="row">
                        <div class="col-12 mb-3">
                            <label class="form__label">Código de tratamiento</label>
                            <select class="form__input form-control required select2" name="code_tratment_id"
                                id="code_tratment_id"></select>
                        </div>

                        <div class="col-md-4 mb-3">
                            <label class="form__label">Stock inicial</label>
                            <input class="form__input form-control required" type="number" name="stock_init"
                                min="0" step="0.01" placeholder="0.00" />
                        </div>

                    </div>
                </div>

                <div class="modal-footer bg-secondary">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                    <a href="javascript:void(0)"
                        onclick="formPostAjax('#veterinary_supply_form', '{{ route('veterinary-supplies.store') }}', '#table_veterinary_supplies', '#createModalVeterinarySupply')"
                        class="btn btn-primary">Crear Insumo Veterinario</a>
                </div>
            </form>
        </div>
    </div>
</div>

{{-- editar --}}
<div class="modal fade" id="editRowModalVeterinarySupply" data-bs-backdrop="static" data-bs-keyboard="false"
    tabindex="-1" aria-labelledby="editRowModalVeterinarySupplyLabel">
    <div class="modal-dialog modal-lg">
        <div class="modal-content" id="edit_modal_content_veterinary_supply">
            @isset($veterinarySupply)
                @include('veterinarySupplies.partials.modals.components.edit')
            @endisset
        </div>
    </div>
</div>
