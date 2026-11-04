import 'package:flutter/material.dart';

import '../../app_scope.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, required this.onAuthed});

  final VoidCallback onAuthed;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _email = TextEditingController(text: 'demo@wicart.local');
  final _password = TextEditingController(text: 'password123');
  final _name = TextEditingController(text: 'Demo');
  bool _register = false;
  bool _busy = false;
  String? _error;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _name.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() {
      _busy = true;
      _error = null;
    });
    final scope = AppScope.of(context);
    try {
      if (_register) {
        await scope.api.register(
          name: _name.text.trim(),
          email: _email.text.trim(),
          password: _password.text,
        );
      } else {
        await scope.api.login(
          email: _email.text.trim(),
          password: _password.text,
        );
      }
      final userId = await scope.api.getUserId();
      await scope.repo.onUserSwitch(userId);
      await scope.repo.ensureDefaults();
      await scope.sync.syncNow();
      if (!mounted) return;
      widget.onAuthed();
    } catch (e) {
      if (mounted) setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            const SizedBox(height: 48),
            Text('wi-cart',
                style: Theme.of(context).textTheme.headlineLarge,
                textAlign: TextAlign.center),
            const SizedBox(height: 8),
            Text('Offline-first',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 32),
            if (_register)
              TextField(
                controller: _name,
                decoration: const InputDecoration(labelText: 'Nombre'),
              ),
            TextField(
              controller: _email,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _password,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Password'),
            ),
            if (_error != null) ...[
              const SizedBox(height: 12),
              Text(_error!, style: TextStyle(color: Theme.of(context).colorScheme.error)),
            ],
            const SizedBox(height: 24),
            FilledButton(
              onPressed: _busy ? null : _submit,
              child: Text(_register ? 'Crear cuenta' : 'Entrar'),
            ),
            TextButton(
              onPressed: _busy
                  ? null
                  : () => setState(() => _register = !_register),
              child: Text(_register
                  ? '¿Ya tienes cuenta? Entrar'
                  : 'Crear cuenta'),
            ),
            const SizedBox(height: 12),
            Text(
              'Sin red: tras login previo la app sigue usable. Sync al recuperar conexión.',
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
