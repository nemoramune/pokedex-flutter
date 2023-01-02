import 'package:pokedex/features/pokemon/api/pokemon_api.dart';
import 'package:pokedex/features/pokemon/api/responses/pokemon_detail_response.dart';
import 'package:pokedex/features/pokemon/api/responses/pokemon_species_response.dart';
import 'package:pokedex/features/pokemon/model/pokemon_list_item.dart';
import 'package:pokedex/features/pokemon/model/pokemon_type.dart';

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
    final requests = List.generate(
      limit,
      (i) async {
        final detail = await _pokemonApi.getPokemon(offset + i + 1);
        final species = await _pokemonApi.getPokemonSpecies(offset + i + 1);
        return PokemonListItem.from(detail: detail, species: species);
      },
    );
    return Future.wait(requests).toResult();
  }
}
