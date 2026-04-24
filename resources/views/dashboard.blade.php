@extends('layouts.app')

@section('title', 'Mis Listas - List Market')
@section('category', 'CURATED COLLECTIONS')
@section('header_title', 'Mis Listas')
@section('header_description', 'Organiza tus compras con la precisión de un editor. Frescura y orden en cada selección.')

@section('content')
    <!-- Search Bar -->
    <div class="mb-8 sm:mb-12 animate-slide-up" style="animation-delay: 0.1s">
        <div class="bg-surface-container-high rounded-2xl flex items-center px-5 py-4 w-full group focus-within:bg-surface-container-lowest focus-within:shadow-lg focus-within:ring-2 focus-within:ring-primary/20 transition-all">
            <i class="fa-solid fa-magnifying-glass text-on-surface-variant mr-3 text-xl"></i>
            <input class="bg-transparent border-none focus:ring-0 w-full text-on-surface placeholder:text-on-surface-variant font-medium outline-none" placeholder="Buscar en mis colecciones..." type="text"/>
        </div>
    </div>

    <!-- Bento Grid Layout -->
    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4 sm:gap-6 mb-12">
        <div class="botanical-card botanical-card-interactive flex flex-col justify-between min-h-[220px] relative animate-slide-up" style="animation-delay: 0.2s">
            <div class="absolute top-6 right-6">
                <span class="pill-tag">Activa</span>
            </div>
            <div>
                <div class="w-12 h-12 bg-primary/10 rounded-2xl flex items-center justify-center mb-4 text-primary">
                    <i class="fa-solid fa-basket-shopping text-xl"></i>
                </div>
                <h3 class="text-xl font-bold text-on-surface mb-1">Compra Mensual</h3>
                <p class="text-on-surface-variant text-sm font-medium">42 artículos • Editada hoy</p>
            </div>
            <div class="flex items-center justify-between mt-6">
                <div class="flex -space-x-3">
                    <div class="w-9 h-9 rounded-full border-2 border-surface-container-lowest bg-surface-container-low flex items-center justify-center">🍎</div>
                    <div class="w-9 h-9 rounded-full border-2 border-surface-container-lowest bg-surface-container-low flex items-center justify-center">🥦</div>
                    <div class="w-9 h-9 rounded-full border-2 border-surface-container-lowest bg-surface-container-low flex items-center justify-center text-[10px] font-black text-primary">+5</div>
                </div>
                <button class="text-primary font-black text-sm hover:underline border-none bg-transparent cursor-pointer">Ver detalles</button>
            </div>
        </div>

        <div class="botanical-card botanical-card-interactive flex flex-col justify-between min-h-[220px] animate-slide-up" style="animation-delay: 0.3s">
            <div>
                <div class="w-12 h-12 bg-secondary-container/20 rounded-2xl flex items-center justify-center mb-4 text-on-secondary-container">
                    <i class="fa-solid fa-circle-check text-xl"></i>
                </div>
                <h3 class="text-xl font-bold text-on-surface mb-1">Parrillada</h3>
                <p class="text-on-surface-variant text-sm font-medium">12 artículos • 15 Oct, 2023</p>
            </div>
            <div class="mt-6 flex justify-between items-center">
                <span class="text-[10px] font-black text-on-surface-variant/60 uppercase tracking-widest">Especial</span>
                <button class="p-2 rounded-xl hover:bg-surface-container-low text-on-surface-variant border-none bg-transparent cursor-pointer transition-colors">
                    <i class="fa-solid fa-ellipsis-vertical"></i>
                </button>
            </div>
        </div>

        <div class="rounded-3xl p-6 border-2 border-dashed border-outline-variant flex flex-col items-center justify-center min-h-[220px] group hover:border-primary/40 transition-all cursor-pointer bg-surface-container-low/30 hover:bg-surface-container-low/50 animate-slide-up" style="animation-delay: 0.4s">
            <div class="w-14 h-14 rounded-2xl bg-surface-container-lowest flex items-center justify-center mb-4 shadow-sm group-hover:scale-110 transition-transform text-primary border border-outline-variant/10">
                <i class="fa-solid fa-plus text-2xl"></i>
            </div>
            <p class="text-on-surface-variant font-black text-[10px] uppercase tracking-[0.2em]">Nueva Lista</p>
        </div>
    </div>

    <!-- Smart Budget Card -->
    <div class="bg-primary rounded-[2.5rem] relative p-8 sm:p-10 text-on-primary shadow-xl overflow-hidden mb-12 animate-slide-up" style="animation-delay: 0.5s">
        <div class="relative z-10">
            <h3 class="text-2xl sm:text-3xl font-black mb-3 leading-tight sm:leading-none">Presupuesto <br class="hidden sm:block"/>Inteligente</h3>
            <p class="text-on-primary/80 font-medium mb-8 max-w-xs text-sm sm:text-base">Haz ahorrado un 12% este mes siguiendo tus listas curadas.</p>
            <button class="bg-white text-primary px-8 py-4 rounded-2xl font-black text-sm shadow-md active:scale-95 transition-all border-none cursor-pointer hover:bg-on-primary">Analizar Gastos</button>
        </div>
        <div class="absolute right-0 top-0 h-full w-2/3 sm:w-1/2 bg-white/10 backdrop-blur-3xl rounded-l-[5rem] sm:rounded-l-[10rem] pointer-events-none"></div>
        <i class="fa-solid fa-chart-line absolute right-12 bottom-12 text-white/10 text-9xl -rotate-12 pointer-events-none"></i>
    </div>

    <!-- Mobile FAB -->
    <button class="fixed bottom-32 sm:bottom-10 right-6 sm:right-10 w-16 h-16 rounded-2xl btn-botanical flex items-center justify-center z-40 border-none shadow-2xl active:scale-90 transition-all">
        <i class="fa-solid fa-plus text-white text-3xl"></i>
    </button>
@endsection
