@extends('layouts.panel')
@section('title', 'Insumos de Alimentación')
@section('subtitle', 'Listado de Insumos de Alimentación')
@section('content')
    <div class="col-md-12">
        <div class="card">
            <div class="card-header">
                <div class="d-flex align-items-center row">
                    <div class="col-6">
                        <h4 class="card-title">@yield('subtitle')</h4>
                    </div>
                    <div class="col-6 d-flex justify-content-end">
                        <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#createModalFoodSupply">
                            <i class="fa fa-plus"></i>
                            Agregar Insumo Alimentario
                        </button>
                    </div>
                </div>
            </div>
            <div class="card-body">
                <div class="table-responsive">
                    <table id="table_food_supplies" class="display table table-striped table-hover">
                        <thead class="table-dark">
                            <tr>
                                <th>Código de tratamiento</th>
                                <th>Stock inicial</th>
                                <th>Consumidas</th>
                                <th>Stock restante</th>
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

    @include('foodSupplies.partials.modals.index')

@section('scripts')
    @include('foodSupplies.partials.scripts')
@endsection

@endsection
