@extends('layouts.panel')
@section('title', 'Raciónes')
@section('subtitle', 'Listado de Raciónes')
@section('content')
    <div class="col-md-12">
        <div class="card">
            <div class="card-header">
                <div class="d-flex align-items-center row">

                    <div class="col-6">
                        <h4 class="card-title">@yield('subtitle')</h4>
                    </div>

                    <div class="col-6 d-flex justify-content-end mt-4">
                        <button class="btn btn-primary ms-auto add-reason" data-bs-toggle="modal"
                            data-bs-target="#createModalReason">
                            <i class="fa fa-plus"></i>
                            Agregar Racion
                        </button>
                    </div>
                </div>
            </div>
            <div class="card-body">
                <div class="table-responsive">
                    <table id="table_reasons" class="display table table-striped table-hover">
                        <thead class="table-dark">
                            <tr>
                                <th>Id</th>
                                <th>Rodeo</th>
                                <th>Alimentación</th>
                                <th>Detalle</th>
                                <th>Porción</th>
                                <th style="width: 10%">Acciones</th>
                            </tr>
                        </thead>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <!-- Modal -->
    @include('reasons.partials.modals.index')

@section('scripts')
    @include('reasons.partials.scripts')
@endsection

@endsection
