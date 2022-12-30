import 'package:pokedex/features/pokemon/api/pokemon_api.dart';
import 'package:pokedex/features/pokemon/model/pokemon_list_item.dart';

import '../../utils/result.dart';

abstract class PokemonRepository {
  Future<Result<List<PokemonListItem>>> getPokemonList(
    int offset,
    int limit,
  );
}

class PokemonRepositoryImpl implements PokemonRepository {
  PokemonRepositoryImpl(this._pokemonApi);
  final PokemonApi _pokemonApi;

  @override
  Future<Result<List<PokemonListItem>>> getPokemonList(int offset, int limit) {
    return _pokemonApi
        .getPokemonList(offset, limit)
        .then((value) => value.results.map((item) => PokemonListItem.from(item)).toList())
        .toResult();
  }
}
