import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pokedex/model/pokemon.dart';

part 'pokemon_list_state.freezed.dart';

@freezed
class PokemonListState with _$PokemonListState {
  const factory PokemonListState({
    @Default(null) List<Pokemon>? list,
    @Default(0) int offset,
    @Default(false) bool isLoadedToLast,
  }) = _PokemonListState;
}
