import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pokedex/model/pokemon.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'pokedex.dart';

part 'pokemon_list.g.dart';

const _limit = 20;

// StateProviderは外部からstateを更新できるがNotifierは外部からstateを更新することはできない
final _pokemonListSizeProvider = StateProvider<int>((_) => _limit);

final isPokemonListLastProvider = StateProvider.autoDispose<bool>((_) => false);

@riverpod
Function loadListNextPage(LoadListNextPageRef ref) =>
    () => ref.read(_pokemonListSizeProvider.notifier).update((state) => state + _limit);

@riverpod
Future<List<int>> fetchedPokemonListIds(FetchedPokemonListIdsRef ref) async {
  final pokemonListSize = ref.watch(_pokemonListSizeProvider);
  final ids = List.generate(pokemonListSize, (index) => index + 1);
  await ref.read(fetchPokemonDataProvider(ids).future);
  return ids;
}

@riverpod
Future<List<Pokemon>> pokemonList(PokemonListRef ref) async {
  final pokemonListSize = ref.read(_pokemonListSizeProvider);
  final ids = await ref.watch(fetchedPokemonListIdsProvider.future);
  final list = await ref.watch(pokeDexProvider
      .selectAsync((data) => ids.map((id) => data[id]).whereType<Pokemon>().toList()));
  ref.read(isPokemonListLastProvider.notifier).update((state) => list.length < pokemonListSize);
  return list;
}
