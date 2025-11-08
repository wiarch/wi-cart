<style>
    @font-face {
        font-family: "GOBOLD";
        src: url("../fonts/Gobold_Bold.otf") format("truetype");
        font-weight: bold;
        font-style: normal;
    }

    @font-face {
        font-family: "GOBOLD LOWPLUS";
        src: url("../fonts/Gobold_Lowplus.otf") format("truetype");
        font-weight: bold;
        font-style: normal;
    }

    @font-face {
        font-family: "GOBOLD LIGHT";
        src: url("../fonts/Gobold_Light.otf") format("truetype");
        font-weight: bold;
        font-style: normal;
    }

    .gobold {
        font-family: "GOBOLD", sans-serif !important;
        font-weight: bold !important;
    }

    .gobold-lowplus {
        font-family: "GOBOLD LOWPLUS", sans-serif !important;
        font-weight: bold !important;
    }

    .gobold-light {
        font-family: "GOBOLD LIGHT", sans-serif !important;
        font-weight: bold !important;
    }

    #spinner {
        opacity: 0;
        visibility: hidden;
        transition: opacity 0.5s ease-out, visibility 0s linear 0.5s;
        z-index: 99999;
    }

    #spinner.show {
        transition: opacity 0.5s ease-out, visibility 0s linear 0s;
        visibility: visible;
        opacity: 1;
    }


    .floating-wrapper {
        position: relative;
    }

    .floating-label {
        position: absolute;
        left: 5px;
        top: 50%;
        transform: translateY(-50%);
        font-size: 14px;
        color: #999;
        pointer-events: none;
        transition: 0.2s ease all;
        /* background: white; */
        padding: 0 4px;
    }

    .floating-input:focus+.floating-label,
    .floating-input.not-empty+.floating-label {
        top: -10px;
        font-size: 11px;
        color: #000;
    }

    .select2-container--default .select2-selection--single {
        background-color: #fff !important;
    }


    .select2-container--default .select2-dropdown {
        background-color: #fff !important;
        color: #000 !important;
    }
</style>
