import 'package:freezed_annotation/freezed_annotation.dart';

import 'pokemon_sprites_response.dart';
import 'pokemon_type_response.dart';

part 'pokemon_detail_response.freezed.dart';
part 'pokemon_detail_response.g.dart';

@freezed
class PokemonDetailResponse with _$PokemonDetailResponse {
  const factory PokemonDetailResponse({
    required int id,
    required String name,
    required int height,
    required int weight,
    required List<PokemonTypeResponse> types,
    required PokemonSpritesResponse sprites,
  }) = _PokemonDetailResponse;

  factory PokemonDetailResponse.fromJson(Map<String, dynamic> json) =>
      _$PokemonDetailResponseFromJson(json);
}
