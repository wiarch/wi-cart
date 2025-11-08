{{-- crear --}}
<div class="modal fade modal-xl" id="addRowModalRodeo" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1"
    aria-labelledby="addRowModalRodeoLabel">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header bg-dark text-white">
                <h1 class="modal-title fs-5" id="addRowModalRodeoLabel">Agregar Rodeos</h1>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <form action="{{ route('rodeos.store') }}" method="POST" enctype="multipart/form-data" id="rodeo_form">
                @csrf
                <div class="modal-body">

                    <span class="row col-12" id="rodeo_container"></span>

                </div>
                <div class="modal-footer bg-secondary">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                    <a href="javascript:void(0)" onclick="removeRodeo()" class="btn btn-danger">Remover
                        Rodeo
                    </a>
                    <a href="javascript:void(0)" onclick="addRodeo()" class="btn btn-success">Añadir
                        Rodeo
                    </a>
                    <a href="javascript:void(0)"
                        onclick="formPostAjax('#rodeo_form', '{{ route('rodeos.store') }}', '#table_rodeos', '#addRowModalRodeo')"
                        class="btn btn-primary">Guardar Rodeos</a>
                </div>
            </form>
        </div>
    </div>
</div>

{{-- editar --}}

<div class="modal fade modal-md" id="editRowModalRodeo" data-bs-backdrop="static" data-bs-keyboard="false"
    tabindex="-1" aria-labelledby="editRowModalRodeoLabel">
    <div class="modal-dialog">
        <div class="modal-content" id="edit_modal_content_rodeo"></div>
    </div>
</div>
