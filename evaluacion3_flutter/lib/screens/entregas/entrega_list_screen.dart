import 'package:flutter/material.dart';

import '../../models/entrega.dart';
import '../../services/entrega_service.dart';
import 'entrega_detail_screen.dart';

class EntregaListScreen extends StatefulWidget {
  const EntregaListScreen({super.key});

  @override
  State<EntregaListScreen> createState() => _EntregaListScreenState();
}

class _EntregaListScreenState extends State<EntregaListScreen> {
  final EntregaService _service = EntregaService();
  List<Entrega> entregas = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _cargarEntregas();
  }

  Future _cargarEntregas() async {
    setState(() => loading = true);
    final data = await _service.obtenerEntregasAsignadas();
    setState(() {
      entregas = data;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Entregas asignadas')),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: entregas.length,
              itemBuilder: (context, index) {
                final e = entregas[index];
                final destino = e.paquete?.direccionDestino ?? '';
                final codigo = e.paquete?.codigo ?? e.id.toString();

                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: ListTile(
                    leading: CircleAvatar(child: Text(e.id.toString())),
                    title: Text('Paquete $codigo'),
                    subtitle: Text(destino),
                    trailing: Text(e.estado),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => EntregaDetailScreen(entrega: e),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}
