import 'package:hive_flutter/hive_flutter.dart';
import 'package:trackance/data/datasources/hive_init.dart';
import 'package:trackance/data/models/budget_model.dart';

abstract class BudgetDataSource {
  Future<void> addBudget(BudgetModel budget);
  Future<void> updateBudget(BudgetModel budget);
  Future<void> deleteBudget(String id);
  List<BudgetModel> getAllBudgets();
  BudgetModel? getBudget(String categoryId);
}

class BudgetDataSourceImpl implements BudgetDataSource {
  final Box<BudgetModel> _box = HiveInit.getBudgetBox();

  @override
  Future<void> addBudget(BudgetModel budget) async {
    await _box.put(budget.id, budget);
  }

  @override
  Future<void> updateBudget(BudgetModel budget) async {
    await _box.put(budget.id, budget);
  }

  @override
  Future<void> deleteBudget(String id) async {
    await _box.delete(id);
  }

  @override
  List<BudgetModel> getAllBudgets() {
    return _box.values.toList();
  }

  @override
  BudgetModel? getBudget(String categoryId) {
    final values = _box.values.toList();
    try {
      return values.firstWhere((b) => b.categoryId == categoryId);
    } catch (e) {
      return null;
    }
  }
}
