<script>
    $(function() {

        datatableData('table_grazings', false, '#table_grazings', null);

        const $selectRodeo = $('.select_rodeo');
        const $showAllBtn = $('.show-all');
        const $addGrazingBtn = $('.add-grazing');

        $selectRodeo.on('change', function() {
            const rodeoId = $(this).val();

            $('#rodeo_select').val(rodeoId);

            const data = {
                rodeo: $selectRodeo.val(),
            };

            if (rodeoId !== '0') {
                datatableData('table_grazings', false, '#table_grazings', data);

                $addGrazingBtn.removeClass('d-none');
                $showAllBtn.removeClass('d-none');
            } else {
                datatableData('table_grazings', false, '#table_grazings', null);
                $addGrazingBtn.addClass('d-none');
                $showAllBtn.addClass('d-none');
            }
        });

        $showAllBtn.on('click', function() {
            $selectRodeo.val('0').trigger('change.select2');
            datatableData('table_grazings', false, '#table_grazings', null);
            $addGrazingBtn.addClass('d-none');
            $showAllBtn.addClass('d-none');
        });

        $('.select_region').on('change', function() {
            const regionId = $(this).val();

            dinamicSelect('#select_ajax_forage_resources', 'Seleccione una base de recurso',
                'getForageResources', regionId);

        });
    });
</script>
