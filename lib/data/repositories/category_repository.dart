import 'package:trackance/data/datasources/category_data_source.dart';
import 'package:trackance/data/models/category_model.dart';

abstract class CategoryRepository {
  Future<void> addCategory(CategoryModel category);
  Future<void> updateCategory(CategoryModel category);
  Future<void> deleteCategory(String id);
  List<CategoryModel> getAllCategories();
  CategoryModel? getCategory(String id);
}

class CategoryRepositoryImpl implements CategoryRepository {
  final CategoryDataSource _dataSource;

  CategoryRepositoryImpl(this._dataSource);

  @override
  Future<void> addCategory(CategoryModel category) async {
    await _dataSource.addCategory(category);
  }

  @override
  Future<void> updateCategory(CategoryModel category) async {
    await _dataSource.updateCategory(category);
  }

  @override
  Future<void> deleteCategory(String id) async {
    await _dataSource.deleteCategory(id);
  }

  @override
  List<CategoryModel> getAllCategories() {
    return _dataSource.getAllCategories();
  }

  @override
  CategoryModel? getCategory(String id) {
    return _dataSource.getCategory(id);
  }
}
