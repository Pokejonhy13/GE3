import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'screens/auth/login_screen.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const myGreen = Color(0xFF093307); 

    return ChangeNotifierProvider(
      create: (_) => AuthProvider()..init(),
      child: Consumer<AuthProvider>(
        builder: (context, auth, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'AgenteSmart',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: myGreen),
              useMaterial3: true,
              appBarTheme: const AppBarTheme(
                backgroundColor: myGreen,
                foregroundColor: Colors.white,
                centerTitle: true,
              ),
              elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                  backgroundColor: myGreen,
                  foregroundColor: Colors.white,
                ),
              ),
              
              textSelectionTheme: const TextSelectionThemeData(
                cursorColor: myGreen,
              ),
              inputDecorationTheme: const InputDecorationTheme(
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: myGreen),
                ),
                labelStyle: TextStyle(color: myGreen),
              ),
            ),

            home: auth.isInitializing
                ? const Scaffold(body: Center(child: CircularProgressIndicator()))
                : auth.isAuthenticated
                    ? const HomeScreen()
                    : const LoginScreen(),
          );
        },
      ),
    );
  }
}