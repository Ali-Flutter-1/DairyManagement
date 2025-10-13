import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ExpenseProvider extends ChangeNotifier {
  double _monthlyExpense = 0.0;
  double get monthlyExpense => _monthlyExpense;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  StreamSubscription<QuerySnapshot>? _subscription;

  ExpenseProvider() {
    _listenExpenses();
  }

  String? get _uid => _auth.currentUser?.uid;

  void _listenExpenses() {
    final uid = _uid;
    if (uid == null) return;

    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month, 1);

    _subscription = _firestore
        .collection('users')
        .doc(uid)
        .collection('expenses')
        .where('createdAt', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfMonth))
        .snapshots()
        .listen((snapshot) {
      double total = 0;
      for (var doc in snapshot.docs) {
        total += (doc['amount'] as num?)?.toDouble() ?? 0.0;
      }
      _monthlyExpense = total;
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
