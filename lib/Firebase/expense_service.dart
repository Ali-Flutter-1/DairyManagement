import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ExpenseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  CollectionReference get _userExpenses =>
      _firestore.collection('users').doc(_auth.currentUser!.uid).collection('expenses');

  Future<void> addExpense({
    required String category,
    required double amount,
     String? description,
  }) async {
    await _userExpenses.add({
      'category': category,
      'amount': amount.toDouble(),
      'description': description,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Stream<QuerySnapshot> getExpensesStream() {
    return _userExpenses.orderBy('createdAt', descending: true).snapshots();
  }

  Future<void> deleteExpensesByCategory(String category) async {
    final snapshot = await _userExpenses.where('category', isEqualTo: category).get();
    for (var doc in snapshot.docs) {
      await doc.reference.delete();
    }
  }
}
