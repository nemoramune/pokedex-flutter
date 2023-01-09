import 'package:freezed_annotation/freezed_annotation.dart';

import 'pokemon_name_and_url_response.dart';

part 'pokemon_flavor_text_response.freezed.dart';
part 'pokemon_flavor_text_response.g.dart';

@freezed
class PokemonFlavorTextResponse with _$PokemonFlavorTextResponse {
  const factory PokemonFlavorTextResponse({
    required String flavorText,
    required PokemonNameAndUrlResponse language,
    required PokemonNameAndUrlResponse version,
  }) = _PokemonFlavorTextResponse;

  factory PokemonFlavorTextResponse.fromJson(Map<String, dynamic> json) =>
      _$PokemonFlavorTextResponseFromJson(json);
}
