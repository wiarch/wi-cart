@extends('layouts.panel')
@section('title', 'Pastoreos')
@section('subtitle', 'Listado de Pastoreos')
@section('content')
    <div class="col-md-12">
        <div class="card">
            <div class="card-header">

                <div class="d-flex align-items-center row">

                    <div class="col-2">
                        <h4 class="card-title">@yield('subtitle')</h4>
                    </div>

                    <div class="col-6">
                        <select class="form__input form-control select_rodeo" name="rodeo">
                            <option value="0" disabled selected>Elegir un Rodeo</option>
                            @foreach ($rodeos as $rodeo)
                                <option value="{{ $rodeo->id }}">
                                    {{ $rodeo->name }}</option>
                            @endforeach
                        </select>
                    </div>

                    <div class="col-4 d-flex justify-content-between">

                        <button class="btn btn-secondary ms-auto mr-5 show-all d-none">
                            <i class="fa fa-list"></i>
                            Ver todos
                        </button>

                        <button class="btn btn-primary ms-auto d-none add-grazing" data-bs-toggle="modal"
                            data-bs-target="#createModalGrazing">
                            <i class="fa fa-plus"></i>
                            Agregar Pastoreos
                        </button>
                    </div>
                </div>

            </div>
            <div class="card-body">
                <div class="table-responsive">
                    <table id="table_grazings" class="display table table-striped table-hover">
                        <thead class="table-dark">
                            <tr>
                                <th>Id</th>
                                <th>Rodeo</th>
                                <th>Lote</th>
                                <th>Superficie</th>
                                <th>Region</th>
                                <th>Base de recurso</th>
                                <th>Tipo de pastoreo</th>
                                <th>Entrada</th>
                                <th>Salida</th>
                                <th style="width: 10%">Acciones</th>
                            </tr>
                        </thead>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <!-- Modal -->
    @include('grazings.partials.modals.index')

@section('scripts')
    @include('grazings.partials.scripts')
@endsection

@endsection
