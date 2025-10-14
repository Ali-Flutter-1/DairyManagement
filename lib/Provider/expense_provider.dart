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
  String? _currentUid;

  ExpenseProvider() {
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
        _listenExpenses();
      }
    });
  }

  void _listenExpenses() {
    _subscription?.cancel();

    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month, 1);

    _subscription = _firestore
        .collection('users')
        .doc(uid)
        .collection('expenses')
        .where('createdAt',
        isGreaterThanOrEqualTo: Timestamp.fromDate(startOfMonth))
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

  void clear() {
    _subscription?.cancel();
    _monthlyExpense = 0.0;
    notifyListeners();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}