import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pokedex/features/pokemon/api/responses/pokemon_flavor_text_response.dart';
import 'package:pokedex/features/pokemon/api/responses/pokemon_name_and_url_response.dart';
import 'package:pokedex/features/pokemon/api/responses/pokemon_name_response.dart';

import 'pokemon_sprites_response.dart';
import 'pokemon_type_response.dart';

part 'pokemon_species_response.freezed.dart';
part 'pokemon_species_response.g.dart';

@freezed
class PokemonSpeciesResponse with _$PokemonSpeciesResponse {
  const factory PokemonSpeciesResponse({
    required int id,
    required String name,
    required List<PokemonNameResponse> names,
    required List<PokemonFlavorTextResponse> flavorTextEntries,
  }) = _PokemonSpeciesResponse;

  factory PokemonSpeciesResponse.fromJson(Map<String, dynamic> json) =>
      _$PokemonSpeciesResponseFromJson(json);
}
