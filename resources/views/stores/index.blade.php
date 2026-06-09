@extends('layouts.app')

@section('title', 'Negocios - Wi Cart')
@section('header_title', 'Negocios')
@section('header_description', 'Supermercados y tiendas donde compras.')

@section('header_actions')
    <button type="button" class="btn-primary" data-crud-create="store">
        <i class="fa-solid fa-plus"></i>
        Nuevo negocio
    </button>
@endsection

@section('content')
    <div class="web-table-card">
        <table id="stores-table" class="web-data-table display" style="width:100%">
            <thead>
                <tr>
                    <th>Nombre</th>
                    <th class="text-center">Acciones</th>
                </tr>
            </thead>
        </table>
    </div>

    <script>
        $(function () {
            initWebDataTable('#stores-table', {
                ajax: @json(route('stores.data')),
                columns: [
                    { data: 'name', name: 'name' },
                    { data: 'actions', name: 'actions', orderable: false, searchable: false, className: 'web-table-actions-cell text-center' },
                ],
            });
        });
    </script>
@endsection
