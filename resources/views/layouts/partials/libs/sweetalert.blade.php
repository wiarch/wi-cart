{{-- Estilos y librería SweetAlert2 --}}
<link href="{{ asset('libs/sweetalert/sweetalert.min.css') }}" rel="stylesheet">
<script src="{{ asset('libs/sweetalert/sweetalert.all.min.js') }}"></script>

<script>
    @php
        // Tipos de alerta estándar disponibles
        $alertTypes = ['success', 'error', 'info', 'warning'];
        $activeAlert = null;

        // Busca si hay alguna alerta activa en sesión
        foreach ($alertTypes as $type) {
            if (session()->has($type)) {
                $activeAlert = $type;
                break;
            }
        }

        // Variables para alerta de confirmación (opcional)
        $confirmAlert = session('confirm_alert', false); // true o false
        $confirmTitle = session('confirm_title', 'Confirmación');
        $confirmText = session('confirm_text', '¿Deseas continuar?');
    @endphp

    {{-- Renderiza una alerta de notificación (si existe en sesión) --}}
    @if ($activeAlert)
        Swal.fire({
            title: @json(session('title', 'Notificación')), // Título configurable
            text: @json(session($activeAlert)), // Mensaje de la alerta
            icon: '{{ $activeAlert }}', // Tipo de icono dinámico
            showConfirmButton: false,
            timer: 4000,
            timerProgressBar: true,
            toast: true,
            position: 'top-end',
            didOpen: (toast) => {
                // Pausar reanudación del temporizador al pasar el mouse
                toast.addEventListener('mouseenter', Swal.stopTimer);
                toast.addEventListener('mouseleave', Swal.resumeTimer);
            }
        });
    @endif

    {{-- Renderiza una alerta de confirmación (si existe en sesión) --}}
    @if ($confirmAlert)
        Swal.fire({
            title: @json($confirmTitle),
            html: @json($confirmText), // Usamos html en lugar de text para soportar formato enriquecido
            icon: 'info',
            showConfirmButton: true,
            showDenyButton: false,
            reverseButtons: true,
            confirmButtonColor: '#3085d6',
            confirmButtonText: 'Aceptar',
        }).then((result) => {
            if (result.isConfirmed) {
                // Acción si el usuario confirma
            } else if (result.isDenied) {
                // Acción si el usuario niega
            }
        });
    @endif


    /**
     * Muestra una alerta SweetAlert2 y ejecuta acciones dinámicas al cerrarse.
     *
     * @param {string} title   - Título de la alerta.
     * @param {string} text    - Texto del cuerpo de la alerta.
     * @param {string} icon    - Icono de la alerta ('success', 'error', 'warning', 'info', 'question').
     * @param {string|null} type  - Tipo de acción posterior ('table', 'modal' o null).
     * @param {string|null} table - ID o clase de la DataTable a recargar (si aplica).
     * @param {string|null} modal - ID del modal a cerrar (si aplica).
     * @param {boolean} [confirm=false] - Define si es una alerta de confirmación.
     *
     * @returns {Promise} - Si es confirmación, devuelve una promesa para manejar el resultado.
     */
    function dinamicSweetAlert(title, text, icon, type = null, table = null, modal = null, confirm = false) {

        if (confirm) {
            // Alerta con confirmación/denegación
            return Swal.fire({
                title: title,
                text: text,
                icon: icon,
                showConfirmButton: true,
                showDenyButton: true,
                reverseButtons: true,
                confirmButtonColor: '#3085d6',
                confirmButtonText: 'Sí, Aceptar',
                denyButtonText: 'No, Cancelar',
            });
        } else {
            // Alerta informativa (toast estilo notificación)
            Swal.fire({
                title: title,
                text: text,
                icon: icon,
                showConfirmButton: false,
                timer: 4000,
                timerProgressBar: true,
                toast: true,
                position: 'top-end',
            }).then(() => {
                // Ejecutar acciones automáticas después del cierre
                if (type === 'table' && table) {
                    // Recargar DataTable
                    $(table).DataTable().ajax.reload();
                } else if (type === 'modal' && modal) {
                    // Cerrar modal
                    $(modal).modal('toggle');
                }
            });
        }
    }
</script>
