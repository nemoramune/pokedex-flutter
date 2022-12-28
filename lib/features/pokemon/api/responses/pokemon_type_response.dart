import 'package:freezed_annotation/freezed_annotation.dart';

import 'pokemon_list_item_response.dart';

part 'pokemon_type_response.freezed.dart';

@freezed
class PokemonTypeResponse with _$PokemonTypeResponse {
  const factory PokemonTypeResponse({
    required int slot,
    required PokemonListItemResponse type,
  }) = _PokemonTypeResponse;
}
