import 'package:hive/hive.dart';

part 'person_model.g.dart';

@HiveType(typeId: 1)
class PersonModel {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String avatar;

  PersonModel({required this.id, required this.name, required this.avatar});

  PersonModel copyWith({String? id, String? name, String? avatar}) {
    return PersonModel(
      id: id ?? this.id,
      name: name ?? this.name,
      avatar: avatar ?? this.avatar,
    );
  }
}
