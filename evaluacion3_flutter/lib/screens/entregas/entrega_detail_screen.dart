// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../../models/entrega.dart';
import '../../models/evidencia.dart';
import '../../services/entrega_service.dart';

class EntregaDetailScreen extends StatefulWidget {
  final Entrega entrega;

  const EntregaDetailScreen({super.key, required this.entrega});

  @override
  State<EntregaDetailScreen> createState() => _EntregaDetailScreenState();
}

class _EntregaDetailScreenState extends State<EntregaDetailScreen> {
  final EntregaService _service = EntregaService();
  final ImagePicker _picker = ImagePicker();
  final descripcionCtrl = TextEditingController();

  XFile? _pickedFile;
  Position? _position;
  Evidencia? _evidencia;
  bool _sending = false;
  Uint8List? _webImageBytes;

  Future _tomarFoto() async {
  try {
    final XFile? foto = await _picker.pickImage(source: ImageSource.camera);
    if (foto != null) {
      Uint8List? webBytes;
      if (kIsWeb) {
        webBytes = await foto.readAsBytes();
      }

      setState(() {
        _pickedFile = foto;
        _webImageBytes = webBytes; // puede ser null en móvil
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Foto tomada correctamente ✅')),
      );
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error al tomar la foto: $e')),
    );
  }
}


  Future _obtenerUbicacion() async {
    try {
      LocationPermission perm = await Geolocator.checkPermission();
      if (perm == LocationPermission.denied) {
        perm = await Geolocator.requestPermission();
      }
      if (perm == LocationPermission.deniedForever ||
          perm == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Permiso de GPS denegado')),
        );
        return;
      }

      final pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {
        _position = pos;
      });
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error al obtener ubicación: $e')));
    }
  }

  Future _enviarEvidencia() async {
    if (_pickedFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Primero toma una foto')),
      );
      return;
    }
    if (_position == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Primero obtén la ubicación')),
      );
      return;
    }

    setState(() => _sending = true);

    final ev = await _service.enviarEvidenciaEntrega(
      entregaId: widget.entrega.id,
      latitude: _position!.latitude,
      longitude: _position!.longitude,
      descripcionFoto: descripcionCtrl.text,
      filePath: _pickedFile!.path,
      fileName: _pickedFile!.name,
      fileBytes: kIsWeb ? _webImageBytes : null,
    );

    setState(() {
      _evidencia = ev;
      _sending = false;
    });

    if (ev != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Paquete entregado y evidencia guardada')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al registrar evidencia')),
      );
    }
  }


  Widget _buildMapa() {
    if (_position == null) {
      return const Text(
        'Aún no hay ubicación. Presiona "Obtener ubicación".',
        textAlign: TextAlign.center,
      );
    }

    final point = LatLng(_position!.latitude, _position!.longitude);

    return SizedBox(
      height: 250,
      child: FlutterMap(
        options: MapOptions(
          center: point, // antes: initialCenter
          zoom: 17, // antes: initialZoom
        ),
        children: [
          TileLayer(
            urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
            userAgentPackageName: 'com.example.paquexpress_app',
          ),
          MarkerLayer(
            markers: [
              Marker(
                point: point,
                width: 40,
                height: 40,
                builder: (context) => const Icon(
                  // antes: child:
                  Icons.location_on,
                  color: Colors.red,
                  size: 40,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFotoPreview() {
    if (_pickedFile == null) {
      return const Text('No hay imagen seleccionada');
    }

    if (kIsWeb) {
      if (_webImageBytes == null) {
        return const Text('Imagen no disponible');
      }
      return Image.memory(
        _webImageBytes!,
        width: 250,
      );
    } else {
      return Image.file(
        File(_pickedFile!.path),
        width: 250,
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    final paquete = widget.entrega.paquete;
    final destino = paquete?.direccionDestino ?? '';
    final codigo = paquete?.codigo ?? widget.entrega.id.toString();

    return Scaffold(
      appBar: AppBar(title: Text('Entrega paquete $codigo')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Destino:', style: Theme.of(context).textTheme.titleMedium),
            Text(destino),
            const SizedBox(height: 16),
            Text('Foto de evidencia'),
            const SizedBox(height: 8),
            _buildFotoPreview(),
            const SizedBox(height: 8),
            TextField(
              controller: descripcionCtrl,
              decoration: const InputDecoration(
                labelText: 'Descripción de la foto',
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: _tomarFoto,
                  icon: const Icon(Icons.camera_alt),
                  label: const Text('Tomar foto'),
                ),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  onPressed: _obtenerUbicacion,
                  icon: const Icon(Icons.my_location),
                  label: const Text('Obtener ubicación'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text('Mapa del punto de entrega'),
            const SizedBox(height: 8),
            _buildMapa(),
            const SizedBox(height: 16),
            Center(
              child: ElevatedButton.icon(
                onPressed: _sending ? null : _enviarEvidencia,
                icon: const Icon(Icons.check),
                label: _sending
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Paquete entregado'),
              ),
            ),
            const SizedBox(height: 16),
            if (_evidencia != null)
              Text('Dirección detectada:\n${_evidencia!.direccionTexto ?? ''}'),
          ],
        ),
      ),
    );
  }
}
