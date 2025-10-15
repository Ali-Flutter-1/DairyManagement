import 'dart:async';

import 'package:flutter/material.dart';
import '../Firebase/milk_service.dart';
import '../Model/milk_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MilkProvider with ChangeNotifier {
  final MilkService _milkService = MilkService();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  List<MilkSale> _milkSales = [];
  StreamSubscription<List<MilkSale>>? _subscription;
  String? _currentUid;

  List<MilkSale> get milkSales => _milkSales;

  MilkProvider() {
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
        fetchMilkSales();
      }
    });
  }

  void fetchMilkSales() {
    _subscription?.cancel();
    _subscription = _milkService.getAllMilkSales().listen((sales) {
      _milkSales = sales;
      notifyListeners();
    });
  }

  Future<void> addMilkSale(MilkSale sale) async {
    await _milkService.addMilkSale(sale);
  }

  double get totalMorningLitres =>
      _milkSales.fold(0, (sum, s) => sum + s.morningQuantity);
  double get totalEveningLitres =>
      _milkSales.fold(0, (sum, s) => sum + s.eveningQuantity);
  double get totalLitres => totalMorningLitres + totalEveningLitres;

  double get totalRevenue => _milkSales.fold(
      0,
          (sum, s) =>
      sum +
          ((s.morningQuantity + s.eveningQuantity) * s.pricePerLitre));

  double get monthlyRevenue {
    final now = DateTime.now();
    final currentMonthSales =
    _milkSales.where((s) => s.date.month == now.month && s.date.year == now.year);

    return currentMonthSales.fold(
      0,
          (sum, s) =>
      sum +
          ((s.morningQuantity + s.eveningQuantity) * s.pricePerLitre),
    );
  }

  double get todayMilkSold {
    final today = DateTime.now();
    return _milkSales
        .where((s) =>
    s.date.year == today.year &&
        s.date.month == today.month &&
        s.date.day == today.day)
        .fold(0.0, (sum, s) => sum + s.morningQuantity + s.eveningQuantity);
  }

  double get todayRevenue {
    final today = DateTime.now();
    return _milkSales
        .where((s) =>
    s.date.year == today.year &&
        s.date.month == today.month &&
        s.date.day == today.day)
        .fold(
        0.0,
            (sum, s) =>
        sum +
            ((s.morningQuantity + s.eveningQuantity) *
                s.pricePerLitre));
  }

  Map<DateTime, double> get dailyRevenue {
    Map<DateTime, double> revenueMap = {};

    for (var sale in _milkSales) {
      // Normalize date (remove time)
      final dateKey = DateTime(sale.date.year, sale.date.month, sale.date.day);
      final revenue = (sale.morningQuantity + sale.eveningQuantity) * sale.pricePerLitre;

      if (revenueMap.containsKey(dateKey)) {
        revenueMap[dateKey] = revenueMap[dateKey]! + revenue;
      } else {
        revenueMap[dateKey] = revenue;
      }
    }

    return revenueMap;
  }


  void clear() {
    _subscription?.cancel();
    _milkSales.clear();
    notifyListeners();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}