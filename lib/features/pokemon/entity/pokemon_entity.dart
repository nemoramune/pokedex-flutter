import 'package:collection/collection.dart';
import 'package:hive/hive.dart';
import 'package:pokedex/features/pokemon/api/responses/pokemon_detail_response.dart';
import 'package:pokedex/features/pokemon/api/responses/pokemon_species_response.dart';

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

  factory PokemonEntity.from({
    required PokemonDetailResponse detail,
    required PokemonSpeciesResponse species,
  }) {
    final nameJp =
        species.names.firstWhereOrNull((element) => element.language.name.startsWith("ja"))?.name ??
            detail.name;
    return PokemonEntity(
        id: detail.id,
        name: nameJp,
        imageUrl: detail.sprites.frontDefault,
        types: detail.types.map((type) => type.type.name).toList(),
        flavorText: species.flavorTextEntries
                .lastWhereOrNull((element) => element.language.name.startsWith("ja"))
                ?.flavorText ??
            "",
        height: detail.height,
        weight: detail.weight);
  }
}
