@include('layouts.partials.libs.select2')

<script>
    $(function() {

        datatableData('table_history', false, '#table_history', null);

        const $selectModule = $('.select_module');

        $selectModule.on('change', function() {
            datatableData('table_history', false, '#table_history', {
                module: $(this).val()
            });

        });

    });
</script>
