import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trackance/data/models/category_model.dart';
import 'package:trackance/data/models/person_model.dart';
import 'package:trackance/presentation/providers/repository_providers.dart';

final categoriesProvider =
    StateNotifierProvider<CategoriesNotifier, List<CategoryModel>>((ref) {
      final repo = ref.watch(categoryRepositoryProvider);
      return CategoriesNotifier(repo);
    });

final personsProvider =
    StateNotifierProvider<PersonsNotifier, List<PersonModel>>((ref) {
      final repo = ref.watch(personRepositoryProvider);
      return PersonsNotifier(repo);
    });

class CategoriesNotifier extends StateNotifier<List<CategoryModel>> {
  final dynamic _repo;

  CategoriesNotifier(this._repo) : super([]) {
    _loadCategories();
  }

  void _loadCategories() {
    state = _repo.getAllCategories();
  }

  Future<void> addCategory(CategoryModel category) async {
    await _repo.addCategory(category);
    _loadCategories();
  }

  Future<void> updateCategory(CategoryModel category) async {
    await _repo.updateCategory(category);
    _loadCategories();
  }

  Future<void> deleteCategory(String id) async {
    await _repo.deleteCategory(id);
    _loadCategories();
  }
}

class PersonsNotifier extends StateNotifier<List<PersonModel>> {
  final dynamic _repo;

  PersonsNotifier(this._repo) : super([]) {
    _loadPersons();
  }

  void _loadPersons() {
    state = _repo.getAllPersons();
  }

  Future<void> addPerson(PersonModel person) async {
    await _repo.addPerson(person);
    _loadPersons();
  }

  Future<void> updatePerson(PersonModel person) async {
    await _repo.updatePerson(person);
    _loadPersons();
  }

  Future<void> deletePerson(String id) async {
    await _repo.deletePerson(id);
    _loadPersons();
  }
}
