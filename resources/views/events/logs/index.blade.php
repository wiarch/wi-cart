@extends('layouts.panel')
@section('title', 'Historial')
@section('subtitle', 'Listado de Historial')
@section('content')
    <div class="col-md-12">
        <div class="card">
            <div class="card-header">
                <div class="d-flex align-items-center row">

                    <div class="col-3">
                        <h4 class="card-title">@yield('subtitle')</h4>
                    </div>

                    <div class="col-2">
                        <select class="form__input form-control select_module" name="module">
                            <option value="0" disabled selected>Elegir un Modulo</option>
                            @foreach ($modules as $module)
                                <option value="{{ $module->id }}">
                                    {{ $module->name }}</option>
                            @endforeach
                        </select>
                    </div>
                </div>
            </div>
            <div class="card-body">
                <div class="table-responsive">
                    <table id="table_history" class="display table table-striped table-hover">
                        <thead class="table-dark">
                            <tr>
                                <th>Id</th>
                                <th>Descripción</th>
                                <th>Modulo</th>
                                <th>Fecha</th>
                                <th style="width: 10%">Acciones</th>
                            </tr>
                        </thead>
                    </table>
                </div>
            </div>
        </div>
    </div>

    @include('events.logs.partials.modals.index')

@section('scripts')
    @include('events.logs.partials.scripts')
@endsection

@endsection
