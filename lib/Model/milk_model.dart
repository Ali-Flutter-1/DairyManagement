import 'package:cloud_firestore/cloud_firestore.dart';

class MilkSale {
  final double morningQuantity;
  final double eveningQuantity;
  final double pricePerLitre;
  final String notes;
  final String customer;
  final DateTime date;
  final DateTime createdAt;

  MilkSale({
    required this.morningQuantity,
    required this.eveningQuantity,
    required this.pricePerLitre,
    required this.notes,
    required this.customer,
    required this.date,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'morningQuantity': morningQuantity,
      'eveningQuantity': eveningQuantity,
      'pricePerLitre': pricePerLitre,
      'notes': notes,
      'customer': customer,
      'date': date,
      'createdAt': createdAt,
    };
  }

  factory MilkSale.fromMap(Map<String, dynamic> map) {
    return MilkSale(
      morningQuantity: (map['morningQuantity'] ?? 0).toDouble(),
      eveningQuantity: (map['eveningQuantity'] ?? 0).toDouble(),
      pricePerLitre: (map['pricePerLitre'] ?? 0).toDouble(),
      notes: map['notes'] ?? '',
      customer: map['customer'] ?? '',
      date: (map['date'] as Timestamp).toDate(),
      createdAt: (map['createdAt'] as Timestamp).toDate(),
    );
  }
}
