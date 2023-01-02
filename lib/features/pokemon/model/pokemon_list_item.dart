import 'package:collection/collection.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pokedex/features/pokemon/api/responses/pokemon_detail_response.dart';
import 'package:pokedex/features/pokemon/api/responses/pokemon_name_and_url_response.dart';
import 'package:pokedex/features/pokemon/api/responses/pokemon_species_response.dart';
import 'package:pokedex/features/pokemon/model/pokemon_type.dart';

part 'pokemon_list_item.freezed.dart';

@freezed
class PokemonListItem with _$PokemonListItem {
  const factory PokemonListItem({
    required String name,
    required String imageUrl,
    required List<PokemonType> types,
    required String flavorText,
  }) = _PokemonListItem;

  factory PokemonListItem.from({
    required PokemonDetailResponse detail,
    required PokemonSpeciesResponse species,
  }) {
    final nameJp =
        species.names.firstWhereOrNull((element) => element.language.name.startsWith("ja"))?.name ??
            detail.name;
    return PokemonListItem(
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
    );
  }
}
