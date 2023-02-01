import 'dart:math';

import 'package:dio/dio.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pokedex/api/pokemon_api.dart';
import 'package:pokedex/entity/pokemon_entity.dart';
import 'package:pokedex/model/pokemon.dart';

import '../utils/result.dart';

abstract class PokemonRepository {
  Future<Result<List<Pokemon>>> getPokemonList(
    int offset,
    int limit,
  );
  Future<Result<List<Pokemon>>> getFavoritePokemonList(
    int offset,
    int limit,
  );

  Future<Result<Pokemon>> getPokemon(int id);

  bool isFavorite(int id);
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
  Future<Result<List<Pokemon>>> getPokemonList(int offset, int limit) {
    final requests = List<Future<Pokemon?>>.generate(
      limit,
      (index) => awaitCatching<Pokemon?, DioError>(
        () => _getPokemonFuture(offset + index + 1),
        onError: () => null,
        test: (error) => error.response?.statusCode == 404,
      ).thenNullable(),
    );
    return Future.wait(requests).then((list) => list.whereType<Pokemon>().toList()).toResult();
  }

  @override
  Future<Result<List<Pokemon>>> getFavoritePokemonList(int offset, int limit) {
    final favoriteIds = _pokemonFavoriteBox.toMap()..removeWhere((key, value) => !value);
    final start = min(offset, favoriteIds.length);
    final end = min(offset + limit, favoriteIds.length);
    final requests = favoriteIds.keys.whereType<int>().toList().sublist(start, end).map(
          (id) => awaitCatching<Pokemon?, DioError>(
            () => _getPokemonFuture(id),
            onError: () => null,
            test: (error) => error.response?.statusCode == 404,
          ).thenNullable(),
        );
    return Future.wait(requests).then((list) => list.whereType<Pokemon>().toList()).toResult();
  }

  @override
  bool isFavorite(int id) => _pokemonFavoriteBox.get(id) ?? false;

  @override
  Future<Result<void>> favoritePokemon(int id) => _pokemonFavoriteBox.put(id, true).toResult();

  @override
  Future<Result<void>> unfavoritePokemon(int id) => _pokemonFavoriteBox.put(id, false).toResult();

  @override
  Future<Result<Pokemon>> getPokemon(int id) => _getPokemonFuture(id).toResult();

  Future<Pokemon> _getPokemonFuture(int id) =>
      _getPokemonEntity(id).then((entity) => Pokemon.fromEntity(
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
