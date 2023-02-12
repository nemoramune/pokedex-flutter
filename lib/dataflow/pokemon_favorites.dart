import 'dart:math';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pokedex/model/pokemon.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'favorite.dart';
import 'pokedex.dart';

part 'pokemon_favorites.g.dart';

const _limit = 20;

final _pokemonFavoritesSizeProvider = StateProvider<int>((_) => _limit);

final isPokemonFavoritesLastProvider = StateProvider.autoDispose<bool>((_) => false);

@riverpod
Function loadFavoritesNextPage(LoadFavoritesNextPageRef ref) =>
    () => ref.read(_pokemonFavoritesSizeProvider.notifier).update((state) => state + _limit);

@riverpod
Future<List<Pokemon>> pokemonFavorites(PokemonFavoritesRef ref) async {
  final favoritesSize = ref.read(_pokemonFavoritesSizeProvider);
  final favoriteIds = await ref.watch(favoritesStreamProvider.selectAsync((data) =>
      data.entries.where((element) => element.value).map((e) => e.key).whereType<int>().toList()));
  final end = min(favoritesSize, favoriteIds.length);
  final requestIds = favoriteIds.sublist(0, end);
  final list = await ref.watch(getPokemonDataListProvider(requestIds).future);
  ref.read(isPokemonFavoritesLastProvider.notifier).update((state) => list.length < favoritesSize);
  return list;
}
