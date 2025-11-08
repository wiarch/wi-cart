<div class="modal-header bg-dark text-white">
    <h1 class="modal-title fs-5" id="showStocksModalLabel">Lista de Stocks</h1>
    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
</div>

<div class="modal-body">
    <div class="col-12 mt-3">
        <div class="table-responsive">
            <table class="display table table-striped table-hover table_show">
                <thead class="table-dark">
                    <tr>
                        <th>Identificador</th>
                        <th>N° de Identificador</th>
                    </tr>
                </thead>
                <tbody>
                    @foreach ($stocks as $stock)
                        <tr>
                            <td>{{ $stock->index }}</td>
                            <td>{{ $stock->index_description }}</td>
                        </tr>
                    @endforeach
                </tbody>
            </table>
        </div>
    </div>
</div>
<div class="modal-footer bg-secondary">
    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cerrar</button>
</div>

<script>
    $('.table_show').DataTable({
        paging: false,
        searching: true,
        info: false,
        ordering: false,
        responsive: true,
        language: {
            emptyTable: "No hay conexion disponible",
        },
    });
</script>
