import 'package:flutter/material.dart';
import '../Firebase/employee_service.dart';

class EmployeeSalaryProvider with ChangeNotifier {
  final EmployeeService _employeeService = EmployeeService();

  double _totalSalaries = 0.0;
  double get totalSalaries => _totalSalaries;

  /// 🔹 Fetch total salaries once
  Future<void> fetchTotalSalaries() async {
    _totalSalaries = await _employeeService.getTotalSalaries();
    notifyListeners();
  }
}
