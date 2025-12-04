import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final nombreCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: const Text('Registro de agente')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nombreCtrl,
              decoration: const InputDecoration(labelText: 'Nombre'),
            ),
            TextField(
              controller: emailCtrl,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: passCtrl,
              decoration: const InputDecoration(labelText: 'Contraseña'),
              obscureText: true,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: loading
                  ? null
                  : () async {
                      setState(() => loading = true);
                      final res = await auth.register(
                        nombreCtrl.text,
                        emailCtrl.text,
                        passCtrl.text,
                      );
                      setState(() => loading = false);

                      if (res['ok'] == true) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Registrado. Ahora inicia sesión.'),
                          ),
                        );
                        Navigator.pop(context);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Error: ${res['message'] ?? 'desconocido'}',
                            ),
                          ),
                        );
                      }
                    },
              child: loading
                  ? const CircularProgressIndicator()
                  : const Text('Registrar'),
            ),
          ],
        ),
      ),
    );
  }
}
