import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EmployeeService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  CollectionReference get employees => FirebaseFirestore.instance
      .collection('users')
      .doc(_auth.currentUser!.uid)
      .collection('employees');

  Future<void> addEmployee({
    required String name,
    required double salary,
    required String phone,
    required BuildContext context,
  }) async {
    await employees.add({
      'name': name,
      'salary': salary.toDouble(),
      'phone': phone,
      'createdAt': FieldValue.serverTimestamp(),
    });
    Navigator.pop(context);
  }

  Stream<QuerySnapshot> getEmployees() {
    return employees.orderBy('createdAt', descending: true).snapshots();
  }

  Future<double> getTotalSalaries() async {
    final snapshot = await employees.get();
    double total = 0;
    for (var doc in snapshot.docs) {
      total += (doc['salary'] ?? 0).toDouble();
    }
    return total;
  }

  Future<void> deleteEmployee(String id) async {
    await employees.doc(id).delete();
  }

  Future<void> updateEmployee(String id, Map<String, dynamic> data) async {
    await employees.doc(id).update(data);
  }
}
