{{-- Estilos de Select2 --}}
<link href="{{ asset('libs/select2/select2.min.css') }}" rel="stylesheet">
<link href="{{ asset('libs/select2/select2.pers.css') }}" rel="stylesheet">

{{-- Script de Select2 --}}
<script src="{{ asset('libs/select2/select2.min.js') }}"></script>

<script>
    /**
     * Resetea un <select> a su estado inicial con placeholder dinámico
     * @param {string|HTMLElement} select - Selector o elemento <select>
     * @param {string|null} placeholder - Texto de placeholder
     * @param {boolean} isSelect2 - Indica si el select usa Select2
     * @param {boolean} clearOptions - Si true, elimina todas las opciones
     */
    function resetSelect(select, placeholder = null, isSelect2 = false, clearOptions = false) {
        const $select = $(select);

        // Si es Select2, destruimos la instancia antes de modificar opciones
        if (isSelect2 && $select.hasClass('select2-hidden-accessible')) {
            $select.select2('destroy');
        }

        // Limpiar opciones si se indica
        if (clearOptions) {
            $select.empty();
        }

        // Si se pasa placeholder, reemplaza o agrega la primera opción
        if (placeholder !== null) {
            const $firstOption = $select.find('option:first');
            if ($firstOption.length) {
                $firstOption.text(placeholder).val('').prop('disabled', true).prop('selected', true);
            } else {
                $select.append($('<option>', {
                    value: '',
                    text: placeholder,
                    disabled: true,
                    selected: true
                }));
            }
        }

        // Selecciona la primera opción
        $select.prop('selectedIndex', 0);

        // Re-inicializa Select2 si corresponde
        if (isSelect2) {
            $select.select2({
                placeholder: placeholder || '',
                width: '100%',
                allowClear: false
            });
        } else {
            $select.trigger('change');
        }
    }


    /**
     * Inicializa un Select2 estándar con carga de datos vía AJAX
     */
    function dinamicSelect(
        select,
        text,
        routeName = 'select2',
        routeParam = null,
        id = 0,
        data = null,
        disabled = false,
        modal = null,
        onSelect = null
    ) {
        // Selector final (si hay id, se concatena)
        const selector = id === 0 ? select : `${select}_${id}`;

        // Destruye Select2 previo y vacía el select
        if ($(selector).hasClass('select2-hidden-accessible')) {
            $(selector).select2('destroy');
            $(selector).empty();
        }

        // Rutas disponibles
        const routeMap = {
            select2: "{{ route('select2') }}",
            getRegions: "{{ route('ajax.get.regions') }}",
            getAnimalBreeds: "{{ route('ajax.get.animal_breeds') }}",
            getFields: "{{ route('ajax.get.fields.user', ['id' => '::param::']) }}",
            getRodeos: "{{ route('ajax.get.rodeos.user', ['id' => '::param::']) }}",
            getStocks: "{{ route('ajax.get.stocks.user', ['id' => '::param::']) }}",
            getbatches: "{{ route('ajax.get.batches.user', ['id' => '::param::']) }}",
            getForageResources: "{{ route('ajax.get.forage_resources.region', ['id' => '::param::']) }}",
            getServices: "{{ route('ajax.get.services') }}",
        };

        let route = routeMap[routeName];

        // Procesa parámetros dinámicos
        if (routeParam !== null) {
            if (typeof routeParam === 'object') {
                if (route.includes('::param::') && routeParam.id !== undefined) {
                    route = route.replace('::param::', routeParam.id);
                    delete routeParam.id;
                }
                const queryString = Object.keys(routeParam)
                    .map(key => `${key}=${encodeURIComponent(routeParam[key])}`)
                    .join('&');
                if (queryString) {
                    route += (route.includes('?') ? '&' : '?') + queryString;
                }
            } else {
                route = route.replace('::param::', routeParam);
            }
        }

        // Inicialización base de Select2
        $(selector).select2({
            language: "es",
            placeholder: text,
            allowClear: false,
            width: '100%',
            disabled: disabled,
            dropdownParent: modal ?? null
        });

        // Carga de datos AJAX
        $.ajax({
            type: 'GET',
            url: route,
            success: function(response) {
                // Vaciar select antes de agregar opciones para evitar duplicados
                $(selector).empty().append(`<option value="" disabled selected>${text}</option>`);

                response.forEach(item => {
                    const extraAttr = data ? ` data-${data}="${item.data}"` : "";
                    $(selector).append(
                        `<option value="${item.id}"${extraAttr}>${item.name}</option>`
                    );
                });

                $(selector).val("").trigger('change');

                // Evento al seleccionar
                if (onSelect) {
                    $(selector).on('select2:select', e => onSelect(e.params.data));
                    $(selector).on('select2:clear', () => onSelect({
                        id: null,
                        text: ''
                    }));
                }
            },
            error: function() {
                console.error(`❌ Error al cargar datos para ${selector}`);
            }
        });
    }


    /**
     * Inicializa un select dinámico con AJAX y búsqueda en tiempo real
     */
    function dinamicSelectAjax({
        selector,
        url,
        placeholder = 'Seleccione una opción',
        minLength = 1,
        mapResult,
        onSelect,
        disabled = false,
        dropdownParent = null
    }) {

        // Destruye cualquier Select2 previo y vacía el select
        if ($(selector).hasClass('select2-hidden-accessible')) {
            $(selector).select2('destroy');
            $(selector).empty();
        }

        const configBase = {
            placeholder: placeholder,
            width: '100%',
            dropdownParent: dropdownParent ? $(dropdownParent) : ($(selector).closest('.modal').length ? $(selector)
                .closest('.modal') : $(selector).closest('form, div, body')),
            allowClear: false,
            language: 'es'
        };

        if (disabled) {
            $(selector).select2({
                ...configBase,
                minimumResultsForSearch: Infinity
            });

            if (onSelect) {
                $(selector).val(null).trigger('change');
                $(selector).on('select2:select', e => onSelect(e.params.data));
                $(selector).on('select2:clear', () => onSelect({
                    id: null,
                    text: ''
                }));
            }

            return;
        }

        $(selector).select2({
            ...configBase,
            minimumInputLength: minLength,
            ajax: {
                url: url,
                dataType: 'json',
                delay: 300,
                data: params => ({
                    search: params.term || ''
                }),
                processResults: data => ({
                    results: data.map(item => mapResult(item))
                }),
                cache: true,
                error: (xhr, status, error) => {
                    if (status !== 'abort') console.error('Error cargando datos Select2:', error);
                }
            },
            templateResult: item => item.loading ? item.text : $('<span>').text(item.text),
            templateSelection: item => item.text
        });

        if (onSelect) {
            $(selector).on('select2:select', e => onSelect(e.params.data));
            $(selector).on('select2:clear', () => onSelect({
                id: null,
                text: ''
            }));
        }

        $(selector).on('select2:open', function() {
            const searchField = $('.select2-container--open .select2-search__field');
            searchField.off('input').on('input', function() {
                if ($(this).val() === '') {
                    $(selector).val(null).trigger('change');
                    if (onSelect) onSelect({
                        id: null,
                        text: ''
                    });
                }
            });
        });
    }
</script>
