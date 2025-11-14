import 'package:hive/hive.dart';

part 'category_model.g.dart';

@HiveType(typeId: 0)
class CategoryModel {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String icon;

  @HiveField(3)
  final String color;

  @HiveField(4)
  final int monthlyBudget;

  CategoryModel({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
    required this.monthlyBudget,
  });

  CategoryModel copyWith({
    String? id,
    String? name,
    String? icon,
    String? color,
    int? monthlyBudget,
  }) {
    return CategoryModel(
      id: id ?? this.id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      monthlyBudget: monthlyBudget ?? this.monthlyBudget,
    );
  }
}
