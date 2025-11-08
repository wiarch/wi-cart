@extends('layouts.panel')
@section('title', 'Bajas')
@section('subtitle', 'Listado de Sanitarios')
@section('content')
    <div class="col-md-12">
        <div class="card">
            <div class="card-header">
                <div class="d-flex align-items-center row">

                    <div class="col-2">
                        <h4 class="card-title">@yield('subtitle')</h4>
                    </div>

                    <div class="col-2">
                        <label class="form__label">Tipo de sanitario</label>
                        <select class="form__input form-control select_type_sanitary" name="type_sanitary">
                            <option value="null" disabled selected>Elegir un tipo</option>
                            <option value="0">Colectivo</option>
                            <option value="1">Individual</option>
                        </select>
                    </div>

                    <div class="col-md-2">
                        <label class="form__label">Rodeo</label>
                        <select class="form__input form-control" id="select_rodeo_filter" name="rodeo_id">
                            <option value="" selected disabled>Buscar rodeo</option>
                        </select>
                    </div>

                    <div class="col-md-2">
                        <label class="form__label">Stock</label>
                        <select class="form__input form-control" id="select_stocks_filter" name="stock_id">
                            <option value="" selected disabled>Seleccione un rodeo primero</option>
                        </select>
                    </div>

                    <div class="col-md-4 d-flex justify-content-end mt-4">
                        <button class="btn btn-secondary mr-4 show-all">
                            <i class="fa fa-list"></i>
                            Ver todo
                        </button>

                        <button class="btn btn-primary ms-auto add-sanitary" data-bs-toggle="modal"
                            data-bs-target="#createModalSanitary">
                            <i class="fa fa-plus"></i>
                            Agregar Evento
                        </button>
                    </div>
                </div>
            </div>
            <div class="card-body">
                <div class="table-responsive">
                    <table id="table_sanitary" class="display table table-striped table-hover">
                        <thead class="table-dark">
                            <tr>
                                <th>Id</th>
                                <th>Campo</th>
                                <th>Rodeo</th>
                                <th>Caravana</th>
                                <th>Codigo de Tratamiento</th>
                                <th>Categoría</th>
                                <th>Tipo</th>
                                <th>Dosis</th>
                                <th>N° de serie</th>
                                <th>Fecha de Vencimiento</th>
                                <th>Marca</th>
                                <th>Retiro</th>
                                <th>Diagnóstico</th>
                                <th>Observacion</th>
                                <th>Fecha</th>
                                <th style="width: 10%">Acciones</th>
                            </tr>
                        </thead>
                    </table>
                </div>
            </div>
        </div>
    </div>

    @include('events.sanitary.partials.modals.index')

@section('scripts')
    @include('events.sanitary.partials.scripts')
@endsection

@endsection
