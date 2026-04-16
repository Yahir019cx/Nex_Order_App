import 'package:flutter/material.dart';
import 'features/Auth/login_screen.dart';
import 'features/dashboard/app_shell.dart';

void main() {
  runApp(const NexOrderApp());
}

class NexOrderApp extends StatelessWidget {
  const NexOrderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NexOrder Pro',
      debugShowCheckedModeBanner: false,
      home: const LoginScreen(),
      routes: {
        '/dashboard': (_) => const AppShell(),
      },
    );
  }
}
