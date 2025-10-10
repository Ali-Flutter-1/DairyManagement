import 'package:cloud_firestore/cloud_firestore.dart';

class ExpenseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference get expenses => _firestore.collection('expenses');

  Future<void> addExpense({
    required String category,
    required double amount,
    required String description,

  }) async {
    await expenses.add({
      'category': category,
      'amount': amount.toDouble(),
      'description': description,

      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Stream<QuerySnapshot> getExpensesStream() {
    return expenses.orderBy('createdAt', descending: true).snapshots();
  }


}
