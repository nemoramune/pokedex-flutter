import 'package:hive/hive.dart';
import 'package:pokedex/features/pokemon/api/pokemon_api.dart';
import 'package:pokedex/features/pokemon/entity/pokemon_entity.dart';
import 'package:pokedex/features/pokemon/model/pokemon_list_item.dart';

import '../../utils/result.dart';

abstract class PokemonRepository {
  Future<Result<List<PokemonListItem>>> getPokemonList(
    int offset,
    int limit,
  );

  Future<Result<PokemonListItem>> favoritePokemon(int id);
  Future<Result<PokemonListItem>> unfavoritePokemon(int id);
}

class PokemonRepositoryImpl implements PokemonRepository {
  final PokemonApi _pokemonApi;
  final Box<PokemonEntity> _pokemonEntityBox;
  final Box<bool> _pokemonFavoriteBox;
  PokemonRepositoryImpl(this._pokemonApi, this._pokemonEntityBox, this._pokemonFavoriteBox);

  @override
  Future<Result<List<PokemonListItem>>> getPokemonList(int offset, int limit) {
    final requests = List.generate(limit, (index) => _getPokemon(offset + index + 1));
    return Future.wait(requests).toResult();
  }

  @override
  Future<Result<PokemonListItem>> favoritePokemon(int id) async {
    await _pokemonFavoriteBox.put(id, true);
    return _getPokemon(id).toResult();
  }

  @override
  Future<Result<PokemonListItem>> unfavoritePokemon(int id) async {
    await _pokemonFavoriteBox.put(id, false);
    return _getPokemon(id).toResult();
  }

  Future<PokemonListItem> _getPokemon(int id) async {
    final entity = _pokemonEntityBox.get(id);
    if (entity != null) {
      return PokemonListItem.fromEntity(
        entity: entity,
        isFavorite: _pokemonFavoriteBox.get(id, defaultValue: false),
      );
    }
    final detail = await _pokemonApi.getPokemon(id);
    final species = await _pokemonApi.getPokemonSpecies(id);
    await _pokemonEntityBox.put(id, PokemonEntity.from(detail: detail, species: species));
    return PokemonListItem.fromResponse(detail: detail, species: species);
  }
}
