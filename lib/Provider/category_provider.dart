import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CategoryProvider extends ChangeNotifier {
  final List<String> _defaultCategories = [];
  List<String> _userCategories = [];
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CategoryProvider() {
    fetchCategories();
  }

  List<String> get categories => [..._defaultCategories, ..._userCategories];

  Future<void> fetchCategories() async {
    try {
      final snapshot = await _firestore.collection('categories').get();
      _userCategories = snapshot.docs.map((doc) => doc['name'] as String).toList();
      notifyListeners();
    } catch (e) {
      debugPrint("Error fetching categories: $e");
    }
  }

  Future<void> addCategory(String name) async {
    if (_userCategories.contains(name) || _defaultCategories.contains(name)) return;

    try {
      await _firestore.collection('categories').add({'name': name});
      _userCategories.add(name);
      notifyListeners();
    } catch (e) {
      debugPrint("Error adding category: $e");
    }
  }
  Future<void> removeCategory(String category) async {
    try {

      final snapshot = await _firestore
          .collection('categories')
          .where('name', isEqualTo: category)
          .get();

      for (var doc in snapshot.docs) {
        await doc.reference.delete();
      }


      _userCategories.remove(category);

      // Notify UI
      notifyListeners();
    } catch (e) {
      debugPrint("Error removing category: $e");
    }
  }

}
