import 'package:collection/collection.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pokedex/features/pokemon/api/responses/pokemon_detail_response.dart';
import 'package:pokedex/features/pokemon/api/responses/pokemon_species_response.dart';
import 'package:pokedex/features/pokemon/entity/pokemon_entity.dart';
import 'package:pokedex/features/pokemon/model/pokemon_type.dart';

part 'pokemon_detail.freezed.dart';

@freezed
class PokemonDetail with _$PokemonDetail {
  const factory PokemonDetail({
    required int id,
    required String name,
    required String imageUrl,
    required List<PokemonType> types,
    required String flavorText,
    required bool isFavorite,
    required int height,
    required int weight,
  }) = _PokemonDetail;

  factory PokemonDetail.fromEntity({
    required PokemonEntity entity,
    required bool? isFavorite,
  }) {
    return PokemonDetail(
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

  factory PokemonDetail.fromResponse({
    required PokemonDetailResponse detail,
    required PokemonSpeciesResponse species,
  }) {
    final nameJp =
        species.names.firstWhereOrNull((element) => element.language.name.startsWith("ja"))?.name ??
            detail.name;
    return PokemonDetail(
      id: detail.id,
      name: nameJp,
      imageUrl: detail.sprites.frontDefault,
      types: detail.types
          .map((type) => PokemonType.getOrNull(type.type.name))
          .whereType<PokemonType>()
          .toList(),
      flavorText: species.flavorTextEntries
              .lastWhereOrNull((element) => element.language.name.startsWith("ja"))
              ?.flavorText ??
          "",
      isFavorite: false,
      height: detail.height,
      weight: detail.weight,
    );
  }
}
