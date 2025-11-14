import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trackance/data/datasources/budget_data_source.dart';
import 'package:trackance/data/datasources/category_data_source.dart';
import 'package:trackance/data/datasources/person_data_source.dart';
import 'package:trackance/data/datasources/transaction_data_source.dart';
import 'package:trackance/data/repositories/budget_repository.dart';
import 'package:trackance/data/repositories/category_repository.dart';
import 'package:trackance/data/repositories/person_repository.dart';
import 'package:trackance/data/repositories/transaction_repository.dart';
import 'package:trackance/domain/usecases/analytics_use_case.dart';
import 'package:trackance/domain/usecases/transaction_use_case.dart';

// Data Sources
final transactionDataSourceProvider = Provider(
  (ref) => TransactionDataSourceImpl(),
);
final categoryDataSourceProvider = Provider((ref) => CategoryDataSourceImpl());
final personDataSourceProvider = Provider((ref) => PersonDataSourceImpl());
final budgetDataSourceProvider = Provider((ref) => BudgetDataSourceImpl());

// Repositories
final transactionRepositoryProvider = Provider((ref) {
  final dataSource = ref.watch(transactionDataSourceProvider);
  return TransactionRepositoryImpl(dataSource);
});

final categoryRepositoryProvider = Provider((ref) {
  final dataSource = ref.watch(categoryDataSourceProvider);
  return CategoryRepositoryImpl(dataSource);
});

final personRepositoryProvider = Provider((ref) {
  final dataSource = ref.watch(personDataSourceProvider);
  return PersonRepositoryImpl(dataSource);
});

final budgetRepositoryProvider = Provider((ref) {
  final dataSource = ref.watch(budgetDataSourceProvider);
  return BudgetRepositoryImpl(dataSource);
});

// Use Cases
final transactionUseCaseProvider = Provider((ref) {
  final repo = ref.watch(transactionRepositoryProvider);
  return TransactionUseCase(repo);
});

final analyticsUseCaseProvider = Provider((ref) {
  final transactionRepo = ref.watch(transactionRepositoryProvider);
  final categoryRepo = ref.watch(categoryRepositoryProvider);
  final budgetRepo = ref.watch(budgetRepositoryProvider);
  return AnalyticsUseCase(transactionRepo, categoryRepo, budgetRepo);
});
