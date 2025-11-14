import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trackance/data/models/transaction_model.dart';
import 'package:trackance/presentation/providers/repository_providers.dart';

final transactionsProvider =
    StateNotifierProvider<TransactionNotifier, List<TransactionModel>>((ref) {
      final useCase = ref.watch(transactionUseCaseProvider);
      return TransactionNotifier(useCase);
    });

final dailySummaryProvider = FutureProvider((ref) async {
  final useCase = ref.watch(analyticsUseCaseProvider);
  return useCase.generateDailySummary(DateTime.now());
});

final monthlySummaryProvider = FutureProvider((ref) async {
  final useCase = ref.watch(analyticsUseCaseProvider);
  return useCase.generateMonthlySummary(DateTime.now());
});

final budgetPredictionProvider = FutureProvider((ref) async {
  final useCase = ref.watch(analyticsUseCaseProvider);
  return useCase.getPredictedBudget();
});

class TransactionNotifier extends StateNotifier<List<TransactionModel>> {
  final dynamic _useCase;

  TransactionNotifier(this._useCase) : super([]) {
    _loadTransactions();
  }

  void _loadTransactions() {
    state = _useCase.getAllTransactions();
  }

  Future<void> addTransaction({
    required double amount,
    required String categoryId,
    required String personId,
    required String paymentMethod,
    required String notes,
  }) async {
    await _useCase.recordTransaction(
      amount: amount,
      categoryId: categoryId,
      personId: personId,
      paymentMethod: paymentMethod,
      notes: notes,
    );
    _loadTransactions();
  }

  Future<void> deleteTransaction(String id) async {
    await _useCase.deleteTransaction(id);
    _loadTransactions();
  }
}
