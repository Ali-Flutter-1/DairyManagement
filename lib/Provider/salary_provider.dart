import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EmployeeSalaryProvider with ChangeNotifier {
  double _totalSalaries = 0.0;
  double get totalSalaries => _totalSalaries;

  StreamSubscription<QuerySnapshot>? _subscription;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? _currentUid;

  EmployeeSalaryProvider() {
    _auth.authStateChanges().listen((user) {
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
        _listenEmployeeSalaries();
      }
    });
  }

  void _listenEmployeeSalaries() {
    _subscription?.cancel();

    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    _subscription = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('employees')
        .snapshots()
        .listen((snapshot) {
      double total = 0;
      for (var doc in snapshot.docs) {
        total += (doc['salary'] as num?)?.toDouble() ?? 0.0;
      }
      _totalSalaries = total;
      notifyListeners();
    });
  }

  void clear() {
    _subscription?.cancel();
    _totalSalaries = 0.0;
    notifyListeners();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}