import 'package:freezed_annotation/freezed_annotation.dart';

import 'pokemon_name_and_url_response.dart';

part 'pokemon_list_response.freezed.dart';
part 'pokemon_list_response.g.dart';

@freezed
class PokemonListResponse with _$PokemonListResponse {
  const factory PokemonListResponse({
    required int count,
    String? next,
    String? previous,
    required List<PokemonNameAndUrlResponse> results,
  }) = _PokemonListResponse;

  factory PokemonListResponse.fromJson(Map<String, dynamic> json) =>
      _$PokemonListResponseFromJson(json);
}
