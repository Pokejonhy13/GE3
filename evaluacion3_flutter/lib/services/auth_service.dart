import 'dart:convert';
import 'package:http/http.dart' as http;

import 'api_service.dart';
import '../constants.dart';
import '../models/user.dart';

class AuthService {
  final ApiService _api = ApiService();

  Future<http.Response> registerRaw(
    String nombre,
    String email,
    String password,
  ) async {
    return await _api.post(AUTH_REGISTER, {
      'nombre': nombre,
      'email': email,
      'password': password,
    });
  }

  Future<Map<String, dynamic>> login(
    String email,
    String password, {
    bool useFormUrlEncode = false,
  }) async {
    final body = {'username': email, 'password': password};

    final res = await _api.post(
      AUTH_LOGIN,
      body,
      useFormUrlEncode: useFormUrlEncode,
    );

    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      String? token;
      if (data is Map) {
        token =
            data['access_token'] ??
            data['token'] ??
            data['accessToken'] ??
            (data['data'] is Map ? data['data']['access_token'] : null);
      }

      if (token != null) {
        await _api.saveToken(token);
        return {"ok": true, "token": token, "data": data};
      } else {
        return {
          "ok": false,
          "statusCode": res.statusCode,
          "body": res.body,
          "message": "No se encontró token en la respuesta",
        };
      }
    } else {
      return {"ok": false, "statusCode": res.statusCode, "body": res.body};
    }
  }

  Future logout() async {
    await _api.deleteToken();
  }

  Future<String?> getToken() async {
    return await _api.getToken();
  }

  Future<User?> getProfile() async {
    final res = await _api.get(AUTH_ME, auth: true);
    if (res.statusCode == 200) {
      final json = jsonDecode(res.body);
      return User.fromJson(Map<String, dynamic>.from(json));
    } else {
      return null;
    }
  }
}
