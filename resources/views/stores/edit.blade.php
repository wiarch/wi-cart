@extends('layouts.app')

@section('title', 'Editar negocio - Wi Cart')
@section('header_title', 'Editar negocio')
@section('header_description', 'Modifica el nombre del negocio.')

@section('content')
    <div class="max-w-2xl mx-auto">
        <a href="{{ route('stores.index') }}" class="btn-secondary no-underline text-sm mb-4 inline-flex">
            <i class="fa-solid fa-arrow-left"></i> Volver
        </a>

        <div class="web-card">
            <form action="{{ route('stores.update', $store) }}" method="POST" class="space-y-6">
                @csrf
                @method('PUT')
                <div>
                    <label for="name" class="web-label">Nombre del negocio</label>
                    <input type="text" name="name" id="name" class="web-input" value="{{ old('name', $store->name) }}" required autofocus>
                    @error('name')
                        <p class="mt-2 text-sm text-danger">{{ $message }}</p>
                    @enderror
                </div>
                <div>
                    <label for="location" class="web-label">Ubicación</label>
                    <input type="text" name="location" id="location" class="web-input" value="{{ old('location', $store->location) }}">
                    @error('location')
                        <p class="mt-2 text-sm text-danger">{{ $message }}</p>
                    @enderror
                </div>
                <div>
                    <label for="contact" class="web-label">Contacto</label>
                    <input type="text" name="contact" id="contact" class="web-input" value="{{ old('contact', $store->contact) }}">
                    @error('contact')
                        <p class="mt-2 text-sm text-danger">{{ $message }}</p>
                    @enderror
                </div>
                <button type="submit" class="btn-primary w-full">Actualizar negocio</button>
            </form>
        </div>
    </div>
@endsection
