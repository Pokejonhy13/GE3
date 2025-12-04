import 'paquete.dart';

class Entrega {
  final int id;
  final int paqueteId;
  final int agenteId;
  final String estado;
  final String? notas;
  final String? fechaAsignacion;
  final String? fechaEntregado;
  final Paquete? paquete;

  Entrega({
    required this.id,
    required this.paqueteId,
    required this.agenteId,
    required this.estado,
    this.notas,
    this.fechaAsignacion,
    this.fechaEntregado,
    this.paquete,
  });

  factory Entrega.fromJson(Map<String, dynamic> json) {
    return Entrega(
      id: json['id'] ?? 0,
      paqueteId: json['paquete_id'] ?? 0,
      agenteId: json['agente_id'] ?? 0,
      estado: json['estado'] ?? '',
      notas: json['notas'],
      fechaAsignacion: json['fecha_asignacion']?.toString(),
      fechaEntregado: json['fecha_entregado']?.toString(),
      paquete: json['paquete'] != null
          ? Paquete.fromJson(json['paquete'])
          : null,
    );
  }
}
