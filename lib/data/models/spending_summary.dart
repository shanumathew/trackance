class SpendingSummary {
  final double todayTotal;
  final double monthTotal;
  final double yearTotal;
  final Map<String, double> categoryWiseSpending;
  final Map<String, double> personWiseSpending;
  final Map<String, BudgetStatus> budgetStatus;

  SpendingSummary({
    required this.todayTotal,
    required this.monthTotal,
    required this.yearTotal,
    required this.categoryWiseSpending,
    required this.personWiseSpending,
    required this.budgetStatus,
  });
}

class BudgetStatus {
  final String categoryId;
  final int monthlyLimit;
  final double spent;
  final double remaining;
  final double percentage;
  final bool isExceeded;

  BudgetStatus({
    required this.categoryId,
    required this.monthlyLimit,
    required this.spent,
    required this.remaining,
    required this.percentage,
    required this.isExceeded,
  });
}
