import 'package:cloud_firestore/cloud_firestore.dart';

import '../Model/milk_model.dart';


class MilkService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addMilkSale(MilkSale sale) async {
    await _firestore.collection('milkSales').add(sale.toMap());
  }

  Stream<List<MilkSale>> getAllMilkSales() {
    return _firestore.collection('milkSales').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => MilkSale.fromMap(doc.data())).toList();
    });
  }
}
