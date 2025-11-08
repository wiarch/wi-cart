{{-- crear --}}
<div class="modal fade modal-lg" id="addRowModalBatch" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1"
    aria-labelledby="addRowModalBatchLabel">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header bg-dark text-white">
                <h1 class="modal-title fs-5" id="addRowModalBatchLabel">Agregar Lotes</h1>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <form action="{{ route('batches.store') }}" method="POST" enctype="multipart/form-data" id="batch_form">
                @csrf

                <input id="field_select" type="hidden" name="field_id" />

                <div class="modal-body">

                    <span class="row col-12" id="batch_container"></span>

                </div>

                <div class="modal-footer bg-secondary">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                    <a href="javascript:void(0)" onclick="removeBatch()" class="btn btn-danger">Remover
                        Lote
                    </a>
                    <a href="javascript:void(0)" onclick="addBatch()" class="btn btn-success">Añadir
                        Lote
                    </a>
                    <a href="javascript:void(0)"
                        onclick="formPostAjax('#batch_form', '{{ route('batches.store') }}', '#table_batches', '#addRowModalBatch')"
                        class="btn btn-primary">Guardar Lotes</a>
                </div>
            </form>
        </div>
    </div>
</div>

{{-- editar --}}

<div class="modal fade modal-md" id="editRowModalBatch" data-bs-backdrop="static" data-bs-keyboard="false"
    tabindex="-1" aria-labelledby="editRowModalBatchLabel">
    <div class="modal-dialog">
        <div class="modal-content" id="edit_modal_content_batch"></div>
    </div>
</div>
