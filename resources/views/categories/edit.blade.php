@extends('layouts.app')

@section('title', 'Editar Categoría - List Market')
@section('category', 'GESTIÓN DE SISTEMA')
@section('header_title', 'Editar Categoría')
@section('header_description', 'Actualiza la información de la clasificación seleccionada.')

@section('content')
    <div class="max-w-2xl mx-auto">
        <div class="mb-6">
            <a href="{{ route('categories.index') }}" class="inline-flex items-center gap-2 text-sm font-black text-on-surface-variant hover:text-primary transition-colors no-underline uppercase tracking-widest">
                <i class="fa-solid fa-arrow-left"></i>
                Volver al listado
            </a>
        </div>

        <div class="botanical-card p-6 sm:p-10">
            <form action="{{ route('categories.update', $category) }}" method="POST" class="space-y-8">
                @csrf
                @method('PUT')

                <div>
                    <label for="name" class="block font-bold text-[11px] text-primary uppercase tracking-widest mb-3">Nombre de la Categoría</label>
                    <input id="name" class="botanical-input" type="text" name="name" value="{{ old('name', $category->name) }}" required autofocus placeholder="Ej: Lácteos, Frutas, Limpieza..." />
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
                        Actualizar Categoría
                    </button>
                </div>
            </form>
        </div>
    </div>
@endsection
