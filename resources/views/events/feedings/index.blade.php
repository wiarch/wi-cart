@extends('layouts.panel')
@section('title', 'Pesada')
@section('subtitle', 'Listado de Pesadas')
@section('content')
    <div class="col-md-12">
        <div class="card">
            <div class="card-header">
                <div class="d-flex align-items-center row">

                    <div class="col-3">
                        <h4 class="card-title">@yield('subtitle')</h4>
                    </div>
                    <div class="col-md-2">
                        <label class="form__label">Rodeo</label>
                        <select class="form__input form-control" id="select_rodeo_filter" name="rodeo_id">
                            <option value="" selected disabled>Seleccione un rodeo</option>
                        </select>
                    </div>

                    <div class="col-md-3">
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

                        <button class="btn btn-primary ms-auto add-feeding" data-bs-toggle="modal"
                            data-bs-target="#createModalFeeding">
                            <i class="fa fa-plus"></i>
                            Agregar Evento
                        </button>
                    </div>
                </div>
            </div>
            <div class="card-body">
                <div class="table-responsive">
                    <table id="table_feedings" class="display table table-striped table-hover">
                        <thead class="table-dark">
                            <tr>
                                <th>Id</th>
                                <th>Rodeo</th>
                                <th>Identificador</th>
                                <th>Peso</th>
                                <th>Fecha</th>
                                <th style="width: 10%">Acciones</th>
                            </tr>
                        </thead>
                    </table>
                </div>
            </div>
        </div>
    </div>

    @include('events.feedings.partials.modals.index')

@section('scripts')
    @include('events.feedings.partials.scripts')
@endsection

@endsection
