class Evidencia {
  final int id;
  final int entregaId;
  final String rutaFoto;
  final String? descripcionFoto;
  final double latitude;
  final double longitude;
  final String? direccionTexto;

  Evidencia({
    required this.id,
    required this.entregaId,
    required this.rutaFoto,
    this.descripcionFoto,
    required this.latitude,
    required this.longitude,
    this.direccionTexto,
  });

  factory Evidencia.fromJson(Map<String, dynamic> json) {
    return Evidencia(
      id: json['id'] ?? 0,
      entregaId: json['entrega_id'] ?? 0,
      rutaFoto: json['ruta_foto'] ?? '',
      descripcionFoto: json['descripcion_foto'],
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      direccionTexto: json['direccion_texto'],
    );
  }
}
