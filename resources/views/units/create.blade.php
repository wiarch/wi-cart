@extends('layouts.app')

@section('title', 'Nueva unidad - Wi Cart')
@section('header_title', 'Nueva unidad')
@section('header_description', 'Define una medida o presentación.')

@section('content')
    <div class="max-w-2xl mx-auto">
        <a href="{{ route('units.index') }}" class="btn-secondary no-underline text-sm mb-4 inline-flex">
            <i class="fa-solid fa-arrow-left"></i> Volver
        </a>

        <div class="web-card">
            <form action="{{ route('units.store') }}" method="POST" class="space-y-6">
                @csrf
                <div>
                    <label for="name" class="web-label">Nombre de la unidad</label>
                    <input id="name" class="web-input" type="text" name="name" value="{{ old('name') }}" required autofocus placeholder="Ej: Kg, Litro, Pack 6x...">
                    @error('name')
                        <p class="mt-2 text-sm text-danger">{{ $message }}</p>
                    @enderror
                </div>
                <button type="submit" class="btn-primary w-full">Guardar unidad</button>
            </form>
        </div>
    </div>
@endsection
