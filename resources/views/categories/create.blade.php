@extends('layouts.app')

@section('title', 'Nueva categoría - Wi Cart')
@section('header_title', 'Nueva categoría')
@section('header_description', 'Crea una clasificación para tus productos.')

@section('content')
    <div class="max-w-2xl mx-auto">
        <div class="mb-6">
            <a href="{{ route('categories.index') }}" class="btn-secondary no-underline text-sm mb-4 inline-flex">
                <i class="fa-solid fa-arrow-left"></i>
                Volver
            </a>
        </div>

        <div class="web-card max-w-2xl mx-auto">
            <form action="{{ route('categories.store') }}" method="POST" class="space-y-6">
                @csrf

                <div>
                    <label for="name" class="web-label">Nombre de la categoría</label>
                    <input id="name" class="web-input" type="text" name="name" value="{{ old('name') }}" required autofocus placeholder="Ej: Lácteos, Frutas, Limpieza..." />
                    @if ($errors->get('name'))
                        <ul class="text-xs text-error font-bold space-y-1 mt-3 list-none p-0">
                            @foreach ((array) $errors->get('name') as $message)
                                <li>{{ $message }}</li>
                            @endforeach
                        </ul>
                    @endif
                </div>

                <div class="pt-4">
                    <button type="submit" class="btn-primary w-full">
                        Guardar categoría
                    </button>
                </div>
            </form>
        </div>
    </div>
@endsection
