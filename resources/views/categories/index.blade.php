@extends('layouts.app')

@section('title', 'Categorías - Wi Cart')
@section('header_title', 'Categorías')
@section('header_description', 'Administra las categorías de productos.')

@section('header_actions')
    <button type="button" class="btn-primary" data-crud-create="category">
        <i class="fa-solid fa-plus"></i>
        Nueva categoría
    </button>
@endsection

@section('content')
    <div class="web-table-card">
        <table id="categories-table" class="web-data-table display" style="width:100%">
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
            initWebDataTable('#categories-table', {
                ajax: @json(route('categories.data')),
                columns: [
                    { data: 'name', name: 'name' },
                    { data: 'actions', name: 'actions', orderable: false, searchable: false, className: 'web-table-actions-cell text-center' },
                ],
            });
        });
    </script>
@endsection
