{{-- Estilos y librería de Leaflet --}}
<link href="{{ asset('libs/leaflet/leaflet.css') }}" rel="stylesheet">
<script src="{{ asset('libs/leaflet/leaflet.js') }}"></script>

<script>
    // Variables globales para controlar inputs y mapa
    let selectedInputId = null; // Input donde se guardará la dirección
    let selectedCoordsId = null; // Input donde se guardarán las coordenadas
    let mapInitialized = false; // Controla si el mapa ya fue inicializado
    let map, marker;

    /**
     * Evento click en botones con clase .btn-geolocalizar
     * Abre el modal con el mapa y permite seleccionar ubicación.
     */
    $(document).on('click', '.btn-geolocalizar', function() {
        // Identificadores de inputs donde guardar dirección y coordenadas
        selectedInputId = $(this).data('input-location-id');
        selectedCoordsId = $(this).data('input-coordinate-id');

        // Mostrar modal del mapa
        $('#mapModal').modal('show');

        // Timeout para asegurar que el modal se renderice correctamente antes de cargar el mapa
        setTimeout(() => {
            if (!mapInitialized) {
                // Inicializa mapa centrado en Argentina (ejemplo). Cambia según tu necesidad.
                map = L.map('map').setView([-38.4161, -63.6167], 5);

                // Carga de tiles (mapa base)
                L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
                    attribution: '&copy; OpenStreetMap contributors'
                }).addTo(map);

                // Evento: click sobre el mapa
                map.on('click', function(e) {
                    // Elimina marcador previo (si existe)
                    if (marker) map.removeLayer(marker);

                    // Crea nuevo marcador
                    marker = L.marker(e.latlng).addTo(map);

                    // Obtiene coordenadas seleccionadas
                    const lat = e.latlng.lat.toFixed(6);
                    const lng = e.latlng.lng.toFixed(6);

                    // Guarda coordenadas en el input correspondiente
                    $(`#${selectedCoordsId}`).val(`${lat},${lng}`);

                    // Muestra loader mientras busca dirección
                    $('#map-loader').removeClass('d-none');

                    // Llama a la función de geocodificación inversa
                    reverseGeocode(lat, lng, function(address) {
                        // Guarda dirección en input
                        $(`#${selectedInputId}`).val(address);

                        // Oculta loader y cierra modal
                        $('#map-loader').addClass('d-none');
                        $('#mapModal').modal('hide');
                    });
                });

                mapInitialized = true;
            } else {
                // Recalcula tamaño al reabrir modal
                map.invalidateSize();
            }
        }, 300);
    });

    /**
     * Geocodificación inversa: obtiene dirección a partir de lat/lng
     * usando la API pública de Nominatim (OpenStreetMap).
     *
     * @param {number} lat - Latitud seleccionada
     * @param {number} lon - Longitud seleccionada
     * @param {function} callback - Función a ejecutar con la dirección resultante
     */
    function reverseGeocode(lat, lon, callback) {
        const url = `https://nominatim.openstreetmap.org/reverse?lat=${lat}&lon=${lon}&format=json`;

        fetch(url, {
                headers: {
                    'Accept-Language': 'es', // Devuelve dirección en español
                    'User-Agent': 'proganadero-app' // Identificador para evitar bloqueos
                }
            })
            .then(response => response.json())
            .then(data => {
                // Si la API devuelve dirección, úsala; si no, fallback a coords
                callback(data && data.display_name ? data.display_name : `${lat}, ${lon}`);
            })
            .catch(() => {
                // En caso de error, devuelve solo coords
                callback(`${lat}, ${lon}`);
            });
    }
</script>

<!-- Modal para selección de ubicación con Leaflet -->
<div class="modal fade" id="mapModal" tabindex="-1" aria-labelledby="mapLabel">
    <div class="modal-dialog modal-xl">
        <div class="modal-content">
            <!-- Header del modal -->
            <div class="modal-header">
                <h5 class="modal-title">Selecciona la ubicación</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Cerrar"></button>
            </div>
            <!-- Body del modal con mapa y loader -->
            <div class="modal-body position-relative">
                <div id="map" style="height: 600px;"></div> <!-- Contenedor del mapa -->

                <!-- Loader mientras se busca dirección -->
                <div id="map-loader"
                    class="position-absolute top-50 start-50 translate-middle d-none text-white text-center">
                    <div class="spinner-border text-light" role="status"></div>
                    <div class="mt-2">Buscando dirección...</div>
                </div>
            </div>
        </div>
    </div>
</div>
