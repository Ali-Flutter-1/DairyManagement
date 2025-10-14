import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Provider/category_provider.dart';
import '../Provider/expense_provider.dart';
import '../Provider/milk_provider.dart';
import '../Provider/salary_provider.dart';
import '../Provider/provider_userdata.dart';

class ProviderManager {
  static Widget buildWithProviders(Widget child) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FarmProvider()),
        ChangeNotifierProvider(create: (_) => ExpenseProvider()),
        ChangeNotifierProvider(create: (_) => MilkProvider()),
        ChangeNotifierProvider(create: (_) => EmployeeSalaryProvider()),
        ChangeNotifierProvider(create: (_) => CategoryProvider()),
      ],
      child: child,
    );
  }

  static void resetProviders(BuildContext context) {
    context.read<FarmProvider>().clear();
    context.read<ExpenseProvider>().clear();
    context.read<MilkProvider>().clear();
    context.read<EmployeeSalaryProvider>().clear();
    context.read<CategoryProvider>().clear();
  }
}