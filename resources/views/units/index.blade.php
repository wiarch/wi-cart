@extends('layouts.app')

@section('title', 'Unidades - Wi Cart')
@section('header_title', 'Unidades')
@section('header_description', 'Medidas y presentaciones de productos.')

@section('header_actions')
    <button type="button" class="btn-primary" data-crud-create="unit">
        <i class="fa-solid fa-plus"></i>
        Nueva unidad
    </button>
@endsection

@section('content')
    <div class="web-table-card">
        <table id="units-table" class="web-data-table display" style="width:100%">
            <thead>
                <tr>
                    <th>Unidad</th>
                    <th class="text-center">Acciones</th>
                </tr>
            </thead>
        </table>
    </div>

    <script>
        $(function () {
            initWebDataTable('#units-table', {
                ajax: @json(route('units.data')),
                columns: [
                    { data: 'name', name: 'name' },
                    { data: 'actions', name: 'actions', orderable: false, searchable: false, className: 'web-table-actions-cell text-center' },
                ],
            });
        });
    </script>
@endsection
