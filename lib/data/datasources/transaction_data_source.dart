import 'package:hive_flutter/hive_flutter.dart';
import 'package:trackance/data/datasources/hive_init.dart';
import 'package:trackance/data/models/transaction_model.dart';

abstract class TransactionDataSource {
  Future<void> addTransaction(TransactionModel transaction);
  Future<void> updateTransaction(TransactionModel transaction);
  Future<void> deleteTransaction(String id);
  List<TransactionModel> getAllTransactions();
  List<TransactionModel> getTransactionsByDateRange(
    DateTime start,
    DateTime end,
  );
}

class TransactionDataSourceImpl implements TransactionDataSource {
  final Box<TransactionModel> _box = HiveInit.getTransactionBox();

  @override
  Future<void> addTransaction(TransactionModel transaction) async {
    await _box.put(transaction.id, transaction);
  }

  @override
  Future<void> updateTransaction(TransactionModel transaction) async {
    await _box.put(transaction.id, transaction);
  }

  @override
  Future<void> deleteTransaction(String id) async {
    await _box.delete(id);
  }

  @override
  List<TransactionModel> getAllTransactions() {
    return _box.values.toList()
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
  }

  @override
  List<TransactionModel> getTransactionsByDateRange(
    DateTime start,
    DateTime end,
  ) {
    return _box.values
        .where((t) => t.timestamp.isAfter(start) && t.timestamp.isBefore(end))
        .toList()
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
  }
}
