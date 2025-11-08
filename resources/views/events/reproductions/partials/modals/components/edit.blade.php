<div class="modal-header bg-dark text-white">
    <h1 class="modal-title fs-5" id="editModalReproductionLabel">Actualizar Evento</h1>
    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
</div>
<form action="#" method="POST" enctype="multipart/form-data" id="edit_reproduction_form">
    @csrf
    @method('PUT')
    <div class="modal-body">
        <div class="col-12 mt-3">
            <div class="row">

                <input type="hidden" name="type" value="1">

                <div class="col-md-6 mb-4">
                    <label class="form__label">Tipo de evento</label>
                    <select class="form__input form-control" id="select_type_edit" name="type_reproduction">
                        <option value="" selected disabled>Seleccionar un tipo</option>
                        <option value="1">Parto</option>
                        <option value="2">Pre-servicio</option>
                        <option value="3">Ecografía</option>
                        <option value="4">Tacto</option>
                    </select>
                </div>

                <div class="col-md-6 mb-4 d-none date_div_edit">
                    <label class="form__label">Fecha</label>
                    <input class="form__input form-control required date_edit" type="date" name="date" />
                </div>

                <div class="col-md-6 mb-4 d-none diagnostic_div_edit">
                    <label class="form__label">Diagnóstico</label>
                    <textarea class="form__input form-control required diagnostic_edit" name="diagnostic" cols="30" rows="3"></textarea>
                </div>

                {{-- parto_edit --}}
                <div class="col-md-6 mb-4 d-none parto_edit">
                    <label class="form__label">Sexo</label>
                    <select class="form__input form-control" id="select_type" name="gender">
                        <option value="" selected disabled>Seleccionar un sexo</option>
                        <option {{ $data->gender == 0 ? 'selected' : '' }} value="0">Hembra</option>
                        <option {{ $data->gender == 1 ? 'selected' : '' }} value="1">Macho</option>
                    </select>
                </div>

                <div class="col-md-6 mb-4 d-none parto_edit">
                    <label class="form__label">Peso</label>
                    <input class="form__input form-control required" type="number" name="weight"
                        value="{{ $data->weight }}" />
                </div>

                <div class="col-md-6 mb-4 d-none parto_edit">
                    <label class="form__label">Observacion</label>
                    <textarea class="form__input form-control required" name="observation_birth" cols="30" rows="3">{{ $data->observation_birth }}</textarea>
                </div>

                {{-- pre-servicio_edit --}}
                <div class="col-md-6 mb-4 d-none pre-servicio_edit ecografia_edit tacto_edit">
                    <label class="form__label">CC</label>
                    <input class="form__input form-control required cc_edit" type="number" name="cc" />
                </div>

                <div class="col-md-6 mb-4 d-none pre-servicio_edit">
                    <label class="form__label">Fecha de inseminación</label>
                    <input class="form__input form-control required" type="date" name="date_insemination"
                        value="{{ $data->date_insemination }}" />
                </div>

                <div class="col-md-6 mb-4 d-none pre-servicio_edit">
                    <label class="form__label">Toro</label>
                    <input class="form__input form-control required" type="text" name="bull"
                        value="{{ $data->bull }}" />
                </div>

            </div>
        </div>
    </div>
    <div class="modal-footer bg-secondary">
        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
        <a href="javascript:void(0)" class="btn btn-primary" id="update_reproduction_btn">Actualizar Evento</a>
    </div>
</form>

<script>
    $('#select_type_edit').on('change', function() {
        const type = $(this).val();

        // Ocultar todas las secciones
        const sections = ['tacto_edit', 'parto_edit', 'pre-servicio_edit', 'ecografia_edit'];
        sections.forEach(cls => $('.' + cls).addClass('d-none'));

        // Reset de la clase col-md-12
        $('.diagnostic_div_edit').removeClass('d-none');
        $('.date_div_edit').removeClass('d-none');

        // Configuración por tipo
        const config = {
            1: {
                section: 'parto_edit',
                date: 'date_birth',
                date_edit: '{{ $data->date_birth }}',
                diagnostic: 'diagnostic_birth',
                textarea: '{{ $data->diagnostic_birth }}',
                cc: null,
                fullWidth: false
            },
            2: {
                section: 'pre-servicio_edit',
                date: 'date_pre_service',
                date_edit: '{{ $data->date_pre_service }}',
                diagnostic: 'diagnostic_pre_service',
                textarea: '{{ $data->diagnostic_pre_service }}',
                cc: 'cc_pre_service',
                cc_edit: '{{ $data->cc_pre_service }}',
                fullWidth: true
            },
            3: {
                section: 'ecografia_edit',
                date: 'date_ecography',
                date_edit: '{{ $data->date_ecography }}',
                diagnostic: 'diagnostic_ecography',
                textarea: '{{ $data->diagnostic_ecography }}',
                cc: 'cc_ecography',
                cc_edit: '{{ $data->cc_ecography }}',
                fullWidth: true
            },
            4: {
                section: 'tacto_edit',
                date: 'date_touch',
                date_edit: '{{ $data->date_touch }}',
                diagnostic: 'diagnostic_touch',
                textarea: '{{ $data->diagnostic_touch }}',
                cc: 'cc_touch',
                cc_edit: '{{ $data->cc_touch }}',
                fullWidth: true
            }
        };

        if (config[type]) {
            const cfg = config[type];

            // Mostrar la sección correspondiente
            $('.' + cfg.section).removeClass('d-none');

            // Cambiar atributos name
            $('.date_edit').attr('name', cfg.date).val(cfg.date_edit);
            $('.diagnostic_edit').attr('name', cfg.diagnostic).text(cfg.textarea);

            if (cfg.cc) {
                $('.cc_edit').attr('name', cfg.cc).val(cfg.cc_edit);
            }

            // Ajustar el ancho de diagnostic_div si es fullWidth
            if (cfg.fullWidth) {
                // $('.diagnostic_div_edit').addClass('col-md-12');
            }
        }
    });
</script>
