import 'dart:io' show File;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:typed_data';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'api_service.dart';
import '../constants.dart';
import '../models/entrega.dart';
import '../models/evidencia.dart';

class EntregaService {
  final ApiService _api = ApiService();

  Future<List<Entrega>> obtenerEntregasAsignadas() async {
    final res = await _api.get(ENTREGAS_ASIGNADAS, auth: true);
    if (res.statusCode == 200) {
      final data = jsonDecode(res.body) as List;
      return data
          .map((e) => Entrega.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    } else {
      return [];
    }
  }

  Future<Evidencia?> enviarEvidenciaEntrega({
    required int entregaId,
    required double latitude,
    required double longitude,
    String? descripcionFoto,
    required String filePath,
    required String fileName,
    Uint8List? fileBytes,
  }) async {
    final uri = Uri.parse("$API_BASE_URL$EVIDENCIA_ENTREGA");
    final request = http.MultipartRequest('POST', uri);

    final token = await _api.getToken();
    if (token != null) {
      request.headers['Authorization'] = 'Bearer $token';
    }

    request.fields['entrega_id'] = entregaId.toString();
    request.fields['latitude'] = latitude.toString();
    request.fields['longitude'] = longitude.toString();
    if (descripcionFoto != null) {
      request.fields['descripcion_foto'] = descripcionFoto;
    }

    if (kIsWeb) {
      // En Web usamos bytes
      if (fileBytes == null) {
        throw Exception('fileBytes es requerido en Web');
      }
      request.files.add(
        http.MultipartFile.fromBytes(
          'file',
          fileBytes,
          filename: fileName,
        ),
      );
    } else {
      // En móvil / escritorio usamos la ruta del archivo
      request.files.add(
        await http.MultipartFile.fromPath(
          'file',
          filePath,
          filename: fileName,
        ),
      );
    }

    final response = await request.send();
    final respStr = await response.stream.bytesToString();

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(respStr);
      final evJson = Map<String, dynamic>.from(data);
      return Evidencia.fromJson(evJson);
    } else {
      return null;
    }
  }
}
