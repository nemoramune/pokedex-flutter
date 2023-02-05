import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pokedex/model/pokemon.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'favorite.dart';
import 'pokemon_entities.dart';

part 'pokedex.g.dart';

final _pokedexCacheProvider = StateProvider<Map<int, Pokemon>>((_) => {});

@Riverpod(keepAlive: true)
Future<Map<int, Pokemon>> pokeDex(PokeDexRef ref) async {
  final cache = ref.watch(_pokedexCacheProvider);
  final favoriteMap = await ref.watch(favoritesStreamProvider.future);
  favoriteMap.forEach((id, isFavorite) {
    final pokemon = cache[id];
    if (pokemon == null || pokemon.isFavorite == isFavorite) return;
    cache[id] = pokemon.copyWith(isFavorite: isFavorite);
  });
  ref.read(_pokedexCacheProvider.notifier).update((_) => cache);
  return cache;
}

@riverpod
Future<void> fetchPokemonData(FetchPokemonDataRef ref, List<int> ids) async {
  final favoriteMap = await ref.read(favoritesStreamProvider.future);
  final cache = ref.read(_pokedexCacheProvider);
  final idsNotInCache = ids.where((id) => !cache.containsKey(id)).toList();
  if (idsNotInCache.isEmpty) return;
  final entities = await ref.read(pokemonEntitiesProvider(idsNotInCache).future);
  final pokemonMap = Map.fromEntries(entities.map((entity) {
    final isFavorite = favoriteMap[entity.id] ?? false;
    final pokemon = Pokemon.fromEntity(
      entity: entity,
      isFavorite: isFavorite,
    );
    return MapEntry(pokemon.id, pokemon);
  }));
  ref.watch(_pokedexCacheProvider.notifier).update((state) => {...state, ...pokemonMap});
}
