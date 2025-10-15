import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class EmployeeSalaryProvider with ChangeNotifier {
  double _totalSalaries = 0.0; // 🔹 All salaries
  double _todaySalary = 0.0;   // 🔹 Today's salaries
  Map<String, double> _dailySalaryData = {}; // 🔹 For graph (date -> total salary)

  double get totalSalaries => _totalSalaries;
  double get todaySalary => _todaySalary;
  Map<String, double> get dailySalaryData => _dailySalaryData;

  StreamSubscription<QuerySnapshot>? _subscription;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? _currentUid;

  EmployeeSalaryProvider() {
    _auth.authStateChanges().listen((user) {
      if (user == null) {
        if (_currentUid != null) clear();
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
      double totalAll = 0.0;
      double totalToday = 0.0;
      Map<String, double> dailyMap = {};

      final todayDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

      for (var doc in snapshot.docs) {
        final salary = (doc['salary'] as num?)?.toDouble() ?? 0.0;
        totalAll += salary;

        if (doc.data().toString().contains('date')) {
          final dateField = doc['date'];
          if (dateField is Timestamp) {
            final recordDate = DateFormat('yyyy-MM-dd').format(dateField.toDate());

            // ✅ Add salary to correct date
            dailyMap[recordDate] = (dailyMap[recordDate] ?? 0) + salary;

            if (recordDate == todayDate) {
              totalToday += salary;
            }
          }
        }
      }

      // Sort by date (ascending)
      final sortedKeys = dailyMap.keys.toList()..sort();
      _dailySalaryData = {
        for (var k in sortedKeys) k: dailyMap[k]!,
      };

      _totalSalaries = totalAll;
      _todaySalary = totalToday;
      notifyListeners();
    });
  }

  void clear() {
    _subscription?.cancel();
    _totalSalaries = 0.0;
    _todaySalary = 0.0;
    _dailySalaryData.clear();
    notifyListeners();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
