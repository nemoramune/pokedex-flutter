import 'package:freezed_annotation/freezed_annotation.dart';

import 'pokemon_list_item_response.dart';

part 'pokemon_sprites_response.freezed.dart';

@freezed
class PokemonSpritesResponse with _$PokemonSpritesResponse {
  const factory PokemonSpritesResponse({
    @JsonKey(name: 'front_default') required String frontDefault,
  }) = _PokemonSpritesResponse;
}
