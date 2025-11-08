@extends('layouts.panel')
@section('title', 'Rencuentro de Stocks')
@section('subtitle', 'Listado de Rencuentro de Stocks')
@section('content')
    <div class="col-md-12">
        <div class="card">
            <div class="card-header">

                <div class="d-flex align-items-center row">

                    <div class="col-4">
                        <h4 class="card-title">@yield('subtitle')</h4>
                    </div>
                </div>

            </div>
            <div class="card-body">
                <div class="table-responsive">
                    <table id="table_stocks_reunion" class="display table table-striped table-hover">
                        <thead class="table-dark">
                            <tr>
                                <th>Id</th>
                                <th>Rodeo</th>
                                <th>Tipo de animal</th>
                                <th>Cantidad</th>
                                <th>Raza</th>
                                <th>Fecha</th>
                            </tr>
                        </thead>
                    </table>
                </div>
            </div>
        </div>
    </div>

@section('scripts')
    @include('stocksReunions.partials.scripts')
@endsection

@endsection
