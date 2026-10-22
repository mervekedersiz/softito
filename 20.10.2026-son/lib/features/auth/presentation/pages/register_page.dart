import 'package:flutter/material.dart';
import '../../../../app/app_scope.dart';
import '../../domain/entities/user.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  UserRole _selectedRole = UserRole.customer;
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;
    final auth = AppScope.of(context).auth;
    final feedback = AppScope.of(context).feedback;
    final nav = Navigator.of(context);

    final success = await auth.register(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
      role: _selectedRole,
    );

    if (!mounted) return;

    if (success) {
      feedback.postSuccess(
        title: 'Hesap Oluşturuldu',
        message: 'Hoş geldiniz ${_nameController.text}! ${_selectedRole.title} yetkisi verildi.',
      );
      nav.pop();
    } else {
      feedback.postFailure(
        title: 'Kayıt Başarısız',
        message: auth.errorMessage ?? 'Kayıt işlemi gerçekleştirilemedi.',
        code: 'REGISTER_FAILED',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final auth = AppScope.of(context).auth;

    return Scaffold(
      appBar: AppBar(title: const Text('Kayıt Ol')),
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
                  Text(
                    'Yeni YolOrtağım Hesabı',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Rolünüzü seçerek mobilite ekosistemine katılın',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 24),
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Ad Soyad',
                      prefixIcon: Icon(Icons.badge_outlined),
                    ),
                    validator: (v) => v == null || v.isEmpty ? 'Adınızı girin.' : null,
                  ),
                  const SizedBox(height: 16),
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
                      prefixIcon: Icon(Icons.lock_outline),
                    ),
                    validator: (v) => v == null || v.length < 4 ? 'En az 4 karakter girin.' : null,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Kullanıcı Rolü & Yetki Türü',
                    style: theme.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<UserRole>(
                    initialValue: _selectedRole,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.verified_user_outlined),
                    ),
                    items: [
                      for (final role in UserRole.values)
                        DropdownMenuItem(
                          value: role,
                          child: Text('${role.title} (${role.name})'),
                        ),
                    ],
                    onChanged: (r) => setState(() => _selectedRole = r ?? UserRole.customer),
                  ),
                  const SizedBox(height: 28),
                  ListenableBuilder(
                    listenable: auth,
                    builder: (context, _) => FilledButton.icon(
                      onPressed: auth.isLoading ? null : _handleRegister,
                      icon: const Icon(Icons.person_add),
                      label: const Text('Hesabı Oluştur'),
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
