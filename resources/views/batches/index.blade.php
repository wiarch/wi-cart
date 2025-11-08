@extends('layouts.panel')
@section('title', 'Lotes')
@section('subtitle', 'Listado de Lotes')
@section('content')
    <div class="col-md-12">
        <div class="card">
            <div class="card-header">

                <div class="d-flex align-items-center row">

                    <div class="col-2">
                        <h4 class="card-title">@yield('subtitle')</h4>
                    </div>

                    <div class="col-6">
                        <select class="form__input form-control select_field" name="field">
                            <option value="0" disabled selected>Elegir un Campo</option>
                            @foreach ($fields as $field)
                                <option value="{{ $field->id }}">
                                    {{ $field->name }}</option>
                            @endforeach
                        </select>
                    </div>

                    <div class="col-4 d-flex justify-content-between">

                        <button class="btn btn-secondary ms-auto mr-5 show-all d-none">
                            <i class="fa fa-list"></i>
                            Ver todos
                        </button>

                        <button class="btn btn-primary ms-auto d-none add-batch" data-bs-toggle="modal"
                            data-bs-target="#addRowModalBatch">
                            <i class="fa fa-plus"></i>
                            Agregar Lotes
                        </button>
                    </div>
                </div>

            </div>
            <div class="card-body">
                <div class="table-responsive">
                    <table id="table_batches" class="display table table-striped table-hover">
                        <thead class="table-dark">
                            <tr>
                                <th>Id</th>
                                <th>Nombre</th>
                                <th>Superficie</th>
                                <th>Campo</th>
                                <th style="width: 10%">Acciones</th>
                            </tr>
                        </thead>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <!-- Modal -->
    @include('batches.partials.modals.index')

@section('scripts')
    @include('batches.partials.scripts')
@endsection

@endsection
