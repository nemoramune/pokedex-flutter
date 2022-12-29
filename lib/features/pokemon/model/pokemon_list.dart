import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pokedex/features/pokemon/api/responses/pokemon_list_response.dart';

import 'pokemon_list_item.dart';

part 'pokemon_list.freezed.dart';

@freezed
class PokemonList with _$PokemonList {
  const factory PokemonList({
    required int count,
    String? next,
    String? previous,
    required List<PokemonListItem> results,
  }) = _PokemonList;

  factory PokemonList.from(
    PokemonListResponse response,
  ) {
    return PokemonList(
      count: response.count,
      next: response.next,
      previous: response.previous,
      results: response.results.map((item) => PokemonListItem.from(item)).toList(),
    );
  }
}
