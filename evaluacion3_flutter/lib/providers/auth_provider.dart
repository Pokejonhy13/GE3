import 'package:flutter/material.dart';

import '../services/auth_service.dart';
import '../models/user.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  String? _token;
  User? _user;
  bool _isInitializing = true;

  bool get isAuthenticated => _token != null;
  User? get user => _user;
  bool get isInitializing => _isInitializing;

  Future init() async {
    _isInitializing = true;
    notifyListeners();

    _token = await _authService.getToken();

    if (_token != null) {
      try {
        final profile = await _authService.getProfile();
        _user = profile;
      } catch (_) {
        _user = null;
      }
    }

    _isInitializing = false;
    notifyListeners();
  }

  Future<Map<String, dynamic>> login(
    String email,
    String password, {
    bool useFormUrlEncode = false,
  }) async {
    final res = await _authService.login(
      email,
      password,
      useFormUrlEncode: useFormUrlEncode,
    );

    if (res['ok'] == true && res['token'] != null) {
      _token = res['token'];
      final profile = await _authService.getProfile();
      _user = profile;
      notifyListeners();
      return {"ok": true};
    } else {
      return {
        "ok": false,
        "message": res['body'] ?? res['message'] ?? "Error login",
      };
    }
  }

  Future<Map<String, dynamic>> register(
    String nombre,
    String email,
    String password,
  ) async {
    try {
      final res = await _authService.registerRaw(nombre, email, password);
      if (res.statusCode == 201 || res.statusCode == 200) {
        return {"ok": true};
      } else {
        return {"ok": false, "message": res.body};
      }
    } catch (e) {
      return {"ok": false, "message": e.toString()};
    }
  }

Future logout() async {
    try {
      await _authService.logout(); 
    } catch (e) {
      print("Error al hacer logout del servicio: $e");
    }
    _token = null;
    _user = null;
    //Avisar al maim para que cambie la pantalla
    notifyListeners(); 
  }
}
