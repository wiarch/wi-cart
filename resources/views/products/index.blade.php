@extends('layouts.app')

@section('title', 'Productos - Wi Cart')
@section('header_title', 'Productos')
@section('header_description', 'Catálogo de productos reutilizables en tus listas.')

@section('header_actions')
    <button type="button" class="btn-primary" data-crud-create="product">
        <i class="fa-solid fa-plus"></i>
        Nuevo producto
    </button>
@endsection

@section('content')
    <div class="web-table-card">
        <table id="products-table" class="web-data-table display" style="width:100%">
            <thead>
                <tr>
                    <th>Nombre</th>
                    <th>Categoría</th>
                    <th>Unidad</th>
                    <th>Negocio</th>
                    <th>Precio</th>
                    <th class="text-center">Acciones</th>
                </tr>
            </thead>
        </table>
    </div>

    <script>
        $(function () {
            initWebDataTable('#products-table', {
                ajax: @json(route('products.data')),
                columns: [
                    { data: 'name', name: 'name' },
                    { data: 'category_name', name: 'category.name', orderable: false, searchable: false },
                    { data: 'unit_name', name: 'unit.name', orderable: false, searchable: false },
                    { data: 'store_name', name: 'store.name', orderable: false, searchable: false },
                    { data: 'price', name: 'price', searchable: false },
                    { data: 'actions', name: 'actions', orderable: false, searchable: false, className: 'web-table-actions-cell text-center' },
                ],
            });
        });
    </script>
@endsection
