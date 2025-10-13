import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:dairyapp/screens/BottomNavBar/bottom_nav.dart';
import 'package:dairyapp/Auth/login/login_screen.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(color: Color(0xFF7CB342)),
            ),
          );
        }


        if (snapshot.hasData) {
          return const BottomBar();
        }


        return const LoginScreen();
      },
    );
  }
}
