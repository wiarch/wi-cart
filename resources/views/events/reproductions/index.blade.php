@extends('layouts.panel')
@section('title', 'Reproducción')
@section('subtitle', 'Listado de Reproducción')
@section('content')

    <style>
        .text-tacto {
            color: #FEEE00 !important;
        }

        .text-parto {
            color: #F1782F !important;
        }

        .text-pre-servicio {
            color: #4B972C !important;
        }

        .text-ecografia {
            color: #9DC4ED !important;
        }
    </style>
    <div class="col-md-12">
        <div class="card">
            <div class="card-header">
                <div class="d-flex align-items-center row">

                    <div class="col-3">
                        <h4 class="car d-title">@yield('subtitle')</h4>
                    </div>

                    <div class="col-3">
                        <label class="form__label">Campo</label>
                        <select class="form__input form-control" id="select_field_filter" name="field">
                            <option value="0" disabled selected>Elegir un Campo</option>
                        </select>
                    </div>

                    <div class="col-md-3">
                        <label class="form__label">Rodeo</label>
                        <select class="form__input form-control" id="select_rodeo_filter" name="rodeo_id">
                            <option value="" selected disabled>Seleccionar un campo</option>
                        </select>
                    </div>

                    <div class="col-md-3">
                        <label class="form__label">Caravana</label>
                        <select class="form__input form-control" id="select_stocks_filter" name="stock_id">
                            <option value="" selected disabled>Seleccione un rodeo</option>
                        </select>
                    </div>

                    <div class="col-md-12 d-flex justify-content-end mt-4">
                        <button class="btn btn-secondary mr-4 show-all">
                            <i class="fa fa-list"></i>
                            Ver todo
                        </button>


                        <!-- Botón visual -->
                        <a href="javascript:void(0);" class="btn btn-success mr-4 import-table-btn">
                            <i class="fa fa-file-excel"></i> Importar Registros
                        </a>

                        <!-- Input de archivo oculto -->
                        <input type="file" name="file" accept=".xlsx,.xls,.csv" class="d-none import-table-input">

                        <a href="{{ route('reproductions.export') }}" class="btn btn-warning mr-4 export-table">
                            <i class="fa fa-file-excel"></i> Exportar Tabla
                        </a>

                        <button class="btn btn-primary add-reproduction" data-bs-toggle="modal"
                            data-bs-target="#createModalReproduction">
                            <i class="fa fa-plus"></i>
                            Agregar Evento
                        </button>
                    </div>
                </div>
            </div>
            <div class="card-body">
                <div class="table-responsive">
                    <table id="table_reproductions" class="display table table-stripe.vbv d table-hover">
                        <thead class="table-dark">
                            <!-- Primera fila: títulos generales -->
                            <tr>
                                <th rowspan="2">Id</th>
                                <th rowspan="2">Caravana</th>
                                <th rowspan="2">Categoria</th>

                                <th colspan="5" class="text-parto text-center">Parto</th>
                                <th colspan="5" class="text-pre-servicio text-center">Pre-Servicio</th>
                                <th colspan="3" class="text-ecografia text-center">Ecografía</th>
                                <th colspan="4" class="text-tacto text-center">Tacto</th>
                            </tr>
                            <!-- Segunda fila: títulos individuales -->
                            <tr>
                                <!-- Parto -->
                                <th class="text-parto">Fecha</th>
                                <th class="text-parto">Sexo</th>
                                <th class="text-parto">Peso</th>
                                <th class="text-parto">Obs.</th>
                                <th class="text-parto">Diagnóstico</th>

                                <!-- Pre-Servicio -->
                                <th class="text-pre-servicio">Fecha</th>
                                <th class="text-pre-servicio">Diagnóstico</th>
                                <th class="text-pre-servicio">CC</th>
                                <th class="text-pre-servicio">Fecha de inseminación</th>
                                <th class="text-pre-servicio">Toro</th>

                                <!-- Ecografía -->
                                <th class="text-ecografia">Fecha</th>
                                <th class="text-ecografia">Diagnóstico</th>
                                <th class="text-ecografia">CC</th>

                                <!-- Tacto -->
                                <th class="text-tacto">Fecha</th>
                                <th class="text-tacto">Diagnóstico</th>
                                <th class="text-tacto">CC</th>
                                <th>Acciones</th>
                            </tr>
                        </thead>
                    </table>

                </div>
            </div>
        </div>
    </div>

    @include('events.reproductions.partials.modals.index')

@section('scripts')
    @include('events.reproductions.partials.scripts')
@endsection

@endsection
