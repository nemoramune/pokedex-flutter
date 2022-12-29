import 'package:pokedex/features/pokemon/api/pokemon_api.dart';

import '../../utils/result.dart';
import 'model/pokemon_list.dart';

abstract class PokemonRepository {
  Future<Result<PokemonList>> getPokemonList(
    int offset,
    int limit,
  );
}

class PokemonRepositoryImpl implements PokemonRepository {
  PokemonRepositoryImpl(this._pokemonApi);
  final PokemonApi _pokemonApi;

  @override
  Future<Result<PokemonList>> getPokemonList(int offset, int limit) {
    return _pokemonApi
        .getPokemonList(offset, limit)
        .then((value) => PokemonList.from(value))
        .toResult();
  }
}
