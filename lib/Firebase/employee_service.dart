import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class EmployeeService {
  final CollectionReference employees =
  FirebaseFirestore.instance.collection('employees');

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

  // 🔹 Get all employees (real-time)
  Stream<QuerySnapshot> getEmployees() {
    return employees.orderBy('createdAt', descending: true).snapshots();
  }

  Future<double> getTotalSalaries() async {
    final snapshot = await employees.get();
    double total = 0;

    for (var doc in snapshot.docs) {
      final salary = (doc['salary'] ?? 0).toDouble();
      total += salary;
    }

    return total;
  }


  // 🔹 Delete employee
  Future<void> deleteEmployee(String id) async {
    await employees.doc(id).delete();
  }

  // 🔹 Update employee
  Future<void> updateEmployee(String id, Map<String, dynamic> data) async {
    await employees.doc(id).update(data);
  }
}
