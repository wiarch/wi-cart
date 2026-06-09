@extends('layouts.app')

@section('title', 'Editar unidad - Wi Cart')
@section('header_title', 'Editar unidad')
@section('header_description', 'Actualiza la unidad seleccionada.')

@section('content')
    <div class="max-w-2xl mx-auto">
        <a href="{{ route('units.index') }}" class="btn-secondary no-underline text-sm mb-4 inline-flex">
            <i class="fa-solid fa-arrow-left"></i> Volver
        </a>

        <div class="web-card">
            <form action="{{ route('units.update', $unit) }}" method="POST" class="space-y-6">
                @csrf
                @method('PUT')
                <div>
                    <label for="name" class="web-label">Nombre de la unidad</label>
                    <input id="name" class="web-input" type="text" name="name" value="{{ old('name', $unit->name) }}" required autofocus>
                    @error('name')
                        <p class="mt-2 text-sm text-danger">{{ $message }}</p>
                    @enderror
                </div>
                <button type="submit" class="btn-primary w-full">Actualizar unidad</button>
            </form>
        </div>
    </div>
@endsection
