import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pokedex/features/pokemon/api/responses/pokemon_list_item_response.dart';

part 'pokemon_list_item.freezed.dart';

@freezed
class PokemonListItem with _$PokemonListItem {
  const factory PokemonListItem({
    required String name,
    required String url,
  }) = _PokemonListItem;

  factory PokemonListItem.from(
    PokemonListItemResponse response,
  ) {
    return PokemonListItem(
      name: response.name,
      url: response.url,
    );
  }
}
