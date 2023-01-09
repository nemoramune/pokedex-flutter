import 'package:freezed_annotation/freezed_annotation.dart';

import 'pokemon_flavor_text_response.dart';
import 'pokemon_name_response.dart';

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
