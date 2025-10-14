import 'package:flutter/material.dart';
import '../Firebase/firebase_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FarmProvider extends ChangeNotifier {
  final FirebaseService _firebaseService = FirebaseService();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String farmName = '';
  String ownerName = '';
  String ownerNumber = '';
  double pricePerLiter = 0.0;
  bool isLoading = true;

  FarmProvider() {
    _auth.authStateChanges().listen((user) {
      if (user == null) {
        clear();
      } else {
        loadFarmData();
      }
    });
  }

  Future<void> loadFarmData() async {
    isLoading = true;
    notifyListeners();

    final uid = _auth.currentUser?.uid;
    if (uid == null) {
      isLoading = false;
      notifyListeners();
      return;
    }

    try {
      final data = await _firebaseService.getUserData();
      if (data != null) {
        farmName = data['farmName'] ?? '';
        ownerName = data['ownerName'] ?? '';
        ownerNumber = data['ownerNumber'] ?? '';
        pricePerLiter = (data['pricePerLiter'] ?? 0).toDouble();
      }
    } catch (e) {
      debugPrint('Error loading farm data: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void updateMilkPrice(double newPrice) {
    pricePerLiter = newPrice;
    notifyListeners();
  }

  void clear() {
    farmName = '';
    ownerName = '';
    ownerNumber = '';
    pricePerLiter = 0.0;
    isLoading = false;
    notifyListeners();
  }
}
