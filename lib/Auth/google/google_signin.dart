

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dairyapp/CustomWidets/custom_toast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<User?> signInWithGoogle(BuildContext context) async {
    try {
      // Start Google Sign-In
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;

      // Get auth details from Google
      final GoogleSignInAuthentication googleAuth =
      await googleUser.authentication;

      // Create new credential for Firebase
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the credential
      final UserCredential userCredential =
      await _auth.signInWithCredential(credential);
      final User? user = userCredential.user;

      // ✅ Store or update user data in Firestore
      if (user != null) {
        final userDoc = _firestore.collection('users').doc(user.uid);
        final docSnapshot = await userDoc.get();

        if (!docSnapshot.exists) {
          // Create new user document
          await userDoc.set({
            'uid': user.uid,
            'name': user.displayName,
            'email': user.email,
            'photoUrl': user.photoURL,
            'signInMethod': 'google',
            'createdAt': FieldValue.serverTimestamp(),
          });
        } else {
          // Optional: update existing user data
          await userDoc.update({
            'lastLogin': FieldValue.serverTimestamp(),
          });
        }
      }

      return user;
    } catch (e) {
      showCustomToast(context,'Google Sign-In failed: $e');
      return null;
    }
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }
  /// 🔹 Get current logged-in Firebase user
   User? get currentUser => _auth.currentUser;

  /// 🔹 Get current Firebase ID Token (JWT)
   Future<String?> getIdToken() async {
    final user = _auth.currentUser;
    if (user != null) {
      return await user.getIdToken();
    }
    return null;
  }
}






















