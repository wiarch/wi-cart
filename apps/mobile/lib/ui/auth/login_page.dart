import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../app_scope.dart';
import '../theme/app_theme.dart';
import '../widgets/confirm_dialog.dart';

// Web OAuth client ID (public). Android client is bound by package + SHA-1, not used in code.
const _googleServerClientId = String.fromEnvironment(
  'GOOGLE_SERVER_CLIENT_ID',
  defaultValue:
      '572243431646-1g23qfe8luhmpmoahh3873jnqp97od3e.apps.googleusercontent.com',
);

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, required this.onAuthed});

  final VoidCallback onAuthed;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  static final Future<void> _googleInit = GoogleSignIn.instance.initialize(
    serverClientId: _googleServerClientId,
  );

  bool _busy = false;
  String? _error;

  Future<void> _signIn() async {
    setState(() {
      _busy = true;
      _error = null;
    });
    final scope = AppScope.of(context);
    try {
      await _googleInit;
      final account = await GoogleSignIn.instance.authenticate();
      final idToken = account.authentication.idToken;
      if (idToken == null) throw StateError('Google no devolvió id_token');
      await scope.api.loginWithGoogle(idToken: idToken);
      final userId = await scope.api.getUserId();
      final prefs = await SharedPreferences.getInstance();
      final guest = prefs.getBool('guest_mode') ?? false;
      final linked = prefs.getString('local_user_id');
      if ((guest || linked == null) && await scope.repo.hasGuestContent()) {
        if (!mounted) return;
        final import = await showAppAlert(
          context,
          title: 'Datos de este celular',
          message:
              'Hay registros guardados en este dispositivo. '
              '¿Quieres importarlos y sincronizarlos con tu cuenta de Google?',
          cancelLabel: 'No importar',
          confirmLabel: 'Importar',
        );
        if (import == false) await scope.repo.db.wipeAllUserData();
      }
      await prefs.setBool('guest_mode', false);
      await scope.repo.onUserSwitch(userId);
      await scope.repo.ensureDefaults();
      try {
        await scope.sync.syncNow();
      } catch (_) {
        // Login ok even if first sync fails (offline / API hiccup).
      }
      if (!mounted) return;
      widget.onAuthed();
    } on GoogleSignInException catch (e) {
      if (mounted && e.code != GoogleSignInExceptionCode.canceled) {
        setState(
          () => _error =
              'No se pudo iniciar sesión con Google. Intenta de nuevo.',
        );
      }
    } on DioException catch (e) {
      if (mounted) {
        setState(
          () => _error = e.response == null
              ? 'No se pudo conectar con el servidor. Revisa tu conexión y vuelve a intentarlo.'
              : 'El servidor rechazó el inicio de sesión. Intenta de nuevo.',
        );
      }
    } catch (_) {
      if (mounted) {
        setState(
          () => _error = 'Ocurrió un error inesperado. Intenta de nuevo.',
        );
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _enterGuest() async {
    final ok = await showAppAlert(
      context,
      title: 'Entrar como invitado',
      message:
          'Todo se guardará localmente en el celular y no tendrá '
          'respaldo automático en la nube hasta que inicies sesión.',
      confirmLabel: 'Continuar',
    );
    if (ok != true || !mounted) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('guest_mode', true);
    if (!mounted) return;
    await AppScope.of(context).repo.ensureDefaults();
    if (!mounted) return;
    widget.onAuthed();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final muted = theme.colorScheme.onSurfaceVariant;
    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment(0, -0.6),
            radius: 1.1,
            colors: [Color(0x668EB69B), AppTheme.mint],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Column(
              children: [
                const Spacer(),
                Container(
                  width: 96,
                  height: 96,
                  decoration: BoxDecoration(
                    color: AppTheme.card,
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(color: AppTheme.borderSubtle),
                    boxShadow: AppTheme.softShadow,
                  ),
                  child: const Icon(
                    Icons.shopping_basket_rounded,
                    size: 42,
                    color: AppTheme.ink700,
                  ),
                ),
                const SizedBox(height: 28),
                Text(
                  'wi-cart',
                  style: theme.textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                    letterSpacing: -1.2,
                    height: 1.05,
                    color: AppTheme.ink700,
                  ),
                ),
                const SizedBox(height: 12),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 280),
                  child: Text(
                    'Listas y presupuesto, en el celular',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: muted,
                      height: 1.35,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const Spacer(),
                if (_error != null) ...[
                  Text(
                    _error!,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: theme.colorScheme.error),
                  ),
                  const SizedBox(height: 12),
                ],
                DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.ink800.withValues(alpha: 0.14),
                        blurRadius: 18,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: FilledButton.icon(
                      onPressed: _busy ? null : _signIn,
                      style: FilledButton.styleFrom(
                        textStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      icon: _busy
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.account_circle),
                      label: const Text('Continuar con Google'),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: OutlinedButton(
                    onPressed: _busy ? null : _enterGuest,
                    style: OutlinedButton.styleFrom(
                      backgroundColor: AppTheme.card,
                      side: const BorderSide(color: AppTheme.borderSubtle),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      textStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    child: const Text('Entrar como invitado'),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.cloud_off_outlined, size: 16, color: muted),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Sin red: tras login previo la app sigue usable. '
                        'Sync al recuperar conexión.',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: muted,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
