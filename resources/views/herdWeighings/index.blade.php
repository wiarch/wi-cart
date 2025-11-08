@extends('layouts.panel')
@section('title', 'Control de Peso')
@section('subtitle', 'Listado de Pesajes de Rodeo')
@section('content')
    <div class="col-md-12">
        <div class="card">
            <div class="card-header">
                <div class="d-flex align-items-center row">
                    <div class="col-6">
                        <h4 class="card-title">@yield('subtitle')</h4>
                    </div>
                    <div class="col-6 d-flex justify-content-end">
                        <!-- Filtros por rango de fechas -->
                        <div class="d-flex gap-2 align-items-center">
                            <div>
                                <label class="form-label mb-0 small">Desde</label>
                                <input type="date" id="filter_date_from" class="form-control form-control-sm" />
                            </div>
                            <div>
                                <label class="form-label mb-0 small">Hasta</label>
                                <input type="date" id="filter_date_to" class="form-control form-control-sm" />
                            </div>
                            <button class="btn btn-sm btn-secondary" id="btn_clear_filters">Mostrar todos</button>
                        </div>
                    </div>
                </div>
            </div>
            <div class="card-body">
                <div class="row mb-3">
                    <div class="col-md-3">
                        <div class="border rounded p-2 bg-light">
                            <div class="small text-muted">PROMEDIO (kg)</div>
                            <div id="avg_weight_label" class="fw-bold">-</div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="border rounded p-2 bg-light">
                            <div class="small text-muted">GDP (kg/día)</div>
                            <div id="gdp_label" class="fw-bold">-</div>
                        </div>
                    </div>
                </div>
                <div class="table-responsive">
                    <table id="table_herd_weighings" class="display table table-striped table-hover">
                        <thead class="table-dark">
                            <tr>
                                <th>Fecha de pesaje</th>
                                <th>Categoría (ID)</th>
                                <th>VID/EID</th>
                                <th>Peso (kg)</th>
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

@section('scripts')
    @include('herdWeighings.partials.scripts')
@endsection

@endsection
