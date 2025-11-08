<style>
    body {
        overflow: auto;
    }
    
    .main {
        position: relative;
        background-color: #ecf0f3;
        border-radius: 12px;
        overflow: hidden;
        transition: width 0.5s ease, height 0.5s ease;
    }

    /* Clase para achicar */
    .main.shrink {
        width: 35rem;
        height: 25rem;

        /* width: 70rem;
        height: 45rem; */
    }

    /* Clase para agrandar */
    .main.expand {
        width: 40rem;
        height: 40rem;
        /* width: 40rem;
        height: 30rem; */
    }


    @media (max-width: 1200px) {
        .main {
            transform: scale(0.7);
        }
    }

    @media (max-width: 1000px) {
        .main {
            transform: scale(0.6);
        }
    }

    @media (max-width: 800px) {
        .main {
            transform: scale(0.5);
        }
    }

    @media (max-width: 600px) {
        .main {
            transform: scale(0.4);
        }
    }

    .container {
        display: flex;
        justify-content: center;
        align-items: center;
        top: 0;
        width: 600px;
        height: 100%;
        padding: 25px;
        background-color: #ecf0f3;
        transition: 1.25s;
    }

    .form {
        display: flex;
        align-items: center;
        flex-direction: column;
        width: 100%;
        height: 100%;
    }

    .form__input {
        width: 350px;
        height: 40px !important;
        margin: 4px 0 !important;
        padding-left: 25px;
        font-size: 13px !important;
        border: none !important;
        outline: none !important;
        font-family: "Montserrat", sans-serif !important;
        background-color: #ecf0f3 !important;
        transition: 0.25s ease !important;
        border-radius: 8px !important;
        box-shadow: inset 2px 2px 4px #d1d9e6, inset -2px -2px 4px #f9f9f9 !important;
    }

    .form__input:focus {
        box-shadow: inset 4px 4px 4px #d1d9e6, inset -4px -4px 4px #f9f9f9;
    }

    .form__span {
        margin-top: 30px;
        margin-bottom: 12px;
    }

    .title {
        font-weight: 700;
        line-height: 2;
        color: #181818;
    }

    .form_title {
        font-weight: 700;
        line-height: 1;
        color: #181818;
        font-size: 20px !important;
    }

    .description {
        font-size: 20px;
        text-align: center;
        line-height: 1.2;
    }

    .button {
        width: 180px;
        height: 50px;
        border-radius: 25px;
        font-weight: 700;
        font-size: 14px;
        background-color: #4b70e2;
        color: #f9f9f9;
        box-shadow: 8px 8px 16px #d1d9e6, -8px -8px 16px #f9f9f9;
        border: none;
        outline: none;
    }

    .a-container {
        z-index: 100;
        left: calc(100% - 600px);
    }

    .b-container {
        left: calc(100% - 600px);
        z-index: 0;
    }

    .switch {
        display: flex;
        justify-content: center;
        align-items: center;
        position: absolute;
        top: 0;
        left: 0;
        height: 100%;
        width: 500px;
        padding: 50px;
        z-index: 200;
        transition: 1.25s;
        background-color: #ecf0f3;
        overflow: hidden;
        box-shadow: 4px 4px 10px #d1d9e6, -4px -4px 10px #f9f9f9;
    }

    .switch__circle {
        position: absolute;
        width: 500px;
        height: 500px;
        border-radius: 50%;
        background-color: #ecf0f3;
        box-shadow: inset 8px 8px 12px #d1d9e6, inset -8px -8px 12px #f9f9f9;
        bottom: -60%;
        left: -60%;
        transition: 1.25s;
    }

    .switch__circle--t {
        top: -30%;
        left: 60%;
        width: 300px;
        height: 300px;
    }

    .switch__container {
        display: flex;
        justify-content: center;
        align-items: center;
        flex-direction: column;
        position: absolute;
        width: 500px;
        padding: 50px 55px;
        transition: 1.25s;
    }

    .switch__button {
        cursor: pointer;
    }

    .switch__button:hover {
        box-shadow: 6px 6px 10px #d1d9e6, -6px -6px 10px #f9f9f9;
        transform: scale(0.985);
        transition: 0.25s;
    }

    .switch__button:active,
    .switch__button:focus {
        box-shadow: 2px 2px 6px #d1d9e6, -2px -2px 6px #f9f9f9;
        transform: scale(0.97);
        transition: 0.25s;
    }

    .bg-form {
        position: relative;
        min-height: 100vh;
        /* mínimo altura igual al viewport */
        width: 100vw;
        overflow-y: auto;
        /* scroll vertical si contenido excede */
        background: none;
        /* fondo lo maneja .fondo-imagen */
    }

    .bg-img {
        position: fixed;
        /* fija la imagen al viewport */
        top: 0;
        left: 0;
        width: 100vw;
        height: 100vh;
        background: url("/img/proganadero/galleria/12.jpg") no-repeat center center;
        background-size: cover;
        filter: brightness(0.5);
        pointer-events: none;
        /* evita que la imagen interfiera clicks */
    }

    .form-container {
        position: relative;
        z-index: 2;
        flex-direction: column;
        align-items: center;
        justify-content: center;
        height: 100%;
        padding: 1rem;
        color: white;
        top: -3vh;
    }

    /* MULTISTEP */
    .multisteps-form__progress {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(0, 1fr));
    }

    .multisteps-form__progress-btn {
        position: relative;
        padding-top: 20px;
        color: rgba(108, 117, 125, 0.7);
        text-indent: -9999px;
        border: none;
        background-color: transparent;
        outline: none !important;
        cursor: pointer;
    }

    @media (min-width: 500px) {
        .multisteps-form__progress-btn {
            text-indent: 0;
        }
    }

    .multisteps-form__progress-btn:before {
        position: absolute;
        top: 0;
        left: 50%;
        width: 13px;
        height: 13px;
        content: "";
        transform: translateX(-50%);
        border: 2px solid currentColor;
        border-radius: 50%;
        background-color: #fff;
        box-sizing: border-box;
        z-index: 3;
    }

    .multisteps-form__progress-btn:after {
        position: absolute;
        top: 5px;
        left: calc(-50% - 13px / 2);
        width: 100%;
        height: 2px;
        content: "";
        background-color: currentColor;
        z-index: 1;
    }

    .multisteps-form__progress-btn:first-child:after {
        display: none;
    }

    .multisteps-form__progress-btn.js-active {
        color: #3fca89;
    }

    .multisteps-form__progress-btn.js-active:before {
        transform: translateX(-50%) scale(1.2);
        background-color: currentColor;
    }

    .multisteps-form__form {
        position: relative;
    }

    .multisteps-form__panel {
        position: absolute;
        top: 0;
        left: 0;
        width: 100%;
        height: 0;
        opacity: 0;
        visibility: hidden;
    }

    .multisteps-form__panel.js-active {
        height: auto;
        opacity: 1;
        visibility: visible;
    }

    .multisteps-form__panel[data-animation="scaleIn"] {
        transform: scale(0.9);
    }

    .multisteps-form__panel[data-animation="scaleIn"].js-active {
        margin-top: 2vh;
        transform: scale(1.2);
        transition: all 0.2s linear;
    }

    /* Spinner */
    #spinner {
        display: flex;
        align-items: center;
        justify-content: center;
    }

    .scroll-container {
        /* max-width: 100vh; */
        overflow-y: auto;
        overflow-x: auto;
        padding-right: 20px;
        max-height: 17rem;
    }

    .tabla-scroll thead th {
        position: sticky;
        top: 0;
        background-color: #212529;
        /* Color del header (igual que .table-dark) */
        color: #fff;
        z-index: 2;
    }

    #rodeosFieldsContainer>div {
        border: 1px solid #ddd;
        padding: 1rem;
        border-radius: 0.5rem;
        background-color: #f9f9f9;
    }
    .container {
        position: absolute;
        width: 100%;
        top: 50%;
        left: 50%;
        transform: translate(-50%, -50%);
        transition: opacity 0.6s ease-in-out;
        opacity: 1;
        pointer-events: auto;
        z-index: 10;
    }

    .hidden {
        opacity: 0;
        pointer-events: none;
        z-index: 0;
    }
</style>
