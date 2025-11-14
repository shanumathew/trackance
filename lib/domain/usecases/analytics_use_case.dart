import 'package:trackance/data/models/spending_summary.dart';
import 'package:trackance/data/models/transaction_model.dart';
import 'package:trackance/data/repositories/budget_repository.dart';
import 'package:trackance/data/repositories/category_repository.dart';
import 'package:trackance/data/repositories/transaction_repository.dart';

class AnalyticsUseCase {
  final TransactionRepository _transactionRepo;
  final CategoryRepository _categoryRepo;
  final BudgetRepository _budgetRepo;

  AnalyticsUseCase(this._transactionRepo, this._categoryRepo, this._budgetRepo);

  SpendingSummary generateDailySummary(DateTime date) {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    final transactions = _transactionRepo.getTransactionsByDateRange(
      startOfDay,
      endOfDay,
    );
    return _calculateSummary(transactions);
  }

  SpendingSummary generateMonthlySummary(DateTime date) {
    final startOfMonth = DateTime(date.year, date.month, 1);
    final endOfMonth = DateTime(date.year, date.month + 1, 1);

    final transactions = _transactionRepo.getTransactionsByDateRange(
      startOfMonth,
      endOfMonth,
    );
    return _calculateSummary(transactions);
  }

  SpendingSummary generateYearlySummary(DateTime date) {
    final startOfYear = DateTime(date.year, 1, 1);
    final endOfYear = DateTime(date.year + 1, 1, 1);

    final transactions = _transactionRepo.getTransactionsByDateRange(
      startOfYear,
      endOfYear,
    );
    return _calculateSummary(transactions);
  }

  SpendingSummary _calculateSummary(List<TransactionModel> transactions) {
    double todayTotal = 0;
    double monthTotal = 0;
    double yearTotal = 0;
    final now = DateTime.now();
    final categoryWiseSpending = <String, double>{};
    final personWiseSpending = <String, double>{};

    for (final tx in transactions) {
      final amount = tx.amount;
      yearTotal += amount;

      if (_isSameMonth(tx.timestamp, now)) {
        monthTotal += amount;
      }

      if (_isSameDay(tx.timestamp, now)) {
        todayTotal += amount;
      }

      categoryWiseSpending.update(
        tx.categoryId,
        (value) => value + amount,
        ifAbsent: () => amount,
      );

      personWiseSpending.update(
        tx.personId,
        (value) => value + amount,
        ifAbsent: () => amount,
      );
    }

    final budgetStatus = _calculateBudgetStatus(monthTotal);

    return SpendingSummary(
      todayTotal: todayTotal,
      monthTotal: monthTotal,
      yearTotal: yearTotal,
      categoryWiseSpending: categoryWiseSpending,
      personWiseSpending: personWiseSpending,
      budgetStatus: budgetStatus,
    );
  }

  Map<String, BudgetStatus> _calculateBudgetStatus(double monthTotal) {
    final budgets = _budgetRepo.getAllBudgets();
    final statusMap = <String, BudgetStatus>{};

    for (final budget in budgets) {
      final categoryId = budget.categoryId;
      final category = _categoryRepo.getCategory(categoryId);
      if (category == null) continue;

      final spent = _getCategoryMonthlySpending(categoryId);
      final remaining = budget.monthlyLimit - spent;
      final percentage =
          ((spent / budget.monthlyLimit * 100).clamp(0, 100) as double);
      final isExceeded = spent > budget.monthlyLimit;

      statusMap[categoryId] = BudgetStatus(
        categoryId: categoryId,
        monthlyLimit: budget.monthlyLimit,
        spent: spent,
        remaining: remaining,
        percentage: percentage,
        isExceeded: isExceeded,
      );
    }

    return statusMap;
  }

  double _getCategoryMonthlySpending(String categoryId) {
    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month, 1);
    final endOfMonth = DateTime(now.year, now.month + 1, 1);

    final transactions = _transactionRepo.getTransactionsByDateRange(
      startOfMonth,
      endOfMonth,
    );
    return transactions
        .where((t) => t.categoryId == categoryId)
        .fold<double>(0, (sum, t) => sum + t.amount);
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  bool _isSameMonth(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month;
  }

  List<Map<String, dynamic>> getPredictedBudget() {
    final now = DateTime.now();
    final last3Months = <List<TransactionModel>>[];

    for (int i = 0; i < 3; i++) {
      final date = DateTime(now.year, now.month - i, 1);
      final endDate = DateTime(date.year, date.month + 1, 1);
      last3Months.add(
        _transactionRepo.getTransactionsByDateRange(date, endDate),
      );
    }

    final categories = _categoryRepo.getAllCategories();
    final predictions = <Map<String, dynamic>>[];

    for (final category in categories) {
      final categoryTransactions = last3Months
          .map(
            (month) => month.where((t) => t.categoryId == category.id).toList(),
          )
          .toList();

      final averages = categoryTransactions
          .map((month) => month.fold<double>(0, (sum, t) => sum + t.amount))
          .toList();
      final predictedBudget =
          (averages.fold<double>(0, (sum, v) => sum + v) /
                  averages.length *
                  1.2)
              .toInt();

      predictions.add({
        'categoryId': category.id,
        'categoryName': category.name,
        'predictedBudget': predictedBudget,
        'lastThreeMonthsAverage':
            (averages.fold<double>(0, (sum, v) => sum + v) / averages.length)
                .toInt(),
      });
    }

    return predictions;
  }
}
