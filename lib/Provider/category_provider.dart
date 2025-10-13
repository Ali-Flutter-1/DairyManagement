import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CategoryProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  List<String> _userCategories = [];

  CategoryProvider() {

    _auth.authStateChanges().listen((_) {
      fetchCategories();
    });
    fetchCategories();
  }

  List<String> get categories => _userCategories;
  String? get _uid => _auth.currentUser?.uid;

  /// 🔹 Fetch user’s own categories
  Future<void> fetchCategories() async {
    _userCategories.clear();
    final uid = _uid;
    if (uid == null) {
      notifyListeners();
      return;
    }

    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(uid)
          .collection('categories')
          .orderBy('createdAt', descending: true)
          .get();

      _userCategories = snapshot.docs
          .map((doc) => (doc['name'] as String).trim())
          .where((name) => name.isNotEmpty)
          .toList();

      notifyListeners();
    } catch (e) {
      debugPrint("Error fetching user categories: $e");
    }
  }

  /// 🔹 Add a category for this user only
  Future<void> addCategory(String name) async {
    final uid = _uid;
    if (uid == null || name.trim().isEmpty) return;

    // prevent duplicates locally
    if (_userCategories.contains(name.trim())) return;

    try {
      await _firestore
          .collection('users')
          .doc(uid)
          .collection('categories')
          .add({
        'name': name.trim(),
        'createdAt': FieldValue.serverTimestamp(),
      });

      _userCategories.add(name.trim());
      notifyListeners();
    } catch (e) {
      debugPrint("Error adding category: $e");
    }
  }

  /// 🔹 Remove category from this user’s list
  Future<void> removeCategory(String name) async {
    final uid = _uid;
    if (uid == null) return;

    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(uid)
          .collection('categories')
          .where('name', isEqualTo: name.trim())
          .get();

      for (var doc in snapshot.docs) {
        await doc.reference.delete();
      }

      _userCategories.remove(name.trim());
      notifyListeners();
    } catch (e) {
      debugPrint("Error removing category: $e");
    }
  }
}
