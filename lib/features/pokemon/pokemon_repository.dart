import 'package:dio/dio.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pokedex/features/pokemon/api/pokemon_api.dart';
import 'package:pokedex/features/pokemon/entity/pokemon_entity.dart';
import 'package:pokedex/features/pokemon/model/pokemon_detail.dart';
import 'package:pokedex/features/pokemon/model/pokemon_list_item.dart';

import '../../utils/result.dart';

abstract class PokemonRepository {
  Future<Result<List<PokemonListItem>>> getPokemonList(
    int offset,
    int limit,
  );
  Future<Result<PokemonListItem>> getPokemonListItem(int id);

  Future<Result<PokemonDetail>> getPokemonDetail(int id);

  Future<Result<void>> favoritePokemon(int id);
  Future<Result<void>> unfavoritePokemon(int id);

  Stream<int> get favoriteEventStream;
}

class PokemonRepositoryImpl implements PokemonRepository {
  final PokemonApi _pokemonApi;
  final Box<PokemonEntity> _pokemonEntityBox;
  final Box<bool> _pokemonFavoriteBox;
  PokemonRepositoryImpl(this._pokemonApi, this._pokemonEntityBox, this._pokemonFavoriteBox);

  @override
  Future<Result<List<PokemonListItem>>> getPokemonList(int offset, int limit) {
    final requests = List<Future<PokemonListItem?>>.generate(
      limit,
      (index) => awaitCatching<PokemonListItem?, DioError>(
        () => _getPokemonListItem(offset + index + 1),
        onError: () => null,
        test: (error) => error.response?.statusCode == 404,
      ).thenNullable(),
    );
    return Future.wait(requests)
        .then((list) => list.whereType<PokemonListItem>().toList())
        .toResult();
  }

  @override
  Future<Result<void>> favoritePokemon(int id) => _pokemonFavoriteBox.put(id, true).toResult();

  @override
  Future<Result<void>> unfavoritePokemon(int id) => _pokemonFavoriteBox.put(id, false).toResult();

  @override
  Future<Result<PokemonListItem>> getPokemonListItem(int id) => _getPokemonListItem(id).toResult();

  @override
  Future<Result<PokemonDetail>> getPokemonDetail(int id) => _getPokemonEntity(id)
      .then((entity) => PokemonDetail.fromEntity(
            entity: entity,
            isFavorite: _pokemonFavoriteBox.get(id, defaultValue: false),
          ))
      .toResult();

  Future<PokemonListItem> _getPokemonListItem(int id) =>
      _getPokemonEntity(id).then((entity) => PokemonListItem.fromEntity(
          entity: entity, isFavorite: _pokemonFavoriteBox.get(id, defaultValue: false)));

  Future<PokemonEntity> _getPokemonEntity(int id) async {
    final entity = _pokemonEntityBox.get(id);
    if (entity != null) return entity;
    final detail = await _pokemonApi.getPokemon(id);
    final species = await _pokemonApi.getPokemonSpecies(id);
    final entityFromResponse = PokemonEntity.from(detail: detail, species: species);
    await _pokemonEntityBox.put(id, entityFromResponse);
    return entityFromResponse;
  }

  @override
  Stream<int> get favoriteEventStream =>
      _pokemonFavoriteBox.watch().where((event) => event.key is int).map((event) => event.key);
}
