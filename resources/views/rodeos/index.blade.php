@extends('layouts.panel')
@section('title', 'Rodeos')
@section('subtitle', 'Listado de Rodeos')
@section('content')
    <div class="col-md-12">
        <div class="card">
            <div class="card-header">
                <div class="d-flex align-items-center">
                    <h4 class="card-title">@yield('subtitle')</h4>
                    <button class="btn btn-primary ms-auto" data-bs-toggle="modal" data-bs-target="#addRowModalRodeo">
                        <i class="fa fa-plus"></i>
                        Agregar Rodeos
                    </button>
                </div>
            </div>
            <div class="card-body">
                <div class="table-responsive">
                    <table id="table_rodeos" class="display table table-striped table-hover">
                        <thead class="table-dark">
                            <tr>
                                <th>Id</th>
                                <th>Nombre</th>
                                <th>Campo</th>
                                <th>Lote</th>
                                <th>Region</th>
                                <th>Servicio</th>
                                <th>Raza</th>
                                <th style="width: 10%">Acciones</th>
                            </tr>
                        </thead>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <!-- Modal -->
    @include('rodeos.partials.modals.index')

@section('scripts')
    @include('rodeos.partials.scripts')
@endsection

@endsection
