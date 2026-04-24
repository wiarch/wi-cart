@extends('layouts.app')

@section('title', 'Nueva Unidad - List Market')
@section('category', 'GESTIÓN DE SISTEMA')
@section('header_title', 'Nueva Unidad')
@section('header_description', 'Crea una nueva unidad de medida para tus productos.')

@section('content')
    <div class="max-w-2xl mx-auto">
        <div class="mb-6">
            <a href="{{ route('units.index') }}" class="inline-flex items-center gap-2 text-sm font-black text-on-surface-variant hover:text-primary transition-colors no-underline uppercase tracking-widest">
                <i class="fa-solid fa-arrow-left"></i>
                Volver al listado
            </a>
        </div>

        <div class="botanical-card p-6 sm:p-10">
            <form action="{{ route('units.store') }}" method="POST" class="space-y-8">
                @csrf

                <div>
                    <label for="name" class="block font-bold text-[11px] text-primary uppercase tracking-widest mb-3">Nombre de la Unidad</label>
                    <input id="name" class="botanical-input" type="text" name="name" value="{{ old('name') }}" required autofocus placeholder="Ej: Kg, Litro, Unidad, Pack 6x..." />
                    @if ($errors->get('name'))
                        <ul class="text-xs text-error font-bold space-y-1 mt-3 list-none p-0">
                            @foreach ((array) $errors->get('name') as $message)
                                <li>{{ $message }}</li>
                            @endforeach
                        </ul>
                    @endif
                </div>

                <div class="pt-4">
                    <button type="submit" class="btn-botanical w-full border-none">
                        Guardar Unidad
                    </button>
                </div>
            </form>
        </div>
    </div>
@endsection
