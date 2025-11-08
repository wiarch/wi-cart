@extends('layouts.panel')
@section('title', 'Stocks')
@section('subtitle', 'Listado de Stocks')
@section('content')
    <div class="col-md-12">
        <div class="card">
            <div class="card-header">
                <div class="d-flex align-items-center row">

                    <div class="col-2">
                        <h4 class="card-title">@yield('subtitle')</h4>
                    </div>

                    <div class="col-5">
                        <select class="form__input form-control select_field" name="field">
                            <option value="0" disabled selected>Elegir un Campo</option>
                            @foreach ($fields as $field)
                                <option value="{{ $field->id }}">
                                    {{ $field->name }}</option>
                            @endforeach
                        </select>
                    </div>
                    <div class="col-5">
                        <select class="form__input form-control select_rodeo" disabled name="rodeo">
                        </select>
                    </div>

                    <div class="col-12 d-flex justify-content-end mt-4">

                        <button class="btn btn-secondary mr-4 show-all d-none">
                            <i class="fa fa-list"></i>
                            Ver todo
                        </button>

                        <!-- Botón visual -->
                        <a href="javascript:void(0);" class="btn btn-success mr-4 import-table-btn">
                            <i class="fa fa-file-excel"></i> Importar Stocks
                        </a>

                        <!-- Input de archivo oculto -->
                        <input type="file" name="file" accept=".xlsx,.xls,.csv" class="d-none import-table-input">

                        <a href="{{ route('stocks.export') }}" class="btn btn-warning mr-4 export-table">
                            <i class="fa fa-file-excel"></i> Exportar Tabla
                        </a>

                        <button class="btn btn-info mr-4 transfer-all d-none" title="Transferir todo" data-bs-toggle="modal"
                            data-bs-target="#transferRowModalStock">
                            <i class="fa fa-arrow-right-arrow-left"></i>
                            Transferir todo
                        </button>

                        <button class="btn btn-danger mr-4 transfer-selected d-none" title="Transferir seleccionados"
                            data-bs-toggle="modal" data-bs-target="#transferRowModalStock">
                            <i class="fa fa-arrow-right-arrow-left"></i>
                            <input type="hidden" class="selected_stock_ids">
                            Transferir seleccionados
                        </button>

                        <button class="btn btn-primary add-stock d-none" data-bs-toggle="modal"
                            data-bs-target="#addRowModalStock">
                            <i class="fa fa-plus"></i>
                            Agregar Stocks
                        </button>

                    </div>

                </div>
            </div>
            <div class="card-body">
                <div class="table-responsive">
                    <table id="table_stocks" class="display table table-striped table-hover">
                        <thead class="table-dark">
                            <tr>
                                <th>Seleccionar</th>
                                <th>N° de IDV</th>
                                <th>N° de EID</th>
                                <th>Campo</th>
                                <th>Rodeo</th>
                                <th>Lote</th>
                                <th>Tipo</th>
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
    @include('stocks.partials.modals.index')

@section('scripts')
    @include('stocks.partials.scripts')
@endsection

@endsection
