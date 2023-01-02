import 'package:hive/hive.dart';

part 'pokemon_entity.g.dart';

@HiveType(typeId: 1)
class PokemonEntity {
  @HiveField(0)
  int id;
  @HiveField(1)
  String name;
  @HiveField(2)
  String imageUrl;
  @HiveField(3)
  List<String> types;
  @HiveField(4)
  String flavorText;
  @HiveField(5)
  int height;
  @HiveField(6)
  int weight;
  PokemonEntity({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.types,
    required this.flavorText,
    required this.height,
    required this.weight,
  });
}
