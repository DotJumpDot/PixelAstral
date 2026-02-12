import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class HttpService {
  static const String _baseUrl = 'http://localhost:3000';
  static const String _tokenKey = 'auth_token';

  static String _token = '';

  static Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString(_tokenKey) ?? '';
  }

  static Future<void> setToken(String token) async {
    _token = token;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  static Future<void> clearToken() async {
    _token = '';
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }

  static String? get token => _token.isNotEmpty ? _token : null;

  static Map<String, String> _getHeaders({bool requireAuth = true}) {
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (requireAuth && _token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $_token';
    }

    return headers;
  }

  static Future<http.Response> get(String endpoint, {bool requireAuth = true}) async {
    final uri = Uri.parse('$_baseUrl$endpoint');
    return http.get(uri, headers: _getHeaders(requireAuth: requireAuth));
  }

  static Future<http.Response> post(
    String endpoint, {
    Map<String, dynamic>? body,
    bool requireAuth = true,
  }) async {
    final uri = Uri.parse('$_baseUrl$endpoint');
    return http.post(
      uri,
      headers: _getHeaders(requireAuth: requireAuth),
      body: body != null ? jsonEncode(body) : null,
    );
  }

  static Future<http.Response> put(
    String endpoint, {
    Map<String, dynamic>? body,
    bool requireAuth = true,
  }) async {
    final uri = Uri.parse('$_baseUrl$endpoint');
    return http.put(
      uri,
      headers: _getHeaders(requireAuth: requireAuth),
      body: body != null ? jsonEncode(body) : null,
    );
  }

  static Future<http.Response> delete(String endpoint, {bool requireAuth = true}) async {
    final uri = Uri.parse('$_baseUrl$endpoint');
    return http.delete(uri, headers: _getHeaders(requireAuth: requireAuth));
  }

  static Future<http.Response> patch(
    String endpoint, {
    Map<String, dynamic>? body,
    bool requireAuth = true,
  }) async {
    final uri = Uri.parse('$_baseUrl$endpoint');
    return http.patch(
      uri,
      headers: _getHeaders(requireAuth: requireAuth),
      body: body != null ? jsonEncode(body) : null,
    );
  }
}
