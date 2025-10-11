
import 'package:dairyapp/Provider/category_provider.dart';
import 'package:dairyapp/Provider/expense_provider.dart';
import 'package:dairyapp/Provider/milk_provider.dart';
import 'package:dairyapp/Provider/salary_provider.dart';
import 'package:dairyapp/screens/BottomNavBar/bottom_nav.dart';

import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'Firebase/firebase_setup.dart';
import 'Provider/provider_userdata.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    DevicePreview(
      builder: (context) => MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => FarmProvider()..loadFarmData()),
          ChangeNotifierProvider(create: (_)=>ExpenseProvider()..fetchMonthlyExpense()),
          ChangeNotifierProvider(create: (_)=>MilkProvider()..fetchMilkSales()),
          ChangeNotifierProvider(create: (_)=>EmployeeSalaryProvider()..fetchTotalSalaries()),
          ChangeNotifierProvider(create: (_)=>CategoryProvider()..fetchCategories()),
        ],
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home:BottomBar() ,
    );
  }
}

