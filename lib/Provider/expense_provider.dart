import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class ExpenseProvider extends ChangeNotifier {
  double _monthlyExpense = 0.0;
  double _todayExpense = 0.0;

  // ✅ Store daily expenses by date
  final Map<DateTime, double> _dailyExpenses = {};

  double get monthlyExpense => _monthlyExpense;
  double get todayExpense => _todayExpense;
  Map<DateTime, double> get dailyExpenses => Map.unmodifiable(_dailyExpenses);

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
        .where('createdAt', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfMonth))
        .snapshots()
        .listen((snapshot) {
      double totalMonth = 0.0;
      double totalToday = 0.0;
      final Map<DateTime, double> dailyMap = {};

      final today = DateFormat('yyyy-MM-dd').format(DateTime.now());

      for (var doc in snapshot.docs) {
        final data = doc.data();
        if (!data.containsKey('createdAt')) continue;

        final amount = (data['amount'] as num?)?.toDouble() ?? 0.0;
        final createdAt = data['createdAt'];
        if (createdAt is! Timestamp) continue;

        final date = createdAt.toDate();
        final dateOnly = DateTime(date.year, date.month, date.day);

        totalMonth += amount;
        dailyMap[dateOnly] = (dailyMap[dateOnly] ?? 0.0) + amount;

        final recordDate = DateFormat('yyyy-MM-dd').format(dateOnly);
        if (recordDate == today) {
          totalToday += amount;
        }
      }

      _monthlyExpense = totalMonth;
      _todayExpense = totalToday;

      // ✅ Replace the map
      _dailyExpenses
        ..clear()
        ..addAll(dailyMap);

      notifyListeners();
    });
  }

  void clear() {
    _subscription?.cancel();
    _monthlyExpense = 0.0;
    _todayExpense = 0.0;
    _dailyExpenses.clear();
    notifyListeners();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
