import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../Model/milk_model.dart';

class MilkService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> addMilkSale(MilkSale sale) async {
    final uid = _auth.currentUser!.uid;
    await _firestore
        .collection('users')
        .doc(uid)
        .collection('milkSales')
        .add(sale.toMap());
  }

  Stream<List<MilkSale>> getAllMilkSales() {
    final uid = _auth.currentUser!.uid;
    return _firestore
        .collection('users')
        .doc(uid)
        .collection('milkSales')
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) =>
        snapshot.docs.map((doc) => MilkSale.fromMap(doc.data())).toList());
  }
}
