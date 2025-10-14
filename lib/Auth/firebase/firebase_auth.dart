import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../Provider/provider_manager.dart';
import '../../screens/BottomNavBar/bottom_nav.dart';
import '../login/login_screen.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // 🔹 Signup
  Future<String?> signUp(
      String email, String password, String confirmPassword, BuildContext context) async {
    if (password != confirmPassword) {
      return "Passwords do not match!";
    }

    try {
      await _auth.createUserWithEmailAndPassword(email: email, password: password);

      // Navigate to home screen wrapped in providers (no manual reset needed)
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => ProviderManager.buildWithProviders(BottomBar()),
        ),
      );

      return "Success";
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'email-already-in-use':
          return "This email is already registered.";
        case 'invalid-email':
          return "Please enter a valid email address.";
        case 'weak-password':
          return "Password should be at least 6 characters.";
        default:
          return e.message;
      }
    } catch (e) {
      return "An unknown error occurred";
    }
  }

  // 🔹 Login
  Future<String?> login(String email, String password, BuildContext context) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);

      // Navigate to home screen wrapped in providers (no manual reset needed)
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => ProviderManager.buildWithProviders(BottomBar()),
        ),
      );

      return "Success";
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
          return "No user found for that email.";
        case 'wrong-password':
          return "Incorrect password. Try again.";
        case 'invalid-email':
          return "Invalid email format.";
        default:
          return e.message;
      }
    } catch (e) {
      return "An unknown error occurred";
    }
  }

  // 🔹 Logout
  Future<void> logout(BuildContext context) async {
    await _auth.signOut();

    // Clear all providers before navigating
    ProviderManager.resetProviders(context);

    // Navigate to login screen
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => LoginScreen()),
          (route) => false,
    );
  }
}