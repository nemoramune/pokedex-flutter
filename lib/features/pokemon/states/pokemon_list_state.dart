import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pokedex/features/pokemon/model/pokemon_list.dart';
part 'pokemon_list_state.freezed.dart';

@freezed
class PokemonListState with _$PokemonListState {
  const factory PokemonListState({
    @Default(null) PokemonList? list,
    @Default(0) int offset,
  }) = _PokemonListState;
}
