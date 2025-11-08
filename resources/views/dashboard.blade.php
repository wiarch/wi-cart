@extends('layouts.panel')

@section('title', 'Panel')

@section('content')
    <style>
        #map {
            height: 100vh;
            width: 100%;
        }
    </style>

    <div id="map"></div>

    {{-- Carga del script de Google Maps --}}
    <script
        src="https://maps.googleapis.com/maps/api/js?key={{ config('services.google_maps.api_key') }}&callback=initMap&libraries=places"
        async defer></script>

    <script>
        function initMap() {
            const argentina = {
                lat: -37.098423,
                lng: -59.836359
            };

            const map = new google.maps.Map(document.getElementById("map"), {
                zoom: 7,
                center: argentina,
                mapTypeId: 'hybrid' // roadmap, satellite, hybrid, terrain
            });

            new google.maps.Marker({
                position: argentina,
                map,
                title: "Argentina, Buenos Aires"
            });
        }
    </script>
@endsection
