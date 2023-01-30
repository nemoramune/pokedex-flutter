import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pokedex/entity/pokemon_entity.dart';
import 'package:pokedex/model/pokemon_type.dart';

part 'pokemon.freezed.dart';

@freezed
class Pokemon with _$Pokemon {
  const factory Pokemon({
    required int id,
    required String name,
    required String imageUrl,
    required List<PokemonType> types,
    required String flavorText,
    required bool isFavorite,
    required int height,
    required int weight,
  }) = _Pokemon;

  factory Pokemon.fromEntity({
    required PokemonEntity entity,
    required bool? isFavorite,
  }) {
    return Pokemon(
        id: entity.id,
        name: entity.name,
        imageUrl: entity.imageUrl,
        types: entity.types
            .map((type) => PokemonType.getOrNull(type))
            .whereType<PokemonType>()
            .toList(),
        flavorText: entity.flavorText,
        isFavorite: isFavorite ?? false,
        height: entity.height,
        weight: entity.weight);
  }
}
