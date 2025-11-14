import 'package:uuid/uuid.dart';
import 'package:trackance/data/models/transaction_model.dart';
import 'package:trackance/data/repositories/transaction_repository.dart';

class TransactionUseCase {
  final TransactionRepository _repository;

  TransactionUseCase(this._repository);

  Future<void> recordTransaction({
    required double amount,
    required String categoryId,
    required String personId,
    required String paymentMethod,
    required String notes,
    DateTime? timestamp,
  }) async {
    final transaction = TransactionModel(
      id: const Uuid().v4(),
      amount: amount,
      categoryId: categoryId,
      personId: personId,
      paymentMethod: paymentMethod,
      notes: notes,
      timestamp: timestamp ?? DateTime.now(),
      createdAt: DateTime.now(),
    );

    await _repository.addTransaction(transaction);
  }

  Future<void> updateTransaction(TransactionModel transaction) async {
    await _repository.updateTransaction(transaction);
  }

  Future<void> deleteTransaction(String id) async {
    await _repository.deleteTransaction(id);
  }

  List<TransactionModel> getAllTransactions() {
    return _repository.getAllTransactions();
  }

  List<TransactionModel> getTransactionsByDateRange(
    DateTime start,
    DateTime end,
  ) {
    return _repository.getTransactionsByDateRange(start, end);
  }
}
