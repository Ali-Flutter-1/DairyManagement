import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class ExpenseProvider extends ChangeNotifier {
  double _monthlyExpense = 0.0;
  double get monthlyExpense => _monthlyExpense;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  ExpenseProvider() {
    fetchMonthlyExpense();
  }

  Future<void> fetchMonthlyExpense() async {
    try {
      final now = DateTime.now();
      final startOfMonth = DateTime(now.year, now.month, 1);

      // Get all expenses created after start of current month
      final snapshot = await _firestore
          .collection('expenses')
          .where('createdAt', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfMonth))
          .get();

      double total = 0;
      for (var doc in snapshot.docs) {
        final data = doc.data();
        total += (data['amount'] as num?)?.toDouble() ?? 0.0;
      }

      _monthlyExpense = total;
      notifyListeners();
    } catch (e) {
      if (kDebugMode) print('Error fetching monthly expense: $e');
    }
  }


  Future<void> refreshMonthlyExpense() async {
    await fetchMonthlyExpense();
  }
}
