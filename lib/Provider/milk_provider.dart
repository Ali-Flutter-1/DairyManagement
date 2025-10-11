import 'package:flutter/material.dart';
import '../Firebase/milk_service.dart';
import '../Model/milk_model.dart';



class MilkProvider with ChangeNotifier {
  final MilkService _milkService = MilkService();
  List<MilkSale> _milkSales = [];


  List<MilkSale> get milkSales => _milkSales;

  void fetchMilkSales() {
    _milkService.getAllMilkSales().listen((sales) {
      _milkSales = sales;
      notifyListeners();
    });
  }

  Future<void> addMilkSale(MilkSale sale) async {
    await _milkService.addMilkSale(sale);
    fetchMilkSales();
  }

  double get totalMorningLitres =>
      _milkSales.fold(0, (sum, s) => sum + s.morningQuantity);

  double get totalEveningLitres =>
      _milkSales.fold(0, (sum, s) => sum + s.eveningQuantity);

  double get totalLitres => totalMorningLitres + totalEveningLitres;

  double get totalRevenue =>
      _milkSales.fold(0, (sum, s) => sum + ((s.morningQuantity + s.eveningQuantity) * s.pricePerLitre));

  double get monthlyRevenue {
    final now = DateTime.now();
    final currentMonthSales = _milkSales.where((s) =>
    s.date.month == now.month && s.date.year == now.year);

    return currentMonthSales.fold(
      0,
          (sum, s) => sum + ((s.morningQuantity + s.eveningQuantity) * s.pricePerLitre),
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
        .fold(0.0, (sum, s) =>
    sum + ((s.morningQuantity + s.eveningQuantity) * s.pricePerLitre));
  }


  double get todayMorningLitres {
    final today = DateTime.now();
    return _milkSales
        .where((s) => s.date.year == today.year &&
        s.date.month == today.month &&
        s.date.day == today.day)
        .fold(0, (sum, s) => sum + s.morningQuantity);
  }

  double get todayEveningLitres {
    final today = DateTime.now();
    return _milkSales
        .where((s) => s.date.year == today.year &&
        s.date.month == today.month &&
        s.date.day == today.day)
        .fold(0, (sum, s) => sum + s.eveningQuantity);
  }


}
