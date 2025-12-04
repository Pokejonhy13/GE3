import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'entregas/entrega_list_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final nombre = auth.user?.nombre ?? '';
    final email = auth.user?.email ?? '';

    return Scaffold(
      appBar: AppBar(
        title: const Text('SmartDelivery - Inicio'),
        actions: [
          IconButton(
            onPressed: () async {
              Provider.of<AuthProvider>(context, listen: false).logout();
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.asset(
                '../../assets/img/inicio.png',
                height: 150,  
                fit: BoxFit.contain, // Para que no se recorte
              ),
            ),
            const SizedBox(height: 30),
            Text('Bienvenido $nombre. Estamos felices de volverte a ver.', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 5),
            Text('Tu correo asociado: $email', style: TextStyle(color: const Color.fromARGB(255, 22, 41, 212))),
            
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity, 
              child: ElevatedButton.icon(
                icon: const Icon(Icons.local_shipping), // Un icono queda bonito
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  textStyle: const TextStyle(fontSize: 18),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const EntregaListScreen()),
                  );
                },
                label: const Text('Entregas Asignadas'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}