@extends('layouts.panel')
@section('title', 'Recría y Terminación')
@section('subtitle', 'Listado de Recría y Terminación')
@section('content')
    <div class="col-md-12">
        <div class="card">
            <div class="card-header">
                <div class="d-flex align-items-center row">

                    <div class="col-6">
                        <h4 class="card-title">@yield('subtitle')</h4>
                    </div>

                    <div class="col-6 d-flex justify-content-end mt-4">
                        <button class="btn btn-primary ms-auto add-termination" data-bs-toggle="modal"
                            data-bs-target="#createModalTermination">
                            <i class="fa fa-plus"></i>
                            Agregar Recría y Terminación
                        </button>
                    </div>
                </div>
            </div>
            <div class="card-body">
                <div class="table-responsive">
                    <table id="table_terminations" class="display table table-striped table-hover">
                        <thead class="table-dark">
                            <tr>
                                <th>Id</th>
                                <th>Nombre de Alimentación</th>
                                <th>Tipo</th>
                                <th>CMS</th>
                                <th>PV</th>
                                <th>GPD en KG</th>
                                <th>Animales</th>
                                <th>Dias</th>
                                <th>Fecha</th>
                                <th style="width: 10%">Acciones</th>
                            </tr>
                        </thead>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <!-- Modal -->
    @include('terminations.partials.modals.index')

@section('scripts')
    @include('terminations.partials.scripts')
@endsection

@endsection
