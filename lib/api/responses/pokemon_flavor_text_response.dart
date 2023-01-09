import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pokedex/features/pokemon/api/responses/pokemon_name_and_url_response.dart';
import 'package:pokedex/features/pokemon/api/responses/pokemon_name_response.dart';
import 'package:pokedex/features/pokemon/model/pokemon_list_item.dart';

import 'pokemon_sprites_response.dart';
import 'pokemon_type_response.dart';

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
