import 'package:trackance/data/datasources/person_data_source.dart';
import 'package:trackance/data/models/person_model.dart';

abstract class PersonRepository {
  Future<void> addPerson(PersonModel person);
  Future<void> updatePerson(PersonModel person);
  Future<void> deletePerson(String id);
  List<PersonModel> getAllPersons();
  PersonModel? getPerson(String id);
}

class PersonRepositoryImpl implements PersonRepository {
  final PersonDataSource _dataSource;

  PersonRepositoryImpl(this._dataSource);

  @override
  Future<void> addPerson(PersonModel person) async {
    await _dataSource.addPerson(person);
  }

  @override
  Future<void> updatePerson(PersonModel person) async {
    await _dataSource.updatePerson(person);
  }

  @override
  Future<void> deletePerson(String id) async {
    await _dataSource.deletePerson(id);
  }

  @override
  List<PersonModel> getAllPersons() {
    return _dataSource.getAllPersons();
  }

  @override
  PersonModel? getPerson(String id) {
    return _dataSource.getPerson(id);
  }
}
