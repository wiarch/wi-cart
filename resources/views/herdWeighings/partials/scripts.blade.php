<script>
    $(document).ready(function() {
        // Inicializa DataTable del módulo Control de Peso
        datatableData('table_herd_weighings', false, '#table_herd_weighings', null);

        // Manejo de filtros de fechas
        function reloadTableWithFilters() {
            const from = $('#filter_date_from').val();
            const to = $('#filter_date_to').val();
            const params = {};
            if (from) params.date_from = from;
            if (to) params.date_to = to;
            datatableData('table_herd_weighings', false, '#table_herd_weighings', Object.keys(params).length ?
                params : null);
        }

        $('#filter_date_from, #filter_date_to').on('change', reloadTableWithFilters);

        $('#btn_clear_filters').on('click', function() {
            $('#filter_date_from').val('');
            $('#filter_date_to').val('');
            datatableData('table_herd_weighings', false, '#table_herd_weighings', null);
        });

        // Calcular y mostrar PROMEDIO y GDP en cada actualización de datos
        const table = $('#table_herd_weighings').DataTable();
        $('#table_herd_weighings').on('xhr.dt', function(e, settings, json, xhr) {
            try {
                const rows = (json && json.aaData) ? json.aaData : [];
                if (!rows.length) {
                    $('#avg_weight_label').text('-');
                    $('#gdp_label').text('-');
                    return;
                }

                // PROMEDIO de weight
                const weights = rows
                    .map(r => parseFloat(r.weight))
                    .filter(v => !isNaN(v));
                const avg = weights.length ? (weights.reduce((a, b) => a + b, 0) / weights.length) :
                    null;
                $('#avg_weight_label').text(avg !== null ? avg.toFixed(2) : '-');

                // GDP aproximado (si hay al menos 2 registros con fecha y peso)
                const parsed = rows
                    .filter(r => r.weighing_date && r.weight)
                    .map(r => ({
                        d: new Date(r.weighing_date),
                        w: parseFloat(r.weight)
                    }))
                    .sort((a, b) => a.d - b.d);

                if (parsed.length >= 2) {
                    const first = parsed[0];
                    const last = parsed[parsed.length - 1];
                    const msPerDay = 1000 * 60 * 60 * 24;
                    const days = Math.max(1, Math.round((last.d - first.d) / msPerDay));
                    const gdp = (last.w - first.w) / days;
                    $('#gdp_label').text(isFinite(gdp) ? gdp.toFixed(3) : '-');
                } else {
                    $('#gdp_label').text('-');
                }
            } catch (err) {
                $('#avg_weight_label').text('-');
                $('#gdp_label').text('-');
            }
        });
    });
</script>
