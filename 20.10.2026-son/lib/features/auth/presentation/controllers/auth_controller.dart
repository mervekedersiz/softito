import 'package:flutter/foundation.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../data/repositories/mock_auth_repository.dart';

/// State controller managing authentication and permission checking.
class AuthController extends ChangeNotifier {
  AuthController({AuthRepository? repository})
      : _repository = repository ?? MockAuthRepository() {
    _loadInitial();
  }

  final AuthRepository _repository;
  User? _currentUser = const User(
    id: 'user-001',
    name: 'Ahmet Yılmaz',
    email: 'ahmet@yol.com',
    role: UserRole.customer,
  );
  bool _isLoading = false;
  String? _errorMessage;

  User? get currentUser => _currentUser;
  bool get isLoggedIn => _currentUser != null;
  bool get isAdmin => _currentUser?.isAdmin ?? false;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> _loadInitial() async {
    _currentUser = await _repository.getCurrentUser();
    notifyListeners();
  }

  /// Yetki bazlı sorgulama (Permission check)
  bool hasPermission(AppPermission permission) {
    if (_currentUser == null) return false;
    return _currentUser!.hasPermission(permission);
  }

  /// Hızlı test için rol değiştirici
  void switchRole(UserRole newRole) {
    if (_currentUser == null) {
      _currentUser = User(
        id: 'usr-demo',
        name: newRole == UserRole.admin ? 'Yönetici Admin' : 'Demo Kullanıcı',
        email: newRole == UserRole.admin ? 'admin@yol.com' : 'user@yol.com',
        role: newRole,
      );
    } else {
      _currentUser = _currentUser!.copyWith(role: newRole);
    }
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      _currentUser = await _repository.login(email: email, password: password);
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> register({
    required String name,
    required String email,
    required String password,
    required UserRole role,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      _currentUser = await _repository.register(
        name: name,
        email: email,
        password: password,
        role: role,
      );
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    await _repository.logout();
    _currentUser = null;
    notifyListeners();
  }
}
