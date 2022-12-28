import 'package:freezed_annotation/freezed_annotation.dart';

import 'pokemon_list_item_response.dart';

part 'pokemon_list_response.freezed.dart';

@freezed
class PokemonListResponse with _$PokemonListResponse {
  const factory PokemonListResponse({
    required int count,
    String? next,
    String? previous,
    required List<PokemonListItemResponse> results,
  }) = _PokemonListResponse;
}
