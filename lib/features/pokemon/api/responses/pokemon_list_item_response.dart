import 'package:freezed_annotation/freezed_annotation.dart';

part 'pokemon_list_item_response.freezed.dart';
part 'pokemon_list_item_response.g.dart';

@freezed
class PokemonListItemResponse with _$PokemonListItemResponse {
  const factory PokemonListItemResponse({
    required String name,
    required String url,
  }) = _PokemonListItemResponse;

  factory PokemonListItemResponse.fromJson(Map<String, dynamic> json) =>
      _$PokemonListItemResponseFromJson(json);
}
