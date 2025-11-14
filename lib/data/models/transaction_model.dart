import 'package:hive/hive.dart';

part 'transaction_model.g.dart';

enum PaymentMethod { upi, card, cash, bank_transfer, wallet, other }

@HiveType(typeId: 2)
class TransactionModel {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final double amount;

  @HiveField(2)
  final String categoryId;

  @HiveField(3)
  final String personId;

  @HiveField(4)
  final String paymentMethod;

  @HiveField(5)
  final String notes;

  @HiveField(6)
  final DateTime timestamp;

  @HiveField(7)
  final DateTime createdAt;

  TransactionModel({
    required this.id,
    required this.amount,
    required this.categoryId,
    required this.personId,
    required this.paymentMethod,
    required this.notes,
    required this.timestamp,
    required this.createdAt,
  });

  TransactionModel copyWith({
    String? id,
    double? amount,
    String? categoryId,
    String? personId,
    String? paymentMethod,
    String? notes,
    DateTime? timestamp,
    DateTime? createdAt,
  }) {
    return TransactionModel(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      categoryId: categoryId ?? this.categoryId,
      personId: personId ?? this.personId,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      notes: notes ?? this.notes,
      timestamp: timestamp ?? this.timestamp,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
