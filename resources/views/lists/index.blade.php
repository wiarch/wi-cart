@extends('layouts.app')

@section('title', 'Mis listas - Wi Cart')
@section('header_inside_card', '')

@section('content')
    <div class="web-table-card">
        <div class="web-table-card-header">
            <div>
                <h1 class="web-page-title">Mis listas</h1>
                <p class="web-page-subtitle">Gestiona tus listas de compra y artículos.</p>
            </div>
            <div class="flex items-center gap-2 flex-wrap">
                <button type="button" class="btn-primary" data-crud-create="list">
                    <i class="fa-solid fa-plus"></i>
                    Nueva lista
                </button>
            </div>
        </div>
        <table id="lists-table" class="web-data-table display" style="width:100%">
            <thead>
                <tr>
                    <th>Nombre</th>
                    <th>Estado</th>
                    <th>Artículos</th>
                    <th>Pendientes</th>
                    <th>Actualizada</th>
                    <th class="text-center">Acciones</th>
                </tr>
            </thead>
        </table>
    </div>

    <script>
        $(function () {
            initWebDataTable('#lists-table', {
                ajax: @json(route('lists.data')),
                columns: [
                    { data: 'name', name: 'name' },
                    { data: 'status', name: 'status', orderable: false, searchable: false },
                    { data: 'items_count', name: 'items_count', searchable: false },
                    { data: 'pending_items_count', name: 'pending_items_count', searchable: false },
                    { data: 'updated_at', name: 'updated_at' },
                    { data: 'actions', name: 'actions', orderable: false, searchable: false, className: 'web-table-actions-cell text-center' },
                ],
            });
        });
    </script>
@endsection
