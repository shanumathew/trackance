import 'package:trackance/data/datasources/budget_data_source.dart';
import 'package:trackance/data/models/budget_model.dart';

abstract class BudgetRepository {
  Future<void> addBudget(BudgetModel budget);
  Future<void> updateBudget(BudgetModel budget);
  Future<void> deleteBudget(String id);
  List<BudgetModel> getAllBudgets();
  BudgetModel? getBudget(String categoryId);
}

class BudgetRepositoryImpl implements BudgetRepository {
  final BudgetDataSource _dataSource;

  BudgetRepositoryImpl(this._dataSource);

  @override
  Future<void> addBudget(BudgetModel budget) async {
    await _dataSource.addBudget(budget);
  }

  @override
  Future<void> updateBudget(BudgetModel budget) async {
    await _dataSource.updateBudget(budget);
  }

  @override
  Future<void> deleteBudget(String id) async {
    await _dataSource.deleteBudget(id);
  }

  @override
  List<BudgetModel> getAllBudgets() {
    return _dataSource.getAllBudgets();
  }

  @override
  BudgetModel? getBudget(String categoryId) {
    return _dataSource.getBudget(categoryId);
  }
}
