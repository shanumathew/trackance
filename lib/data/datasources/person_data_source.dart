import 'package:hive_flutter/hive_flutter.dart';
import 'package:trackance/data/datasources/hive_init.dart';
import 'package:trackance/data/models/person_model.dart';

abstract class PersonDataSource {
  Future<void> addPerson(PersonModel person);
  Future<void> updatePerson(PersonModel person);
  Future<void> deletePerson(String id);
  List<PersonModel> getAllPersons();
  PersonModel? getPerson(String id);
}

class PersonDataSourceImpl implements PersonDataSource {
  final Box<PersonModel> _box = HiveInit.getPersonBox();

  @override
  Future<void> addPerson(PersonModel person) async {
    await _box.put(person.id, person);
  }

  @override
  Future<void> updatePerson(PersonModel person) async {
    await _box.put(person.id, person);
  }

  @override
  Future<void> deletePerson(String id) async {
    await _box.delete(id);
  }

  @override
  List<PersonModel> getAllPersons() {
    return _box.values.toList();
  }

  @override
  PersonModel? getPerson(String id) {
    return _box.get(id);
  }
}
