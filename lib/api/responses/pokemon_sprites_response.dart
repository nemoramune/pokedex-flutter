import 'package:freezed_annotation/freezed_annotation.dart';

part 'pokemon_sprites_response.freezed.dart';
part 'pokemon_sprites_response.g.dart';

@freezed
class PokemonSpritesResponse with _$PokemonSpritesResponse {
  const factory PokemonSpritesResponse({
    required String frontDefault,
  }) = _PokemonSpritesResponse;

  factory PokemonSpritesResponse.fromJson(Map<String, dynamic> json) =>
      _$PokemonSpritesResponseFromJson(json);
}
