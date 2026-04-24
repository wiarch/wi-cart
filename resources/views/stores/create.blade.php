@extends('layouts.app')

@section('title', 'Nuevo Negocio - List Market')
@section('category', 'GESTIÓN DE SISTEMA')
@section('header_title', 'Nuevo Negocio')
@section('header_description', 'Agrega un nuevo supermercado o tienda a tu red de compras.')

@section('content')
    <div class="max-w-2xl mx-auto">
        <div class="mb-6">
            <a href="{{ route('stores.index') }}" class="inline-flex items-center gap-2 text-sm font-black text-on-surface-variant hover:text-primary transition-colors no-underline uppercase tracking-widest">
                <i class="fa-solid fa-arrow-left"></i>
                Volver al listado
            </a>
        </div>

        <div class="botanical-card p-8">
            <form action="{{ route('stores.store') }}" method="POST" class="space-y-6">
                @csrf
                
                <div class="space-y-2">
                    <label for="name" class="block text-xs font-black uppercase tracking-widest text-primary ml-1">Nombre del Negocio</label>
                    <div class="input-icon-wrapper relative">
                        <i class="fa-solid fa-store absolute left-5 top-1/2 -translate-y-1/2 text-primary opacity-40"></i>
                        <input type="text" 
                               name="name" 
                               id="name" 
                               placeholder="Ej: Supermercado Central, Tienda del Barrio..."
                               class="botanical-input w-full pl-14 py-4 rounded-2xl bg-surface-container-high border-2 border-transparent focus:border-primary transition-all outline-none text-on-surface font-bold"
                               required 
                               autofocus>
                    </div>
                    @error('name')
                        <p class="text-error text-xs font-bold mt-2 ml-1 italic">{{ $message }}</p>
                    @enderror
                </div>

                <div class="pt-6">
                    <button type="submit" class="btn-botanical w-full py-4 px-8 rounded-2xl font-black uppercase tracking-widest text-sm flex items-center justify-center gap-3 shadow-lg shadow-primary/20 hover:shadow-primary/30 active:scale-95 transition-all">
                        <i class="fa-solid fa-cloud-arrow-up text-lg"></i>
                        Guardar Negocio
                    </button>
                </div>
            </form>
        </div>
    </div>
@endsection
