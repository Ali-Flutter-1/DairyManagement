import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;


  Future<void> addUserData({
    required String farmName,
    required String ownerName,
    required String ownerNumber,
    required double pricePerLiter,
  }) async {
    // Check if data already exists
    final existingData = await _firestore.collection('users').limit(1).get();

    if (existingData.docs.isNotEmpty) {
      // Update existing document
      await existingData.docs.first.reference.update({
        'farmName': farmName,
        'ownerName': ownerName,
        'ownerNumber': ownerNumber,
        'pricePerLiter': pricePerLiter,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } else {
      // Add new document if none exists
      await _firestore.collection('users').add({
        'farmName': farmName,
        'ownerName': ownerName,
        'ownerNumber': ownerNumber,
        'pricePerLiter': pricePerLiter,
        'createdAt': FieldValue.serverTimestamp(),
      });
    }
  }

  // Fetch existing data (for pre-filling)
  Future<Map<String, dynamic>?> getUserData() async {
    final snapshot = await _firestore.collection('users').limit(1).get();
    if (snapshot.docs.isNotEmpty) {
      return snapshot.docs.first.data();
    }
    return null;
  }


}
