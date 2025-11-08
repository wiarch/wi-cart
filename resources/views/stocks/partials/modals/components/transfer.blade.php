<div class="modal-header bg-dark text-white">
    <h1 class="modal-title fs-5" id="transferRowModalStockLabel">Transferir Stock</h1>
    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
</div>
<form action="#" method="POST" enctype="multipart/form-data" id="transfer_stock_form">
    @csrf
    @method('PUT')
    <div class="modal-body">
        <div class="col-12 mt-3">
            <div class="row">

                <input type="hidden" name="transfer_all" id="transfer_all"
                    value="{{ isset($data['all']) ? 'true' : 'false' }}">
                {{-- <input type="hidden" name="transfer_stock_id" value="{{ $data->id }}"> --}}
                <input type="hidden" name="transfer_old_field" value="{{ $data['field_id'] ?? 0 }}">
                <input type="hidden" name="transfer_old_rodeo" value="{{ $data['rodeo_id'] ?? 0 }}">
                @if (isset($ids))
                    @foreach ($ids as $id)
                        <input type="hidden" name="ids[]" value="{{ $id }}">
                    @endforeach
                @endif

                <div class="col-md-12">
                    <label class="form__label">Campo</label>
                    <select class="form__input form-control select_field" name="transfer_field" data-transfer="true">
                        <option value="0" disabled selected>Elegir un Campo</option>
                        @foreach ($fields as $field)
                            <option value="{{ $field->id }}">
                                {{ $field->name }}
                            </option>
                        @endforeach
                    </select>
                </div>

                <div class="col-md-12 mt-4">
                    <label class="form__label">Rodeo</label>
                    <select class="form__input form-control select_rodeo_transfer" disabled name="transfer_rodeo"
                        data-transfer="true">
                    </select>
                </div>

                <div class="col-md-12 mt-4">
                    <label class="form__label">Lote</label>
                    <input class="form__input form-control required select_batch_transfer" type="text"
                        name="transfer_batch" readonly />
                </div>

            </div>
        </div>
    </div>
    <div class="modal-footer bg-secondary">
        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
        <a href="javascript:void(0)" class="btn btn-primary" id="transfer_stock_btn">Transferir Stock</a>
    </div>
</form>

<script>
    $('.select_field').on('change', function() {
        const fieldId = $(this).val();

        dinamicSelect('.select_rodeo_transfer', 'Seleccione un Rodeo', 'getRodeos', {
            id: fieldId,
            batch: true,
            transfer: true
        }, 0, 'batch');

        $('.select_rodeo_transfer').prop('disabled', !fieldId).trigger('change.select2');

    });

    $('.select_rodeo_transfer').on('change', function() {

        batchId = $(this).find('option:selected').attr('data-batch');
        $('.select_batch_transfer').val(batchId);

    });
</script>
