@extends('layouts.panel')
@section('title', 'Insumos')
@section('subtitle', 'Listado de Insumos')
@section('content')
    <div class="col-md-12">
        <div class="card">
            <div class="card-header">
                <div class="d-flex align-items-center row">
                    <div class="col-6">
                        <h4 class="card-title">@yield('subtitle')</h4>
                    </div>
                    <div class="col-6 d-flex justify-content-end">
                        <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#createModalSupply">
                            <i class="fa fa-plus"></i>
                            Agregar Insumo
                        </button>
                    </div>
                </div>
            </div>
            <div class="card-body">
                <div class="table-responsive">
                    <table id="table_supplies" class="display table table-striped table-hover">
                        <thead class="table-dark">
                            <tr>
                                <th>Insumo</th>
                                <th>Cantidad</th>
                                <th>UMedida</th>
                                <th>Fecha</th>
                                <th>Lote</th>
                                <th style="width: 10%">Acciones</th>
                            </tr>
                        </thead>
                        <tbody>
                            {{-- El contenido será gestionado por DataTables cuando se defina el endpoint --}}
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    @include('supplies.partials.modals.index')

@section('scripts')
    @include('supplies.partials.scripts')
@endsection

@endsection
