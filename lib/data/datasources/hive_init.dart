import 'package:hive_flutter/hive_flutter.dart';
import 'package:trackance/data/models/budget_model.dart';
import 'package:trackance/data/models/category_model.dart';
import 'package:trackance/data/models/person_model.dart';
import 'package:trackance/data/models/transaction_model.dart';

class HiveInit {
  static const String transactionBox = 'transactions';
  static const String categoryBox = 'categories';
  static const String personBox = 'persons';
  static const String budgetBox = 'budgets';

  static Future<void> init() async {
    await Hive.initFlutter();

    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(CategoryModelAdapter());
    }
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(PersonModelAdapter());
    }
    if (!Hive.isAdapterRegistered(2)) {
      Hive.registerAdapter(TransactionModelAdapter());
    }
    if (!Hive.isAdapterRegistered(3)) {
      Hive.registerAdapter(BudgetModelAdapter());
    }

    await Hive.openBox<CategoryModel>(categoryBox);
    await Hive.openBox<PersonModel>(personBox);
    await Hive.openBox<TransactionModel>(transactionBox);
    await Hive.openBox<BudgetModel>(budgetBox);
  }

  static Box<TransactionModel> getTransactionBox() =>
      Hive.box<TransactionModel>(transactionBox);

  static Box<CategoryModel> getCategoryBox() =>
      Hive.box<CategoryModel>(categoryBox);

  static Box<PersonModel> getPersonBox() => Hive.box<PersonModel>(personBox);

  static Box<BudgetModel> getBudgetBox() => Hive.box<BudgetModel>(budgetBox);
}
