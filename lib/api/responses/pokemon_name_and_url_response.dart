import 'package:freezed_annotation/freezed_annotation.dart';

part 'pokemon_name_and_url_response.freezed.dart';
part 'pokemon_name_and_url_response.g.dart';

@freezed
class PokemonNameAndUrlResponse with _$PokemonNameAndUrlResponse {
  const factory PokemonNameAndUrlResponse({
    required String name,
    required String url,
  }) = _PokemonNameAndUrlResponse;

  factory PokemonNameAndUrlResponse.fromJson(Map<String, dynamic> json) =>
      _$PokemonNameAndUrlResponseFromJson(json);
}
