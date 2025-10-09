import 'package:flutter/material.dart';
import '../Firebase/FirebaseService.dart';

class FarmProvider extends ChangeNotifier {
  final FirebaseService _firebaseService = FirebaseService();

  String farmName = '';
  String ownerName = '';
  String ownerNumber = '';
  double pricePerLiter = 0.0;
  bool isLoading = true;

  Future<void> loadFarmData() async {
    isLoading = true;
    notifyListeners();

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

}
