import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:trackance/core/constants/app_constants.dart';
import 'package:trackance/data/datasources/hive_init.dart';
import 'package:trackance/data/models/budget_model.dart';
import 'package:trackance/data/models/category_model.dart';
import 'package:trackance/data/models/person_model.dart';
import 'package:trackance/data/models/transaction_model.dart';

class DummyDataInitializer {
  static Future<void> initializeDummyData() async {
    final categoryBox = HiveInit.getCategoryBox();
    final personBox = HiveInit.getPersonBox();
    final transactionBox = HiveInit.getTransactionBox();
    final budgetBox = HiveInit.getBudgetBox();

    if (categoryBox.isEmpty) {
      _initializeCategories(categoryBox, budgetBox);
    }

    if (personBox.isEmpty) {
      _initializePersons(personBox);
    }

    if (transactionBox.isEmpty) {
      _initializeTransactions(transactionBox, categoryBox, personBox);
    }
  }

  static void _initializeCategories(
    Box<CategoryModel> categoryBox,
    Box<BudgetModel> budgetBox,
  ) {
    final categories = [
      CategoryModel(
        id: 'food',
        name: 'Food & Dining',
        icon: CategoryIcons.food,
        color: '#F97316',
        monthlyBudget: 10000,
      ),
      CategoryModel(
        id: 'transport',
        name: 'Transport',
        icon: CategoryIcons.transport,
        color: '#3B82F6',
        monthlyBudget: 5000,
      ),
      CategoryModel(
        id: 'entertainment',
        name: 'Entertainment',
        icon: CategoryIcons.entertainment,
        color: '#8B5CF6',
        monthlyBudget: 3000,
      ),
      CategoryModel(
        id: 'shopping',
        name: 'Shopping',
        icon: CategoryIcons.shopping,
        color: '#FBBF24',
        monthlyBudget: 8000,
      ),
      CategoryModel(
        id: 'bills',
        name: 'Bills & Utilities',
        icon: CategoryIcons.bills,
        color: '#10B981',
        monthlyBudget: 5000,
      ),
      CategoryModel(
        id: 'health',
        name: 'Health & Fitness',
        icon: CategoryIcons.health,
        color: '#EF4444',
        monthlyBudget: 2000,
      ),
      CategoryModel(
        id: 'education',
        name: 'Education',
        icon: CategoryIcons.education,
        color: '#06B6D4',
        monthlyBudget: 4000,
      ),
    ];

    for (final cat in categories) {
      categoryBox.put(cat.id, cat);
      budgetBox.put(
        const Uuid().v4(),
        BudgetModel(
          id: const Uuid().v4(),
          categoryId: cat.id,
          monthlyLimit: cat.monthlyBudget,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      );
    }
  }

  static void _initializePersons(Box<PersonModel> personBox) {
    final persons = [
      PersonModel(id: 'person1', name: 'Starbucks', avatar: '☕'),
      PersonModel(id: 'person2', name: 'Uber', avatar: '🚗'),
      PersonModel(id: 'person3', name: 'Netflix', avatar: '🎬'),
      PersonModel(id: 'person4', name: 'Zara', avatar: '👕'),
      PersonModel(id: 'person5', name: 'Swiggy', avatar: '🍕'),
      PersonModel(id: 'person6', name: 'Amazon', avatar: '📦'),
      PersonModel(id: 'person7', name: 'Gym', avatar: '💪'),
      PersonModel(id: 'person8', name: 'Pharmacy', avatar: '💊'),
    ];

    for (final person in persons) {
      personBox.put(person.id, person);
    }
  }

  static void _initializeTransactions(
    Box<TransactionModel> transactionBox,
    Box<CategoryModel> categoryBox,
    Box<PersonModel> personBox,
  ) {
    final now = DateTime.now();
    final transactions = [
      // Today
      TransactionModel(
        id: const Uuid().v4(),
        amount: 450,
        categoryId: 'food',
        personId: 'person1',
        paymentMethod: 'card',
        notes: 'Morning coffee & breakfast',
        timestamp: DateTime(now.year, now.month, now.day, 8, 30),
        createdAt: DateTime.now(),
      ),
      TransactionModel(
        id: const Uuid().v4(),
        amount: 299,
        categoryId: 'transport',
        personId: 'person2',
        paymentMethod: 'upi',
        notes: 'Office commute',
        timestamp: DateTime(now.year, now.month, now.day, 9, 0),
        createdAt: DateTime.now(),
      ),
      TransactionModel(
        id: const Uuid().v4(),
        amount: 599,
        categoryId: 'food',
        personId: 'person5',
        paymentMethod: 'card',
        notes: 'Lunch delivery',
        timestamp: DateTime(now.year, now.month, now.day, 12, 30),
        createdAt: DateTime.now(),
      ),
      // Yesterday
      TransactionModel(
        id: const Uuid().v4(),
        amount: 2500,
        categoryId: 'shopping',
        personId: 'person4',
        paymentMethod: 'card',
        notes: 'New casual shirts',
        timestamp: now.subtract(const Duration(days: 1)),
        createdAt: DateTime.now(),
      ),
      TransactionModel(
        id: const Uuid().v4(),
        amount: 199,
        categoryId: 'entertainment',
        personId: 'person3',
        paymentMethod: 'upi',
        notes: 'Netflix subscription',
        timestamp: now.subtract(const Duration(days: 1)),
        createdAt: DateTime.now(),
      ),
      // 3 days ago
      TransactionModel(
        id: const Uuid().v4(),
        amount: 1500,
        categoryId: 'health',
        personId: 'person8',
        paymentMethod: 'cash',
        notes: 'Medicine & supplements',
        timestamp: now.subtract(const Duration(days: 3)),
        createdAt: DateTime.now(),
      ),
      // 5 days ago
      TransactionModel(
        id: const Uuid().v4(),
        amount: 4999,
        categoryId: 'shopping',
        personId: 'person6',
        paymentMethod: 'card',
        notes: 'Kitchen appliances',
        timestamp: now.subtract(const Duration(days: 5)),
        createdAt: DateTime.now(),
      ),
      TransactionModel(
        id: const Uuid().v4(),
        amount: 99,
        categoryId: 'education',
        personId: 'person1',
        paymentMethod: 'upi',
        notes: 'Coffee while studying',
        timestamp: now.subtract(const Duration(days: 5)),
        createdAt: DateTime.now(),
      ),
    ];

    for (final tx in transactions) {
      transactionBox.put(tx.id, tx);
    }
  }
}
