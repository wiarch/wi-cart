<!DOCTYPE html>
<html lang="{{ str_replace('_', '-', app()->getLocale()) }}">
    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1, viewport-fit=cover">
        <title>List Market - Curated Rituals</title>
        
        <script>
            if (localStorage.getItem('theme') === 'dark' || (!('theme' in localStorage) && window.matchMedia('(prefers-color-scheme: dark)').matches)) {
                document.documentElement.classList.add('dark');
            } else {
                document.documentElement.classList.remove('dark');
            }
        </script>

        <!-- Local Styles -->
        <link rel="stylesheet" href="{{ vasset('css/tailwind/tailwind.min.css') }}">
        <link rel="stylesheet" href="{{ vasset('css/custom.css') }}">

        <!-- Local Scripts -->
        <script src="{{ vasset('js/lib/jquery.min.js') }}"></script>
    </head>
    <body class="bg-surface text-on-surface antialiased overflow-x-hidden transition-colors duration-300">
        <header class="botanical-header fixed top-0 w-full z-40">
            <div class="flex justify-between items-center px-6 py-4 w-full max-w-screen-xl mx-auto">
                <div class="flex items-center gap-3">
                    <div class="p-2 bg-surface-container-lowest rounded-xl shadow-sm border border-outline-variant/10">
                        <i class="fa-solid fa-leaf text-primary text-xl"></i>
                    </div>
                    <h1 class="text-xl font-black tracking-tight text-on-surface">Market</h1>
                </div>

                <div class="flex items-center gap-4 sm:gap-6">
                    @auth
                        <a href="{{ url('/dashboard') }}" class="font-bold text-xs text-on-surface-variant hover:text-primary transition-colors no-underline uppercase tracking-widest">Mis Listas</a>
                    @else
                        <a href="{{ route('login') }}" class="font-bold text-xs text-on-surface-variant hover:text-primary transition-colors no-underline uppercase tracking-widest">Ingresar</a>
                        @if (Route::has('register'))
                            <a href="{{ route('register') }}" class="btn-botanical py-2 px-6 text-xs no-underline">Empezar</a>
                        @endif
                    @endauth
                </div>
            </div>
        </header>

        <main class="pt-28 pb-20 px-6 max-w-screen-xl mx-auto w-full min-h-screen">
            <!-- Hero Bento Section -->
            <section class="mb-12 sm:mb-16 pt-4 sm:pt-8 animate-slide-up">
                <span class="text-primary font-bold tracking-widest text-[10px] sm:text-[11px] uppercase mb-3 block">Fresco & Organizado</span>
                <h2 class="text-4xl sm:text-5xl md:text-7xl font-black text-on-surface tracking-tighter leading-[0.9] mb-6">
                    Tu ritual de <br/> <span class="text-primary italic">compras</span> curado.
                </h2>
                <p class="text-on-surface-variant max-w-lg font-medium text-sm sm:text-base mb-10">
                    Transforma el caos en claridad editorial. Una experiencia diseñada para quienes ven en la comida una forma de arte.
                </p>

                <div class="grid grid-cols-1 lg:grid-cols-3 gap-6">
                    <div class="lg:col-span-2 botanical-card bg-primary text-white p-8 sm:p-10 flex flex-col justify-between min-h-[280px] sm:min-h-[320px] relative overflow-hidden">
                        <div class="relative z-10">
                            <h3 class="text-3xl sm:text-4xl font-black mb-4 leading-none text-white">Precisión <br/> Editorial</h3>
                            <p class="text-on-primary/80 font-medium mb-8 max-w-xs text-sm sm:text-base">Organiza por categorías, presupuesto y frescura con un toque botánico.</p>
                            @auth
                                <a href="{{ url('/dashboard') }}" class="inline-block bg-white text-primary px-8 py-4 rounded-2xl font-black text-sm no-underline shadow-lg hover:scale-105 transition-transform active:scale-95">Ver mis Listas</a>
                            @else
                                <a href="{{ route('register') }}" class="inline-block bg-white text-primary px-8 py-4 rounded-2xl font-black text-sm no-underline shadow-lg hover:scale-105 transition-transform active:scale-95">Comenzar Ritual</a>
                            @endauth
                        </div>
                        <!-- Abstract Organic Decoration -->
                        <div class="absolute -right-20 -bottom-20 w-80 h-80 bg-black/10 rounded-full opacity-50 blur-[60px]"></div>
                    </div>

                    <div class="botanical-card p-8 sm:p-10 flex flex-col items-center justify-center text-center">
                        <div class="w-16 h-16 sm:w-20 sm:h-20 bg-secondary-container/30 text-primary rounded-[1.5rem] sm:rounded-[2rem] flex items-center justify-center mb-6 shadow-inner">
                            <i class="fa-solid fa-volume-xmark text-4xl"></i>
                        </div>
                        <h4 class="text-xl font-bold mb-2">Sin Ruido</h4>
                        <p class="text-on-surface-variant text-sm font-medium">Una interfaz limpia, enfocada en lo que importa: tus ingredientes.</p>
                    </div>
                </div>
            </section>

            <!-- Features Bento Grid -->
            <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4 sm:gap-6 mb-20 animate-slide-up" style="animation-delay: 0.2s">
                <div class="botanical-card hover:bg-surface-container-low transition-all">
                    <div class="pill-tag mb-4">Auth</div>
                    <h3 class="text-xl font-black mb-2">Ingreso Seguro</h3>
                    <p class="text-on-surface-variant text-sm font-medium">Tu privacidad es el ingrediente principal.</p>
                </div>
                <div class="botanical-card hover:bg-surface-container-low transition-all">
                    <div class="pill-tag mb-4">UX</div>
                    <h3 class="text-xl font-black mb-2">Diseño Nativo</h3>
                    <p class="text-on-surface-variant text-sm font-medium">Se siente como una App, pero funciona en cualquier lugar.</p>
                </div>
                <div class="botanical-card hover:bg-surface-container-low transition-all">
                    <div class="pill-tag mb-4">Libre</div>
                    <h3 class="text-xl font-black mb-2">Sin Dependencias</h3>
                    <p class="text-on-surface-variant text-sm font-medium">Rápido, local y sin bloatware innecesario.</p>
                </div>
            </div>
        </main>

        <footer class="bg-surface-container-low py-12 px-6 border-t border-outline-variant/10">
            <div class="max-w-screen-xl mx-auto flex flex-col md:flex-row justify-between items-center gap-8">
                <div class="flex items-center gap-3">
                    <div class="p-2 bg-surface-container-lowest rounded-xl shadow-sm border border-outline-variant/10">
                        <i class="fa-solid fa-leaf text-primary text-xl"></i>
                    </div>
                    <span class="font-black text-on-surface tracking-tighter">List Market</span>
                </div>
                <p class="text-on-surface-variant text-[10px] font-black uppercase tracking-[0.2em] opacity-60">
                    &copy; 2026 — El Ritual de Compras
                </p>
            </div>
        </footer>
    </body>
</html>
