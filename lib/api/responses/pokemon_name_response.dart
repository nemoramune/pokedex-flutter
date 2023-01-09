import 'package:freezed_annotation/freezed_annotation.dart';

import 'pokemon_name_and_url_response.dart';

part 'pokemon_name_response.freezed.dart';
part 'pokemon_name_response.g.dart';

@freezed
class PokemonNameResponse with _$PokemonNameResponse {
  const factory PokemonNameResponse({
    required String name,
    required PokemonNameAndUrlResponse language,
  }) = _PokemonNameResponse;
  factory PokemonNameResponse.fromJson(Map<String, dynamic> json) =>
      _$PokemonNameResponseFromJson(json);
}
