import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:health/auth/auth_page.dart';
import 'package:health/screens/main_screen.dart';
// Ensure you import LoginPage

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return const MainScreen();
          } else {
            return const AuthPage();
          }
        },
      ), // StreamBuilder
    ); // Scaffold
  }
}
