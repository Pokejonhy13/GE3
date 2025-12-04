class Paquete {
  final int id;
  final String codigo;
  final String direccionDestino;
  final String? descripcion;

  Paquete({
    required this.id,
    required this.codigo,
    required this.direccionDestino,
    this.descripcion,
  });

  factory Paquete.fromJson(Map<String, dynamic> json) {
    return Paquete(
      id: json['id'] ?? 0,
      codigo: json['codigo'] ?? '',
      direccionDestino: json['direccion_destino'] ?? '',
      descripcion: json['descripcion'],
    );
  }
}
