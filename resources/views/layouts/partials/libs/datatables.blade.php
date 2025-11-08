{{-- Estilos y librería de DataTables --}}
<link href="{{ asset('libs/datatables/datatables.min.css') }}" rel="stylesheet">
<script src="{{ asset('libs/datatables/datatables.min.js') }}"></script>

<script>
    /**
     * Configuración de todas las tablas con sus columnas y rutas dinámicas.
     * Solo se define la configuración mínima para cada tabla.
     */
    const TABLES_CONFIG = {
        table_supplies: {
            route: "{{ route('ajax.datatables.supplies.user') }}",
            columns: [{
                    data: 'name'
                },
                {
                    data: 'quantity'
                },
                {
                    data: 'unit'
                },
                {
                    data: 'date'
                },
                {
                    data: 'batch_name'
                },
            ],
            actions: [{
                    type: 'edit',
                    routeTemplate: "{{ route('supplies.edit', '::id::') }}",
                    routeUpdate: "{{ route('supplies.update', '::id::') }}",
                    modal: '#editRowModalSupply',
                    form: '#edit_supply_form',
                    btn: '#update_supply_btn'
                },
                {
                    type: 'delete',
                    routeTemplate: "{{ route('supplies.destroy', '::id::') }}"
                }
            ]
        },
        table_veterinary_supplies: {
            route: "{{ route('ajax.datatables.veterinary_supplies.user') }}",
            columns: [{
                    data: 'code_tratment_name'
                },
                {
                    data: 'stock_init'
                },
                {
                    data: 'stock_end'
                },
                {
                    data: 'consumed'
                },
            ],
            actions: [{
                    type: 'edit',
                    routeTemplate: "{{ route('veterinary-supplies.edit', '::id::') }}",
                    routeUpdate: "{{ route('veterinary-supplies.update', '::id::') }}",
                    modal: '#editRowModalVeterinarySupply',
                    form: '#edit_veterinary_supply_form',
                    btn: '#update_veterinary_supply_btn'
                },
                {
                    type: 'delete',
                    routeTemplate: "{{ route('veterinary-supplies.destroy', '::id::') }}"
                }
            ]
        },
        table_fields: {
            route: "{{ route('ajax.datatables.fields.user') }}",
            columns: [{
                    data: 'id',
                    visible: false
                },
                {
                    data: 'name'
                },
                {
                    data: 'location'
                },
                {
                    data: 'coordinate'
                }
            ],
            actions: [{
                    type: 'edit',
                    routeTemplate: "{{ route('fields.edit', '::id::') }}",
                    routeUpdate: "{{ route('fields.update', '::id::') }}",
                    modal: '#editRowModalField',
                    form: '#edit_field_form',
                    btn: '#update_field_btn'
                },
                {
                    type: 'delete',
                    routeTemplate: "{{ route('fields.destroy', '::id::') }}"
                }
            ]
        },

        table_batches: {
            route: "{{ route('ajax.datatables.batches.user') }}",
            columns: [{
                    data: 'id',
                    visible: false
                },
                {
                    data: 'name'
                },
                {
                    data: 'surface'
                },
                {
                    data: 'field_name',
                    render: function(data, type, row) {
                        // Log para verificar qué viene
                        // console.log("field_name (data):", data, " | row:", row);

                        // Si tiene valor válido lo devuelve, sino "No Asignado"
                        return data && data.trim() !== '' ? data : 'No Asignado';
                    }
                }
            ],
            actions: [{
                    type: 'edit',
                    routeTemplate: "{{ route('batches.edit', '::id::') }}",
                    routeUpdate: "{{ route('batches.update', '::id::') }}",
                    modal: '#editRowModalBatch',
                    form: '#edit_batch_form',
                    btn: '#update_batch_btn'
                },
                {
                    type: 'delete',
                    routeTemplate: "{{ route('batches.destroy', '::id::') }}"
                }
            ]
        },

        table_rodeos: {
            route: "{{ route('ajax.datatables.rodeos.user') }}",
            columns: [{
                    data: 'id',
                    visible: false
                },
                {
                    data: 'name'
                },
                {
                    data: 'field_name'
                },
                {
                    data: 'batch_name'
                },
                {
                    data: 'region_name'
                },
                {
                    data: null,
                    render: row => `${row.service_name} (${row.service_description})`
                },
                {
                    data: 'animal_breed_name'
                }
            ],
            actions: [{
                    type: 'edit',
                    routeTemplate: "{{ route('rodeos.edit', '::id::') }}",
                    routeUpdate: "{{ route('rodeos.update', '::id::') }}",
                    modal: '#editRowModalRodeo',
                    form: '#edit_rodeo_form',
                    btn: '#update_rodeo_btn'
                },
                {
                    type: 'delete',
                    routeTemplate: "{{ route('rodeos.destroy', '::id::') }}"
                }
            ]
        },

        table_stocks: {
            route: "{{ route('ajax.datatables.stocks.user') }}",
            columns: [{
                    data: 'id',
                    render: function(data, type, row) {
                        return `<label><input type="checkbox" onclick="handleCheckboxClick(this, '.selected_stock_ids', '.transfer-selected')" data-id="${data}"> Seleccionar</label>`;
                    }
                },
                {
                    data: 'index_idv',
                    render: function(data, type, row) {
                        return row.index_idv ? row.index_idv : 'No definido';
                    }
                },
                {
                    data: 'index_eid',
                    render: function(data, type, row) {
                        return row.index_eid ? row.index_eid : 'No definido';
                    }
                },
                {
                    data: 'field_name'
                },
                {
                    data: 'rodeo_name'
                },
                {
                    data: 'batch_name'
                },
                {
                    data: 'type_animal_name'
                },
                {
                    data: 'animal_breed_name'
                }
            ],
            actions: [{
                    type: 'edit',
                    routeTemplate: "{{ route('stocks.edit', '::id::') }}",
                    routeUpdate: "{{ route('stocks.update', '::id::') }}",
                    modal: '#editRowModalStock',
                    form: '#edit_stock_form',
                    btn: '#update_stock_btn'
                },
                {
                    type: 'transfer',
                    routeTemplate: "{{ route('stocks.transfer', '::id::') }}",
                    modal: '#transferRowModalStock',
                    form: '#transfer_stock_form',
                    btn: '#transfer_stock_btn',
                    extraRoute: "{{ route('stocks.move', '::id::') }}"
                },
                {
                    type: 'delete',
                    routeTemplate: "{{ route('stocks.destroy', '::id::') }}"
                }
            ]
        },

        table_grazings: {
            route: "{{ route('ajax.datatables.grazings.user') }}",
            columns: [{
                    data: 'id',
                    visible: false
                },
                {
                    data: 'rodeo_name'
                },
                {
                    data: 'batch_name'
                },
                {
                    data: 'surface'
                },
                {
                    data: 'region_name'
                },
                {
                    data: 'forage_resource_name'
                },
                {
                    data: 'type_grazing_name'
                },
                {
                    data: 'input_date'
                },
                {
                    data: 'output_date'
                }
            ],
            actions: [{
                    type: 'edit',
                    routeTemplate: "{{ route('grazings.edit', '::id::') }}",
                    routeUpdate: "{{ route('grazings.update', '::id::') }}",
                    modal: '#editRowModalGrazing',
                    form: '#edit_grazing_form',
                    btn: '#update_grazing_btn'
                },
                {
                    type: 'delete',
                    routeTemplate: "{{ route('grazings.destroy', '::id::') }}"
                }
            ]
        },

        table_stocks_reunion: {
            route: "{{ route('ajax.datatables.stocks-reunion.user') }}",
            columns: [{
                    data: 'id',
                    visible: false
                },
                {
                    data: 'rodeo_name'
                },
                {
                    data: 'type_animal_name'
                },
                {
                    data: 'amount'
                },
                {
                    data: 'animal_breed_name'
                },
                {
                    data: 'date',
                    render: function(data, type, row) {
                        if (!row.date) return 'No definido';
                        return row.date.split(' ')[0];
                    }
                }
            ]
        },

        table_history: {
            route: "{{ route('ajax.datatables.events.logs.module') }}",
            columns: [{
                    data: 'id',
                    visible: false
                },
                {
                    data: 'description'
                },
                {
                    data: 'module_name'
                },
                {
                    data: 'created_at'
                }
            ],
            actions: [{
                type: 'show',
                routeTemplate: "{{ route('events.logs.list.show', '::id::') }}",
                modal: '#showStocksModal'
            }]
        },

        table_reproductions: {
            route: "{{ route('ajax.datatables.events.reproductions') }}",
            columns: [{
                    data: 'id',
                    visible: false
                },
                {
                    data: 'stock_index'
                },
                {
                    data: 'type_animal_name'
                },
                {
                    data: 'date_birth',
                    render: function(data, type, row) {
                        return row.date_birth ? row.date_birth : 'No definido';
                    }
                },
                {
                    data: 'gender',
                    render: function(data, type, row) {
                        return row.gender == 1 ? 'Macho' : 'Hembra';
                    }
                },
                {
                    data: 'weight',
                    render: function(data, type, row) {
                        return row.weight ? row.weight : 'No definido';
                    }
                },
                {
                    data: 'observation_birth',
                    render: function(data, type, row) {
                        return row.observation_birth ? row.observation_birth : 'No definido';
                    }
                },
                {
                    data: 'diagnostic_birth',
                    render: function(data, type, row) {
                        return row.diagnostic_birth ? row.diagnostic_birth : 'No definido';
                    }
                },
                {
                    data: 'date_pre_service',
                    render: function(data, type, row) {
                        return row.date_pre_service ? row.date_pre_service : 'No definido';
                    }
                },
                {
                    data: 'diagnostic_pre_service',
                    render: function(data, type, row) {
                        return row.diagnostic_pre_service ? row.diagnostic_pre_service : 'No definido';
                    }
                },
                {
                    data: 'cc_pre_service',
                    render: function(data, type, row) {
                        return row.cc_pre_service ? row.cc_pre_service : 'No definido';
                    }
                },
                {
                    data: 'date_insemination',
                    render: function(data, type, row) {
                        return row.date_insemination ? row.date_insemination : 'No definido';
                    }
                },
                {
                    data: 'bull',
                    render: function(data, type, row) {
                        return row.bull ? row.bull : 'No definido';
                    }
                },
                {
                    data: 'date_ecography',
                    render: function(data, type, row) {
                        return row.date_ecography ? row.date_ecography : 'No definido';
                    }
                },
                {
                    data: 'diagnostic_ecography',
                    render: function(data, type, row) {
                        return row.diagnostic_ecography ? row.diagnostic_ecography : 'No definido';
                    }
                },
                {
                    data: 'cc_ecography',
                    render: function(data, type, row) {
                        return row.cc_ecography ? row.cc_ecography : 'No definido';
                    }
                },
                {
                    data: 'date_touch',
                    render: function(data, type, row) {
                        return row.date_touch ? row.date_touch : 'No definido';
                    }
                },
                {
                    data: 'diagnostic_touch',
                    render: function(data, type, row) {
                        return row.diagnostic_touch ? row.diagnostic_touch : 'No definido';
                    }
                },
                {
                    data: 'cc_touch',
                    render: function(data, type, row) {
                        return row.cc_touch ? row.cc_touch : 'No definido';
                    }
                }
            ],
            actions: [{
                    type: 'edit',
                    routeTemplate: "{{ route('events.edit', '::id::') }}",
                    routeUpdate: "{{ route('events.update', '::id::') }}",
                    modal: '#editModalReproduction',
                    form: '#edit_reproduction_form',
                    btn: '#update_reproduction_btn'
                },
                {
                    type: 'delete',
                    routeTemplate: "{{ route('events.destroy', '::id::') }}"
                }
            ],
            headerCallback: function(thead, data, start, end, display) {
                $(thead).find('tr').eq(0).prepend('<th rowspan="2">ID</th>');
                $(thead).find('tr').eq(0).append('<th colspan="2">Información Personal</th>');
                // puedes manipular más aquí
            }
        },

        table_sanitary: {
            route: "{{ route('ajax.datatables.events.sanitary') }}",
            columns: [{
                    data: 'id',
                    visible: false
                },
                {
                    data: 'field_name',
                    render: function(data, type, row) {
                        return row.field_name || 'No definido';
                    }
                },
                {
                    data: 'rodeo_name',
                    render: function(data, type, row) {
                        return row.rodeo_name || 'No definido';
                    }
                },
                {
                    data: 'stock_index',
                    render: function(data, type, row) {
                        return row.type_sanitary == 1 ?
                            (row.stock_index ? row.stock_index : 'S/C (sin caravana)') :
                            'No definido';

                    }
                },
                {
                    data: 'treatment_name'
                },
                {
                    data: 'type_animal_name'
                },
                {
                    data: 'type_sanitary',
                    render: function(data, type, row) {
                        return row.type_sanitary == 1 ? 'Individual' : 'Colectivo';
                    }
                },
                {
                    data: 'dose'
                },
                {
                    data: 'serial_number'
                },
                {
                    data: 'date_expiration'
                },
                {
                    data: 'mark'
                },
                {
                    data: 'retirement'
                },
                {
                    data: 'diagnostic'
                },
                {
                    data: 'observation'
                },
                {
                    data: 'date'
                }
            ],
            actions: [{
                    type: 'edit',
                    routeTemplate: "{{ route('events.edit', '::id::') }}",
                    routeUpdate: "{{ route('events.update', '::id::') }}",
                    modal: '#editModalSanitary',
                    form: '#edit_sanitary_form',
                    btn: '#update_sanitary_btn'
                },
                {
                    type: 'delete',
                    routeTemplate: "{{ route('events.destroy', '::id::') }}"
                }
            ]
        },

        table_deaths: {
            route: "{{ route('ajax.datatables.events.deaths') }}",
            columns: [{
                    data: 'id',
                    visible: false
                },
                {
                    data: 'field_name',
                },
                {
                    data: 'rodeo_name'
                },
                {
                    data: 'stock_index'
                },
                {
                    data: 'type_animal_name'
                },
                {
                    data: 'date'
                },
                {
                    data: 'type_death',
                    render: function(data, type, row) {
                        return row.type_death == 0 ? 'Muerte' : 'Venta';
                    }
                },
                {
                    data: 'diagnostic',
                    render: function(data, type, row) {
                        return row.diagnostic ? row.diagnostic : 'No definido';
                    }
                },
                {
                    data: 'observation',
                    render: function(data, type, row) {
                        return row.observation ? row.observation : 'No definido';
                    }
                },
                {
                    data: 'guide_number',
                    render: function(data, type, row) {
                        return row.guide_number ? row.guide_number : 'No definido';
                    }
                },
                {
                    data: 'date_sale',
                    render: function(data, type, row) {
                        return row.date_sale ? row.date_sale : 'No definido';
                    }
                }
            ],
            actions: [{
                    type: 'edit',
                    routeTemplate: "{{ route('events.edit', '::id::') }}",
                    routeUpdate: "{{ route('events.update', '::id::') }}",
                    modal: '#editModalDeath',
                    form: '#edit_death_form',
                    btn: '#update_death_btn'
                },
                {
                    type: 'delete',
                    routeTemplate: "{{ route('events.destroy', '::id::') }}"
                }
            ]
        },


        table_feedings: {
            route: "{{ route('ajax.datatables.events.feedings') }}",
            columns: [{
                    data: 'id',
                    visible: false
                },
                {
                    data: 'rodeo_name'
                },
                {
                    data: 'stock_index'
                },
                {
                    data: 'weight'
                },
                {
                    data: 'date'
                }
            ],
            actions: [{
                    type: 'edit',
                    routeTemplate: "{{ route('events.edit', '::id::') }}",
                    routeUpdate: "{{ route('events.update', '::id::') }}",
                    modal: '#editModalFeeding',
                    form: '#edit_feeding_form',
                    btn: '#update_feeding_btn'
                },
                {
                    type: 'delete',
                    routeTemplate: "{{ route('events.destroy', '::id::') }}"
                }
            ]
        },
        table_herd_weighings: {
            route: "{{ route('ajax.datatables.herd_weighings.user') }}",
            columns: [{
                    data: 'weighing_date'
                },
                {
                    data: 'type_animal_id'
                },
                {
                    data: 'vid_eid'
                },
                {
                    data: 'weight'
                },
            ]
            // Sin acciones: solo listar
        },

        table_reasons: {
            route: "{{ route('ajax.datatables.reasons.user') }}",
            columns: [{
                    data: 'id',
                    visible: false
                },
                {
                    data: 'rodeo_name'
                },
                {
                    data: 'food_name'
                },
                {
                    data: 'detail'
                },
                {
                    data: 'reason_value'
                }
            ],
            actions: [{
                    type: 'edit',
                    routeTemplate: "{{ route('reasons.edit', '::id::') }}",
                    routeUpdate: "{{ route('reasons.update', '::id::') }}",
                    modal: '#editModalReason',
                    form: '#edit_reason_form',
                    btn: '#update_reason_btn'
                },
                {
                    type: 'delete',
                    routeTemplate: "{{ route('reasons.destroy', '::id::') }}"
                }
            ]
        },

        table_terminations: {
            route: "{{ route('ajax.datatables.terminations.user') }}",
            columns: [{
                    data: 'id',
                    visible: false
                },
                {
                    data: 'reason_name'
                },
                {
                    data: 'type',
                    render: function(data, type, row) {
                        return row.type == 0 ? 'Recría' : 'Terminación';
                    }
                },
                {
                    data: 'cms'
                },
                {
                    data: 'pv'
                },
                {
                    data: 'gdp'
                },
                {
                    data: 'animals'
                },
                {
                    data: 'days'
                },
                {
                    data: 'date'
                }
            ],
            actions: [{
                    type: 'edit',
                    routeTemplate: "{{ route('terminations.edit', '::id::') }}",
                    routeUpdate: "{{ route('terminations.update', '::id::') }}",
                    modal: '#editModalTermination',
                    form: '#edit_termination_form',
                    btn: '#update_termination_btn'
                },
                {
                    type: 'delete',
                    routeTemplate: "{{ route('terminations.destroy', '::id::') }}"
                }
            ]
        },
    };

    /**
     * Función genérica para inicializar cualquier DataTable
     */
    function datatableData(table, init = true, table_name = null, data = null) {
        if (init) {
            $(table_name).DataTable({
                paging: false,
                searching: false,
                info: false,
                ordering: false,
                responsive: true,
                language: {
                    emptyTable: "No hay conexión disponible"
                }
            });
            return;
        }

        const config = TABLES_CONFIG[table];

        if (!config) {
            console.error("Tabla no configurada: ", table);
            return;
        }

        // Destruye la tabla si ya existe
        if ($.fn.DataTable.isDataTable(table_name)) $(table_name).DataTable().destroy();

        // Columnas finales: solo agregamos la columna "action" si hay acciones definidas
        const columns = config.actions && config.actions.length > 0 ?
            config.columns.concat([{
                data: 'action',
                render: function(data, type, row) {
                    return config.actions.map(act => renderAction(act, row, table_name)).join('');
                }
            }]) :
            config.columns;

        const dt = $(table_name).DataTable({
            processing: true,
            serverSide: true,
            searching: true,
            ordering: true,
            paging: true,
            pageLength: 10,
            ajax: {
                url: config.route,
                data: data ?? {}
            },
            columns: columns,
            data: {
                _token: "{{ csrf_token() }}"
            }
        });

        // Evento draw específico para limpiar checkboxes en table_stocks
        if (table === 'table_stocks') {
            dt.on('draw', function() {
                selectedIds = [];
                $(table_name + ' input[type=checkbox]').prop('checked', false);
                $('.selected_stock_ids').val('');
                $('.transfer-selected').addClass('d-none');
            });
        }
    }

    /**
     * Genera botones de acción de manera genérica
     */
    function renderAction(action, row, table_name) {
        const id = row.id;
        const route = action.extraRoute ?
            routeReplaceId(action.extraRoute, id) :
            routeReplaceId(action.routeTemplate, id);

        let extraData = {};
        const tableTypes = {
            '#table_logs': 0,
            '#table_reproductions': 1,
            '#table_sanitary': 2,
            '#table_deaths': 3,
            '#table_feedings': 4
        };
        if (tableTypes[table_name] !== undefined) {
            extraData = {
                type: tableTypes[table_name],
                type_death: row.type_death
            };
        }

        switch (action.type) {
            case 'edit':
                return `<button type="button" title="Editar" data-bs-toggle="modal" data-bs-target="${action.modal}"
                class="btn btn-link btn-primary"
                onclick="formGetAjax('${route}', '${routeReplaceId(action.routeUpdate, id)}', '${action.form}', '${action.btn}', '${table_name}', '${action.modal}', '${encodeURIComponent(JSON.stringify(extraData))}')">
                <i class="fa fa-edit"></i>
            </button>`;
            case 'delete':
                return `<button type="button" title="Eliminar" class="btn btn-link btn-danger"
                onclick='formDeleteAjax("${route}", "${table_name}", ${JSON.stringify(extraData)})'>
                <i class="fa fa-times"></i>
            </button>`;
            case 'transfer':
                return `<button type="button" title="Transferir" data-bs-toggle="modal" data-bs-target="${action.modal}"
                class="btn btn-link btn-info"
                onclick="formGetAjax('${routeReplaceId(action.routeTemplate, id)}', '${route}', '${action.form}', '${action.btn}', '${table_name}', '${action.modal}')">
                <i class="fa fa-arrow-right-arrow-left"></i>
            </button>`;
            case 'show':
                return `<button type="button" title="Ver Detalles" data-bs-toggle="modal" data-bs-target="${action.modal}"
                class="btn btn-link btn-primary" onclick="formGetAjax('${route}')">
                <i class="fa fa-eye"></i>
            </button>`;
            default:
                return '';
        }
    }

    /**
     * Reemplaza ::id:: en las rutas dinámicas
     */
    function routeReplaceId(template, id) {
        return template.replace('::id::', id);
    }
</script>
