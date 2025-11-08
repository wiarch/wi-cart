@extends('layouts.panel')
@section('title', 'Insumos Veterinarios')
@section('subtitle', 'Listado de Insumos Veterinarios')
@section('content')
    <div class="col-md-12">
        <div class="card">
            <div class="card-header">
                <div class="d-flex align-items-center row">
                    <div class="col-6">
                        <h4 class="card-title">@yield('subtitle')</h4>
                    </div>
                    <div class="col-6 d-flex justify-content-end">
                        <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#createModalVeterinarySupply">
                            <i class="fa fa-plus"></i>
                            Agregar Insumo Veterinario
                        </button>
                    </div>
                </div>
            </div>
            <div class="card-body">
                <div class="table-responsive">
                    <table id="table_veterinary_supplies" class="display table table-striped table-hover">
                        <thead class="table-dark">
                            <tr>
                                <th>Código de tratamiento</th>
                                <th>Stock inicial</th>
                                <th>Stock final</th>
                                <th>Consumidas</th>
                                <th style="width: 10%">Acciones</th>
                            </tr>
                        </thead>
                        <tbody>
                            {{-- DataTables --}}
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    @include('veterinarySupplies.partials.modals.index')

@section('scripts')
    @include('veterinarySupplies.partials.scripts')
@endsection

@endsection
