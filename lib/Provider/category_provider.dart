import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CategoryProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  List<String> _userCategories = [];
  StreamSubscription<QuerySnapshot>? _subscription;
  String? _currentUid;

  List<String> get categories => _userCategories;

  CategoryProvider() {
    _auth.authStateChanges().listen((user) async {
      await _subscription?.cancel(); // Cancel previous Firestore listener safely
      if (user == null) {
        if (_currentUid != null) {
          clear();
        }
        _currentUid = null;
      } else {
        final newUid = user.uid;
        if (_currentUid != newUid) {
          clear();
          _currentUid = newUid;
        }
        fetchCategories();
      }
    });
  }

  Future<void> fetchCategories() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    _subscription?.cancel();
    _subscription = _firestore
        .collection('users')
        .doc(uid)
        .collection('categories')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .listen((snapshot) {
      _userCategories = snapshot.docs
          .map((doc) => (doc['name'] as String).trim())
          .where((name) => name.isNotEmpty)
          .toList();
      notifyListeners();
    });
  }

  Future<void> addCategory(String name) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null || name.trim().isEmpty) return;

    if (_userCategories.contains(name.trim())) return;

    await _firestore
        .collection('users')
        .doc(uid)
        .collection('categories')
        .add({
      'name': name.trim(),
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> removeCategory(String name) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    final snapshot = await _firestore
        .collection('users')
        .doc(uid)
        .collection('categories')
        .where('name', isEqualTo: name.trim())
        .get();

    for (var doc in snapshot.docs) {
      await doc.reference.delete();
    }
  }

  void clear() {
    _userCategories.clear();
    _subscription?.cancel();
    notifyListeners();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}