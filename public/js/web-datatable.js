(() => {
    window.initWebDataTable = function (selector, options = {}) {
        const table = $(selector);
        const headers = table.find('thead th').map(function () {
            return $(this).text().trim();
        }).get();

        const defaults = {
            processing: true,
            serverSide: true,
            responsive: false,
            autoWidth: false,
            pageLength: 10,
            lengthMenu: [[10, 25, 50], [10, 25, 50]],
            dom: '<"web-dt-toolbar"lf>rt<"web-dt-footer"ip>',
            drawCallback: function () {
                this.api().rows({ page: 'current' }).every(function () {
                    $(this.node()).find('td').each(function (index) {
                        if (headers[index]) {
                            $(this).attr('data-label', headers[index]);
                        }
                    });
                });
            },
            language: {
                url: '/js/lib/datatables/spanish.json',
            },
        };

        return table.DataTable({ ...defaults, ...options });
    };
})();
