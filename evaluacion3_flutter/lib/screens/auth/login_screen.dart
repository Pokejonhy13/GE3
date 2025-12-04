import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  bool loading = false;
  bool useForm = true; // FastAPI OAuth2 usa form-urlencoded

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: const Text('AgenteSmart')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: emailCtrl,
              decoration: const InputDecoration(labelText: 'Correo'),
            ),
            TextField(
              controller: passCtrl,
              decoration: const InputDecoration(labelText: 'Contraseña'),
              obscureText: true,
            ),
            Row(
              children: [
                Checkbox(
                  value: useForm,
                  onChanged: (v) {
                    setState(() => useForm = v ?? false);
                  },
                ),
                const Expanded(
                  child: Text('Usar form-urlencoded para login OAuth2'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: loading
                  ? null
                  : () async {
                      setState(() => loading = true);
                      final res = await auth.login(
                        emailCtrl.text,
                        passCtrl.text,
                        useFormUrlEncode: useForm,
                      );
                      setState(() => loading = false);

                      if (res['ok'] == true) {
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Error login: ${res['message'] ?? ''}',
                            ),
                          ),
                        );
                      }
                    },
              child: loading
                  ? const CircularProgressIndicator()
                  : const Text('Entrar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const RegisterScreen()),
                );
              },
              child: const Text('Registrarse'),
            ),
          ],
        ),
      ),
    );
  }
}
