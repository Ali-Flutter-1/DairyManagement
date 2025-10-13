import 'dart:async';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EmployeeSalaryProvider with ChangeNotifier {
  double _totalSalaries = 0.0;
  double get totalSalaries => _totalSalaries;

  StreamSubscription<QuerySnapshot>? _subscription;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  EmployeeSalaryProvider() {
    _listenEmployeeSalaries();
  }

  void _listenEmployeeSalaries() {
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

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
