import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pokedex/model/pokemon_detail.dart';

part 'pokemon_detail_state.freezed.dart';

@freezed
class PokemonDetailState with _$PokemonDetailState {
  const factory PokemonDetailState({
    PokemonDetail? data,
  }) = _PokemonDetailState;
}
