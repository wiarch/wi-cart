<div class="modal-header bg-dark text-white">
    <h1 class="modal-title fs-5" id="editRowModalStockLabel">Actualizar Stock</h1>
    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
</div>

<form action="#" method="POST" enctype="multipart/form-data" id="edit_stock_form">
    @csrf
    @method('PUT')
    <div class="modal-body">
        <div class="col-12 mt-3">
            <div class="row">

                <!-- SELECT IDENTIFICADOR -->
                <div class="col-md-12" id="edit_index_select_container">
                    <label class="form__label">Identificador</label>
                    @php
                        $options = [
                            'IDV (identificación visual)' => 'IDV (identificación visual)',
                            'EID (identificación electrónica)' => 'EID (identificación electrónica)',
                            'IDV (identificación visual) y EID (identificación electrónica)' => 'Ambos',
                        ];
                    @endphp
                    <select class="form__input form-control" name="edit_index" id="edit_index_select">
                        <option value="0" disabled {{ empty($data) ? 'selected' : '' }}>Elegir un Identificador
                        </option>
                        @foreach ($options as $value => $label)
                            <option value="{{ $value }}" {{ $data->index === $value ? 'selected' : '' }}>
                                {{ $label }}
                            </option>
                        @endforeach
                    </select>
                </div>

                <!-- INPUT IDV -->
                <div class="col-md-12 mt-3 d-none" id="edit_idv_field">
                    <label class="form__label">N° de IDV</label>
                    <input class="form__input form-control" type="text" name="edit_index_idv"
                        value="{{ $data->index_idv ?? '' }}" />
                </div>

                <!-- INPUT EID -->
                <div class="col-md-12 mt-3 d-none" id="edit_eid_field">
                    <label class="form__label">N° de EID</label>
                    <input class="form__input form-control" type="text" name="edit_index_eid"
                        value="{{ $data->index_eid ?? '' }}" />
                </div>

                <!-- SELECT TIPO -->
                <div class="col-md-12 mt-3" id="edit_type_field">
                    <label class="form__label">Tipo</label>
                    <select class="form__input form-control" name="edit_type_animal">
                        <option value="0" disabled selected>Elegir un Tipo</option>
                        @foreach ($type_animals as $type_animal)
                            <option value="{{ $type_animal->id }}"
                                {{ $data->type_animal_id === $type_animal->id ? 'selected' : '' }}>
                                {{ $type_animal->name }}
                            </option>
                        @endforeach
                    </select>
                </div>

            </div>
        </div>
    </div>

    <div class="modal-footer bg-secondary">
        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
        <a href="javascript:void(0)" class="btn btn-primary" id="update_stock_btn">Actualizar Stock</a>
    </div>
</form>

<script>
    $(function() {
        const $indexSelect = $('#edit_index_select');
        const $idvField = $('#edit_idv_field');
        const $eidField = $('#edit_eid_field');
        const $typeField = $('#edit_type_field');

        function toggleFields() {
            const val = $indexSelect.val();
            $idvField.addClass('d-none');
            $eidField.addClass('d-none');
            $typeField.addClass('d-none');

            if (val.includes('IDV') && val.includes('EID')) {
                $idvField.removeClass('d-none').removeClass('col-md-12').addClass('col-md-6');
                $eidField.removeClass('d-none').removeClass('col-md-12').addClass('col-md-6');
                $typeField.removeClass('d-none');
            } else if (val.includes('IDV')) {
                $idvField.removeClass('d-none').removeClass('col-md-6').addClass('col-md-12');
                $typeField.removeClass('d-none');
            } else if (val.includes('EID')) {
                $eidField.removeClass('d-none').removeClass('col-md-6').addClass('col-md-12');
                $typeField.removeClass('d-none');
            }
        }

        // Inicializar según el valor actual
        toggleFields();

        // Cambios en el select
        $indexSelect.on('change', toggleFields);
    });
</script>
