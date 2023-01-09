import 'package:freezed_annotation/freezed_annotation.dart';

import 'pokemon_name_and_url_response.dart';

part 'pokemon_type_response.freezed.dart';
part 'pokemon_type_response.g.dart';

@freezed
class PokemonTypeResponse with _$PokemonTypeResponse {
  const factory PokemonTypeResponse({
    required int slot,
    required PokemonNameAndUrlResponse type,
  }) = _PokemonTypeResponse;
  factory PokemonTypeResponse.fromJson(Map<String, dynamic> json) =>
      _$PokemonTypeResponseFromJson(json);
}
