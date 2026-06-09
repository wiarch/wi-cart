@extends('layouts.app')

@section('title', 'Editar categoría - Wi Cart')
@section('header_title', 'Editar categoría')
@section('header_description', 'Actualiza la clasificación seleccionada.')

@section('content')
    <div class="max-w-2xl mx-auto">
        <a href="{{ route('categories.index') }}" class="btn-secondary no-underline text-sm mb-4 inline-flex">
            <i class="fa-solid fa-arrow-left"></i> Volver
        </a>

        <div class="web-card">
            <form action="{{ route('categories.update', $category) }}" method="POST" class="space-y-6">
                @csrf
                @method('PUT')
                <div>
                    <label for="name" class="web-label">Nombre de la categoría</label>
                    <input id="name" class="web-input" type="text" name="name" value="{{ old('name', $category->name) }}" required autofocus>
                    @error('name')
                        <p class="mt-2 text-sm text-danger">{{ $message }}</p>
                    @enderror
                </div>
                <button type="submit" class="btn-primary w-full">Actualizar categoría</button>
            </form>
        </div>
    </div>
@endsection
