<script>
    dinamicSelect('.regions', 'Seleccione una región', 'getRegions', null, 0, null);
    convertPlaceholdersToFloatingLabels('#a-form');
    convertPlaceholdersToFloatingLabels('#b-form');

    document.addEventListener('DOMContentLoaded', function() {
        const loginContainer = document.getElementById('b-container');
        const registerContainer = document.getElementById('a-container');
        const mainContainer = document.querySelector('.main');

        const switchButtons = document.querySelectorAll('.switch-btn');

        switchButtons.forEach(btn => {
            btn.addEventListener('click', () => {
                if (!loginContainer.classList.contains('hidden')) {
                    // Ocultar login, mostrar registro
                    loginContainer.classList.add('hidden');
                    registerContainer.classList.remove('hidden');

                    mainContainer.classList.remove('shrink');
                    mainContainer.classList.add('expand');
                } else {
                    // Mostrar login, ocultar registro
                    loginContainer.classList.remove('hidden');
                    registerContainer.classList.add('hidden');

                    mainContainer.classList.remove('expand');
                    mainContainer.classList.add('shrink');
                }
            });
        });

        // Estado inicial: mostrar login, ocultar registro y achicar main
        registerContainer.classList.add('hidden');
        loginContainer.classList.remove('hidden');

        // loginContainer.classList.add('hidden');
        // registerContainer.classList.remove('hidden');

        mainContainer.classList.add('shrink');
    });
</script>
