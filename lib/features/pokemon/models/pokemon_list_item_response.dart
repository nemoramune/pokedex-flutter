import 'package:freezed_annotation/freezed_annotation.dart';

part 'pokemon_list_item_response.freezed.dart';

@freezed
class PokemonListItemResponse with _$PokemonListItemResponse {
  const factory PokemonListItemResponse({
    required String name,
    required String url,
  }) = _PokemonListItemResponse;
}
