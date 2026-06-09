@extends('layouts.app')

@section('title', 'Nuevo negocio - Wi Cart')
@section('header_title', 'Nuevo negocio')
@section('header_description', 'Agrega un supermercado o tienda.')

@section('content')
    <div class="max-w-2xl mx-auto">
        <a href="{{ route('stores.index') }}" class="btn-secondary no-underline text-sm mb-4 inline-flex">
            <i class="fa-solid fa-arrow-left"></i> Volver
        </a>

        <div class="web-card">
            <form action="{{ route('stores.store') }}" method="POST" class="space-y-6">
                @csrf
                <div>
                    <label for="name" class="web-label">Nombre del negocio</label>
                    <input type="text" name="name" id="name" class="web-input" placeholder="Ej: Supermercado Central..." required autofocus value="{{ old('name') }}">
                    @error('name')
                        <p class="mt-2 text-sm text-danger">{{ $message }}</p>
                    @enderror
                </div>
                <div>
                    <label for="location" class="web-label">Ubicación</label>
                    <input type="text" name="location" id="location" class="web-input" placeholder="Ej: Av. Principal 123" value="{{ old('location') }}">
                    @error('location')
                        <p class="mt-2 text-sm text-danger">{{ $message }}</p>
                    @enderror
                </div>
                <div>
                    <label for="contact" class="web-label">Contacto</label>
                    <input type="text" name="contact" id="contact" class="web-input" placeholder="Ej: +34 600 000 000" value="{{ old('contact') }}">
                    @error('contact')
                        <p class="mt-2 text-sm text-danger">{{ $message }}</p>
                    @enderror
                </div>
                <button type="submit" class="btn-primary w-full">Guardar negocio</button>
            </form>
        </div>
    </div>
@endsection
