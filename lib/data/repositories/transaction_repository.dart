import 'package:trackance/data/datasources/transaction_data_source.dart';
import 'package:trackance/data/models/transaction_model.dart';

abstract class TransactionRepository {
  Future<void> addTransaction(TransactionModel transaction);
  Future<void> updateTransaction(TransactionModel transaction);
  Future<void> deleteTransaction(String id);
  List<TransactionModel> getAllTransactions();
  List<TransactionModel> getTransactionsByDateRange(
    DateTime start,
    DateTime end,
  );
}

class TransactionRepositoryImpl implements TransactionRepository {
  final TransactionDataSource _dataSource;

  TransactionRepositoryImpl(this._dataSource);

  @override
  Future<void> addTransaction(TransactionModel transaction) async {
    await _dataSource.addTransaction(transaction);
  }

  @override
  Future<void> updateTransaction(TransactionModel transaction) async {
    await _dataSource.updateTransaction(transaction);
  }

  @override
  Future<void> deleteTransaction(String id) async {
    await _dataSource.deleteTransaction(id);
  }

  @override
  List<TransactionModel> getAllTransactions() {
    return _dataSource.getAllTransactions();
  }

  @override
  List<TransactionModel> getTransactionsByDateRange(
    DateTime start,
    DateTime end,
  ) {
    return _dataSource.getTransactionsByDateRange(start, end);
  }
}
