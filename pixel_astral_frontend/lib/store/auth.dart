import 'package:flutter/foundation.dart';
import '../service/user.dart';
import '../service/http.dart';

enum AuthStatus { authenticated, unauthenticated, loading }

class AuthProvider with ChangeNotifier {
  AuthStatus _status = AuthStatus.unauthenticated;
  String? _userId;
  String? _email;
  String? _errorMessage;

  AuthStatus get status => _status;
  String? get userId => _userId;
  String? get email => _email;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _status == AuthStatus.authenticated;

  Future<void> init() async {
    _status = AuthStatus.loading;
    notifyListeners();

    await HttpService.init();

    final token = HttpService.token;
    if (token != null) {
      try {
        final profile = await UserService.getProfile();
        _userId = profile.id;
        _email = profile.email;
        _status = AuthStatus.authenticated;
      } catch (e) {
        _status = AuthStatus.unauthenticated;
      }
    } else {
      _status = AuthStatus.unauthenticated;
    }

    notifyListeners();
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    _status = AuthStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      final data = await UserService.login(email: email, password: password);
      _email = data['user']['email'];
      _userId = data['user']['id'];
      _status = AuthStatus.authenticated;
    } catch (e) {
      _errorMessage = e.toString();
      _status = AuthStatus.unauthenticated;
    }

    notifyListeners();
  }

  Future<void> register({
    required String email,
    required String password,
    required String name,
  }) async {
    _status = AuthStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      await UserService.register(
        email: email,
        password: password,
        name: name,
      );
      await login(email: email, password: password);
    } catch (e) {
      _errorMessage = e.toString();
      _status = AuthStatus.unauthenticated;
    }

    notifyListeners();
  }

  Future<void> logout() async {
    await HttpService.clearToken();
    _status = AuthStatus.unauthenticated;
    _userId = null;
    _email = null;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
