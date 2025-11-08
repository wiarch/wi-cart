<script>
    $(document).ready(function() {
        // Inicializar DataTable con endpoint AJAX para listar insumos
        datatableData(
            'table_supplies',
            false,
            '#table_supplies',
            {
                ajax: {
                    url: "{{ route('ajax.datatables.supplies.user') }}",
                    type: 'GET'
                },
                columns: [
                    { data: 'name', title: 'Insumo' },
                    { data: 'quantity', title: 'Cantidad' },
                    { data: 'unit', title: 'UMedida' },
                    { data: 'date', title: 'Fecha' },
                    { data: 'batch_name', title: 'Lote' },
                    { data: null, title: 'Acciones', orderable: false, searchable: false, render: function() { return ''; } }
                ]
            }
        );
        getBatches();

        function getBatches() {
            console.log($('#batch_id'));
            $.ajax({
                url: "{{ route('supplies.get.batches') }}",
                type: 'GET',
                dataType: 'json',
                success: function(response) {
                    if (response.batches && response.batches.length > 0) {
                        let options =
                            '<option value="" selected disabled>Seleccione un Lote</option>';
                        response.batches.forEach(batch => {
                            options += `<option value="${batch.id}">${batch.name}</option>`;
                        });
                        $('#batch_id').html(options);
                    } else {
                        $('#batch_id').html(
                            '<option value="" selected disabled>No hay Lotes disponibles</option>'
                        );
                    }
                },
                error: function() {
                    console.error('Error al obtener los lotes.');
                    $('#batch_id').html(
                        '<option value="" selected disabled>Error al cargar los lotes</option>'
                    );
                }
            });
        }
    });
</script>
