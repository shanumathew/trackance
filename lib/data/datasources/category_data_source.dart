import 'package:hive_flutter/hive_flutter.dart';
import 'package:trackance/data/datasources/hive_init.dart';
import 'package:trackance/data/models/category_model.dart';

abstract class CategoryDataSource {
  Future<void> addCategory(CategoryModel category);
  Future<void> updateCategory(CategoryModel category);
  Future<void> deleteCategory(String id);
  List<CategoryModel> getAllCategories();
  CategoryModel? getCategory(String id);
}

class CategoryDataSourceImpl implements CategoryDataSource {
  final Box<CategoryModel> _box = HiveInit.getCategoryBox();

  @override
  Future<void> addCategory(CategoryModel category) async {
    await _box.put(category.id, category);
  }

  @override
  Future<void> updateCategory(CategoryModel category) async {
    await _box.put(category.id, category);
  }

  @override
  Future<void> deleteCategory(String id) async {
    await _box.delete(id);
  }

  @override
  List<CategoryModel> getAllCategories() {
    return _box.values.toList();
  }

  @override
  CategoryModel? getCategory(String id) {
    return _box.get(id);
  }
}
