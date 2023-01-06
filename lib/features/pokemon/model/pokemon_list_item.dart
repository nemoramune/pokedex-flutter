import 'package:collection/collection.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pokedex/features/pokemon/api/responses/pokemon_detail_response.dart';
import 'package:pokedex/features/pokemon/api/responses/pokemon_species_response.dart';
import 'package:pokedex/features/pokemon/entity/pokemon_entity.dart';
import 'package:pokedex/features/pokemon/model/pokemon_type.dart';

part 'pokemon_list_item.freezed.dart';

@freezed
class PokemonListItem with _$PokemonListItem {
  const factory PokemonListItem({
    required int id,
    required String name,
    required String imageUrl,
    required List<PokemonType> types,
    required bool isFavorite,
  }) = _PokemonListItem;

  factory PokemonListItem.fromEntity({
    required PokemonEntity entity,
    required bool? isFavorite,
  }) {
    return PokemonListItem(
      id: entity.id,
      name: entity.name,
      imageUrl: entity.imageUrl,
      types:
          entity.types.map((type) => PokemonType.getOrNull(type)).whereType<PokemonType>().toList(),
      isFavorite: isFavorite ?? false,
    );
  }

  factory PokemonListItem.fromResponse({
    required PokemonDetailResponse detail,
    required PokemonSpeciesResponse species,
  }) {
    final nameJp =
        species.names.firstWhereOrNull((element) => element.language.name.startsWith("ja"))?.name ??
            detail.name;
    return PokemonListItem(
      id: detail.id,
      name: nameJp,
      imageUrl: detail.sprites.frontDefault,
      types: detail.types
          .map((type) => PokemonType.getOrNull(type.type.name))
          .whereType<PokemonType>()
          .toList(),
      isFavorite: false,
    );
  }
}
