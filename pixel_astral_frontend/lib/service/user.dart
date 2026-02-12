import 'dart:convert';
import '../type/user.dart';
import 'http.dart';

class UserService {
  static const String _authEndpoint = '/api/auth';
  static const String _userEndpoint = '/api/users';

  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final response = await HttpService.post(
      '$_authEndpoint/login',
      body: {
        'email': email,
        'password': password,
      },
      requireAuth: false,
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final token = data['token'] as String;
      await HttpService.setToken(token);
      return data;
    } else {
      final error = jsonDecode(response.body);
      throw Exception(error['message'] ?? 'Failed to login');
    }
  }

  static Future<Map<String, dynamic>> register({
    required String email,
    required String password,
    required String name,
  }) async {
    final response = await HttpService.post(
      '$_authEndpoint/register',
      body: {
        'email': email,
        'password': password,
        'name': name,
      },
      requireAuth: false,
    );

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      final error = jsonDecode(response.body);
      throw Exception(error['message'] ?? 'Failed to register');
    }
  }

  static Future<UserModel> getProfile() async {
    final response = await HttpService.get('$_userEndpoint/me');

    if (response.statusCode == 200) {
      return UserModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load profile');
    }
  }

  static Future<UserModel> updateProfile({
    String? name,
  }) async {
    final body = <String, dynamic>{};

    if (name != null) body['name'] = name;

    final response = await HttpService.put(
      '$_userEndpoint/me',
      body: body,
    );

    if (response.statusCode == 200) {
      return UserModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update profile');
    }
  }
}
