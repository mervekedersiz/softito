import 'package:flutter/material.dart';
import '../../../../app/app_scope.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController(text: 'ahmet@yol.com');
  final _passwordController = TextEditingController(text: '123456');
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _fillQuick(String email, String roleName) {
    _emailController.text = email;
    _passwordController.text = '123456';
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$roleName hesabı otomatik dolduruldu.')),
    );
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;
    final auth = AppScope.of(context).auth;
    final feedback = AppScope.of(context).feedback;
    final nav = Navigator.of(context);

    final success = await auth.login(
      _emailController.text.trim(),
      _passwordController.text.trim(),
    );

    if (!mounted) return;

    if (success) {
      feedback.postSuccess(
        title: 'Giriş Başarılı',
        message: 'Hoş geldiniz, ${auth.currentUser?.name} (${auth.currentUser?.role.title})',
      );
      nav.pop();
    } else {
      feedback.postFailure(
        title: 'Giriş Başarısız',
        message: auth.errorMessage ?? 'Giriş yapılamadı. Bilgilerinizi kontrol edin.',
        code: 'AUTH_FAILED',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final auth = AppScope.of(context).auth;

    return Scaffold(
      appBar: AppBar(title: const Text('Giriş Yap')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 440),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [colors.primaryContainer, colors.surface],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        Icon(Icons.lock_person_rounded, size: 52, color: colors.primary),
                        const SizedBox(height: 12),
                        Text(
                          'YolOrtağım Giriş',
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Rolünüze göre yetkileriniz otomatik yüklenecektir',
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colors.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Hızlı Test Hesapları (Tek Dokunuşla)',
                    style: theme.textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: [
                      ActionChip.elevated(
                        avatar: const Icon(Icons.admin_panel_settings, size: 16),
                        label: const Text('Admin Girişi'),
                        onPressed: () => _fillQuick('admin@yol.com', 'Admin'),
                      ),
                      ActionChip.elevated(
                        avatar: const Icon(Icons.person, size: 16),
                        label: const Text('Müşteri Girişi'),
                        onPressed: () => _fillQuick('ahmet@yol.com', 'Müşteri'),
                      ),
                      ActionChip.elevated(
                        avatar: const Icon(Icons.electric_scooter, size: 16),
                        label: const Text('Sürücü Girişi'),
                        onPressed: () => _fillQuick('surucu@yol.com', 'Sürücü'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'E-posta Adresi',
                      prefixIcon: Icon(Icons.alternate_email),
                    ),
                    validator: (v) => v == null || !v.contains('@') ? 'Geçerli bir e-posta girin.' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Şifre',
                      prefixIcon: Icon(Icons.key),
                    ),
                    validator: (v) => v == null || v.length < 4 ? 'Şifre en az 4 karakter olmalıdır.' : null,
                  ),
                  const SizedBox(height: 24),
                  ListenableBuilder(
                    listenable: auth,
                    builder: (context, _) => FilledButton.icon(
                      onPressed: auth.isLoading ? null : _handleLogin,
                      icon: auth.isLoading
                          ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                          : const Icon(Icons.login),
                      label: Text(auth.isLoading ? 'Giriş Yapılıyor...' : 'Giriş Yap'),
                      style: FilledButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
