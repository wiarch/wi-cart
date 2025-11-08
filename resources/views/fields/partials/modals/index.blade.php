{{-- crear --}}
<div class="modal fade modal-xl" id="addRowModalField" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1"
    aria-labelledby="addRowModalFieldLabel">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header bg-dark text-white">
                <h1 class="modal-title fs-5" id="addRowModalFieldLabel">Agregar Campos</h1>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <form action="{{ route('fields.store') }}" method="POST" enctype="multipart/form-data" id="field_form">
                @csrf
                <div class="modal-body">

                    <span class="row col-12" id="field_container"></span>

                </div>
                <div class="modal-footer bg-secondary">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                    <a href="javascript:void(0)" onclick="removeField()" class="btn btn-danger">Remover
                        Campo
                    </a>
                    <a href="javascript:void(0)" onclick="addField()" class="btn btn-success">Añadir
                        Campo
                    </a>
                    <a href="javascript:void(0)"
                        onclick="formPostAjax('#field_form', '{{ route('fields.store') }}', '#table_fields', '#addRowModalField')"
                        class="btn btn-primary">Guardar Campos</a>
                </div>
            </form>
        </div>
    </div>
</div>

{{-- editar --}}

<div class="modal fade modal-md" id="editRowModalField" data-bs-backdrop="static" data-bs-keyboard="false"
    tabindex="-1" aria-labelledby="editRowModalFieldLabel">
    <div class="modal-dialog">
        <div class="modal-content" id="edit_modal_content_field"></div>
    </div>
</div>
