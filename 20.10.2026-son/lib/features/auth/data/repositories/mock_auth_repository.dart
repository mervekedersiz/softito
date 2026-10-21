import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';

class MockAuthRepository implements AuthRepository {
  MockAuthRepository();

  User? _currentUser = const User(
    id: 'user-001',
    name: 'Ahmet Yılmaz',
    email: 'ahmet@yol.com',
    role: UserRole.customer,
  );

  @override
  Future<User?> getCurrentUser() async {
    return _currentUser;
  }

  @override
  Future<User> login({required String email, required String password}) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    final cleanEmail = email.trim().toLowerCase();

    if (password.length < 4) {
      throw Exception('Şifre en az 4 karakter olmalıdır.');
    }

    if (cleanEmail.contains('admin')) {
      _currentUser = const User(
        id: 'admin-999',
        name: 'Mert Yönetici',
        email: 'admin@yol.com',
        role: UserRole.admin,
        walletBalanceTry: 25000.0,
      );
    } else if (cleanEmail.contains('driver') || cleanEmail.contains('surucu')) {
      _currentUser = const User(
        id: 'driver-502',
        name: 'Ayşe Kaya (Sürücü)',
        email: 'ayse@yol.com',
        role: UserRole.driver,
        walletBalanceTry: 6200.0,
      );
    } else {
      _currentUser = User(
        id: 'user-${DateTime.now().millisecondsSinceEpoch}',
        name: cleanEmail.split('@').first.toUpperCase(),
        email: cleanEmail,
        role: UserRole.customer,
      );
    }
    return _currentUser!;
  }

  @override
  Future<User> register({
    required String name,
    required String email,
    required String password,
    required UserRole role,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      throw Exception('Tüm alanları doldurmanız gerekmektedir.');
    }
    _currentUser = User(
      id: 'user-${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      email: email,
      role: role,
    );
    return _currentUser!;
  }

  @override
  Future<void> logout() async {
    await Future<void>.delayed(const Duration(milliseconds: 100));
    _currentUser = null;
  }
}
