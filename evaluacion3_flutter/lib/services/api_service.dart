import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../constants.dart';

class ApiService {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<String?> getToken() async => await _storage.read(key: 'access_token');

  Future saveToken(String token) async =>
      await _storage.write(key: 'access_token', value: token);

  Future deleteToken() async => await _storage.delete(key: 'access_token');

  Future<http.Response> post(
    String path,
    Map<String, dynamic> body, {
    bool auth = false,
    bool useFormUrlEncode = false,
  }) async {
    final uri = Uri.parse("$API_BASE_URL$path");
    Map<String, String> headers = {};

    if (useFormUrlEncode) {
      headers['Content-Type'] = 'application/x-www-form-urlencoded';
    } else {
      headers['Content-Type'] = 'application/json';
    }

    if (auth) {
      final token = await getToken();
      if (token != null) headers['Authorization'] = 'Bearer $token';
    }

    final encodedBody = useFormUrlEncode
        ? body.entries
              .map(
                (e) =>
                    "${Uri.encodeQueryComponent(e.key)}=${Uri.encodeQueryComponent(e.value.toString())}",
              )
              .join("&")
        : jsonEncode(body);

    return await http.post(uri, headers: headers, body: encodedBody);
  }

  Future<http.Response> get(
    String path, {
    bool auth = false,
    Map<String, String>? params,
  }) async {
    var uri = Uri.parse("$API_BASE_URL$path");
    if (params != null) uri = uri.replace(queryParameters: params);

    final headers = <String, String>{'Content-Type': 'application/json'};
    if (auth) {
      final token = await getToken();
      if (token != null) headers['Authorization'] = 'Bearer $token';
    }

    return await http.get(uri, headers: headers);
  }
}
