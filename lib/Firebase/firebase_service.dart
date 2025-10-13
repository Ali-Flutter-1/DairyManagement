import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> addUserData({
    required String farmName,
    required String ownerName,
    required String ownerNumber,
    required double pricePerLiter,
  }) async {
    final uid = _auth.currentUser!.uid;

    await _firestore.collection('users').doc(uid).set({
      'farmName': farmName,
      'ownerName': ownerName,
      'ownerNumber': ownerNumber,
      'pricePerLiter': pricePerLiter,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Future<Map<String, dynamic>?> getUserData() async {
    final uid = _auth.currentUser!.uid;
    final snapshot = await _firestore.collection('users').doc(uid).get();
    return snapshot.data();
  }
}
