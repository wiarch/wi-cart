@extends('layouts.app')

@section('title', 'Negocios - List Market')
@section('category', 'GESTIÓN DE SISTEMA')
@section('header_title', 'Negocios')
@section('header_description', 'Administra tus supermercados y tiendas habituales para organizar tus compras.')

@section('content')
    <div class="mb-8 flex justify-between items-center">
        <div class="flex-grow"></div>
        <a href="{{ route('stores.create') }}" class="btn-botanical no-underline flex items-center gap-2 py-3 px-6 text-sm">
            <i class="fa-solid fa-plus"></i>
            Nuevo Negocio
        </a>
    </div>

    <div class="botanical-card p-6 overflow-hidden">
        <div class="overflow-x-auto">
            <table id="stores-table" class="w-full text-left border-collapse display responsive nowrap" style="width:100%">
                <thead>
                    <tr class="bg-surface-container-low/50">
                        <th class="px-6 py-4 text-primary uppercase tracking-[0.2em]">Nombre</th>
                        <th class="px-6 py-4 text-primary uppercase tracking-[0.2em] text-center">Acciones</th>
                    </tr>
                </thead>
                <tbody class="divide-y divide-surface-container-low">
                </tbody>
            </table>
        </div>
    </div>

    <script>
        $(document).ready(function() {
            $('#stores-table').DataTable({
                processing: true,
                serverSide: true,
                responsive: true,
                ajax: "{{ route('stores.data') }}",
                columns: [
                    { data: 'name', name: 'name', className: 'px-6 py-5 text-base font-bold text-on-surface' },
                    { data: 'actions', name: 'actions', orderable: false, searchable: false, className: 'px-6 py-5 text-center text-base' }
                ],
                columnDefs: [
                    { targets: 1, className: 'text-center' }
                ],
                language: {
                    url: "{{ asset('js/lib/datatables/spanish.json') }}"
                },
                drawCallback: function() {
                    $('.dataTables_paginate > a').addClass('btn-botanical text-xs px-3 py-2 mx-1 no-underline');
                }
            });
        });
    </script>
@endsection
