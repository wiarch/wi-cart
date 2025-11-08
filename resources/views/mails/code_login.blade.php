<!DOCTYPE htmL>
<html>

<head>
    <meta charset="utf-8">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />

<style type="text/css">
    body {
        margin: 0;
        padding: 0;
        min-width: 100% !important;
    }

    img {
        height: auto;
    }

    .content {
        width: 100%;
        max-width: 600px;
    }

    .header {
        padding: 40px 30px 20px 30px;
    }

    .innerpadding {
        padding: 30px 30px 30px 30px;
    }

    .borderbottom {
        border-bottom: 1px solid #f2eeed;
    }

    .h1,
    .h2,
    .bodycopy {
        color: #153643;
        font-family: sans-serif;
    }

    .h1 {
        font-size: 33px;
        color: #000000 !important;
        line-height: 38px;
        font-weight: bold;
    }

    .h2 {
        padding: 0 0 15px 0;
        font-size: 24px;
        color: #153643 !important;
        line-height: 28px;
        font-weight: bold;
    }

    .bodycopy {
        font-size: 16px;
        line-height: 22px;
    }

    .footer {
        padding: 20px 30px 15px 30px;
        background-color: #222;
    }

    .footercopy {
        font-family: sans-serif;
        font-size: 14px;
        color: #ffffff;
    }

    .footercopy a {
        color: #ffffff;
        text-decoration: none;
    }
</style>

</head>

<body>
    <table width="100%" bgcolor="transparent" border="0" cellpadding="0" cellspacing="0">
        <tr>
            <td>
                <table bgcolor="#ffffff" class="content" align="center" cellpadding="0" cellspacing="0" border="0">

                    <tr>
                        <td style="background-color: #EEEEEE;" class="header">
                            <table width="70" align="left" border="0" cellpadding="0" cellspacing="0">
                                <tr>
                                    <td style="padding: 0 20px 20px 0;">
                                        <img src="{{ asset('img/proganadero/logo/negro.png') }}"
                                            width="170" height="170" alt="ProGanadero Logo" />
                                    </td>
                                </tr>
                            </table>

                            <table class="col425" align="left" border="0" cellpadding="0" cellspacing="0"
                                style="width: 100%; max-width: 425px;">
                                <tr>
                                    <td height="">
                                        <table width="100%" border="0">
                                            <tr>
                                                <td style="color: #222;">
                                                    {{-- <h1>ProGanadero</h1> --}}
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                            </table>

                        </td>
                    </tr>

                    <tr>
                        <td class="innerpadding borderbottom">
                            <table width="100%" border="0">
                                <tr>
                                    <td class="h1">
                                        Codigo de verificación: {{ $token }}
                                    </td>
                                </tr>
                                <tr>
                                    <td class="bodycopy">
                                        {{-- <p class="h2"><a href="{{ route('verify.code', $token) }}">Enlance para verificar el código</a></p> --}}
                                    </td>
                                </tr>

                            </table>
                        </td>
                    </tr>
                    <tr>
                        <td class="footer" style="background-color: #EEEEEE; font-weight: bold;">
                            <table width="100%" border="0">
                                <tr>
                                    <td align="center" class="footercopy" style="color: #1572e8;">
                                        <div class="container mt-5 pt-5">
                                            <footer
                                                class="d-flex justify-content-center align-items-center mt-5 pt-5 row">
                                                <p class="col-12 mb-0 text-muted mt-5 pt-5 text-center">Copyright &copy;
                                                    <script type="text/javascript">
                                                        document.write("2022 - " + new Date().getFullYear());
                                                    </script> ProGanadero <br> Soporte: <a
                                                        href="mailto:support@proganadero.com"
                                                        style="color: #222">support@proganadero.com</a>
                                                </p>
                                            </footer>
                                        </div>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>

                </table>
            </td>
        </tr>
    </table>
</body>

</html>
