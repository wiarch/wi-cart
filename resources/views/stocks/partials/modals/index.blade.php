{{-- crear --}}
<div class="modal fade modal-xl" id="addRowModalStock" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1"
    aria-labelledby="addRowModalStockLabel">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header bg-dark text-white">
                <h1 class="modal-title fs-5" id="addRowModalStockLabel">Agregar Stocks</h1>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <form action="{{ route('stocks.store') }}" method="POST" enctype="multipart/form-data" id="stock_form">
                @csrf
                <div class="modal-body">

                    <input id="field_select" type="hidden" name="field_id" />
                    <input id="rodeo_select" type="hidden" name="rodeo_id" />
                    <input id="batch_select" type="hidden" name="batch_id" />

                    <span class="row col-12" id="stock_container"></span>

                </div>
                <div class="modal-footer bg-secondary">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                    <a href="javascript:void(0)" onclick="removeStock()" class="btn btn-danger">Remover
                        Stock
                    </a>
                    <a href="javascript:void(0)" onclick="addStock()" class="btn btn-success">Añadir
                        Stock
                    </a>
                    <a href="javascript:void(0)"
                        onclick="formPostAjax('#stock_form', '{{ route('stocks.store') }}', '#table_stocks', '#addRowModalStock')"
                        class="btn btn-primary">Guardar Stocks</a>
                </div>
            </form>
        </div>
    </div>
</div>

{{-- editar --}}

<div class="modal fade modal-md" id="editRowModalStock" data-bs-backdrop="static" data-bs-keyboard="false"
    tabindex="-1" aria-labelledby="editRowModalStockLabel">
    <div class="modal-dialog">
        <div class="modal-content" id="edit_modal_content_stock"></div>
    </div>
</div>

{{-- transferir --}}
<div class="modal fade modal-md" id="transferRowModalStock" data-bs-backdrop="static" data-bs-keyboard="false"
    tabindex="-1" aria-labelledby="transferRowModalStockLabel">
    <div class="modal-dialog">
        <div class="modal-content" id="transfer_modal_content_stock"></div>
    </div>
</div>

