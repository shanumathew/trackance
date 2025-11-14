import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trackance/core/constants/app_constants.dart';
import 'package:trackance/core/utils/formatters.dart';
import 'package:trackance/data/models/spending_summary.dart';
import 'package:trackance/presentation/providers/master_data_providers.dart';
import 'package:trackance/presentation/providers/repository_providers.dart';
import 'package:trackance/presentation/providers/transaction_providers.dart';
import 'package:trackance/presentation/screens/transactions_screen.dart';
import 'package:trackance/presentation/widgets/budget_progress_card.dart';
import 'package:trackance/presentation/widgets/summary_card.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    final transactions = ref.watch(transactionsProvider);
    final categories = ref.watch(categoriesProvider);
    final persons = ref.watch(personsProvider);
    final monthlySummary = ref.watch(monthlySummaryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Trackance'),
        elevation: 0,
        centerTitle: true,
      ),
      body: monthlySummary.when(
        data: (summary) => SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSummarySection(summary),
                const SizedBox(height: AppSpacing.lg),
                _buildBudgetSection(summary),
                const SizedBox(height: AppSpacing.lg),
                _buildRecentTransactions(transactions, categories, persons),
              ],
            ),
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }

  Widget _buildSummarySection(SpendingSummary summary) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Today & This Month',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: AppSpacing.md),
        Row(
          children: [
            Expanded(
              child: SummaryCard(
                title: 'Today',
                amount: summary.todayTotal,
                icon: Icons.calendar_today,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: SummaryCard(
                title: 'This Month',
                amount: summary.monthTotal,
                icon: Icons.calendar_month,
                color: AppColors.secondary,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBudgetSection(SpendingSummary summary) {
    if (summary.budgetStatus.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Budget Status',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: AppSpacing.md),
        ...summary.budgetStatus.entries.map((entry) {
          final status = entry.value;
          final categoryId = entry.key;
          final categories = ref.watch(categoriesProvider);
          final category = categories.firstWhere(
            (c) => c.id == categoryId,
            orElse: () => throw Exception('Category not found'),
          );

          return Column(
            children: [
              BudgetProgressCard(
                categoryName: category.name,
                icon: category.icon,
                spent: status.spent,
                limit: status.monthlyLimit,
                color: Color(
                  int.parse(category.color.replaceFirst('#', '0xff')),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
            ],
          );
        }).toList(),
      ],
    );
  }

  Widget _buildRecentTransactions(
    List<dynamic> transactions,
    List<dynamic> categories,
    List<dynamic> persons,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recent Transactions',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            TextButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const TransactionsScreen()),
              ),
              child: const Text('View All'),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        if (transactions.isEmpty)
          Center(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Text(
                'No transactions yet',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          )
        else
          ...transactions.take(5).map((tx) {
            final category = categories.firstWhere(
              (c) => c.id == tx.categoryId,
              orElse: () => throw Exception('Category not found'),
            );
            final person = persons.firstWhere(
              (p) => p.id == tx.personId,
              orElse: () => throw Exception('Person not found'),
            );

            return GestureDetector(
              onLongPress: () => ref
                  .read(transactionsProvider.notifier)
                  .deleteTransaction(tx.id),
              child: Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  children: [
                    Text(category.icon, style: const TextStyle(fontSize: 20)),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            category.name,
                            style: Theme.of(context).textTheme.titleSmall
                                ?.copyWith(fontWeight: FontWeight.w600),
                          ),
                          Text(
                            '${person.avatar} ${person.name}',
                            style: Theme.of(context).textTheme.labelSmall
                                ?.copyWith(color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      NumberUtils.formatCurrency(tx.amount.toDouble()),
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
      ],
    );
  }
}
