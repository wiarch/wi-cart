@extends('layouts.panel')
@section('title', 'Campos')
@section('subtitle', 'Listado de Campos')
@section('content')
    <div class="col-md-12">
        <div class="card">
            <div class="card-header">
                <div class="d-flex align-items-center">
                    <h4 class="card-title">@yield('subtitle')</h4>
                    <button class="btn btn-primary ms-auto" data-bs-toggle="modal" data-bs-target="#addRowModalField">
                        <i class="fa fa-plus"></i>
                        Agregar Campos
                    </button>
                </div>
            </div>
            <div class="card-body">
                <div class="table-responsive">
                    <table id="table_fields" class="display table table-striped table-hover">
                        <thead class="table-dark">
                            <tr>
                                <th>Id</th>
                                <th>Nombre</th>
                                <th>ubicación</th>
                                <th>Coordenadas</th>
                                <th style="width: 10%">Acciones</th>
                            </tr>
                        </thead>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <!-- Modal -->
    @include('fields.partials.modals.index')

@section('scripts')
    @include('fields.partials.scripts')
@endsection

@endsection
