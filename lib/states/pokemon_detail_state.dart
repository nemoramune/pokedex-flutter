import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pokedex/model/pokemon.dart';

part 'pokemon_detail_state.freezed.dart';

@freezed
class PokemonDetailState with _$PokemonDetailState {
  const factory PokemonDetailState({
    Pokemon? data,
  }) = _PokemonDetailState;
}
