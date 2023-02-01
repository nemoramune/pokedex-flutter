import 'package:collection/collection.dart';
import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pokedex/api/pokemon_api_provider.dart';
import 'package:pokedex/database/pokemon_entity_box_provider.dart';
import 'package:pokedex/database/pokemon_favorite_box_provider.dart';
import 'package:pokedex/entity/pokemon_entity.dart';
import 'package:pokedex/model/pokemon.dart';
import 'package:pokedex/utils/result.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'pokemon_detail_provider.g.dart';

// StateProviderは外部からstateを更新できるがNotifierは外部からstateを更新することはできない
final _pokemonListSizeProvider = StateProvider<int>((_) => 0);

final isPokemonListLast = StateProvider.autoDispose<bool>((_) => false);

const _limit = 20;

@riverpod
Function loadListNextPage(LoadListNextPageRef ref) =>
    () => ref.read(_pokemonListSizeProvider.notifier).update((state) => state + _limit);

@riverpod
Future<List<Pokemon>> pokemonList(PokemonListRef ref) async {
  final pokemonListSize = ref.watch(_pokemonListSizeProvider);
  final favorites = await ref.watch(_favoritesStreamProvider.future);
  final futures = List.generate(
      pokemonListSize,
      (index) => awaitCatching<PokemonEntity?, DioError>(
            () => ref.read(pokemonEntityProvider(index + 1).future),
            onError: () => null,
            test: (error) => error.response?.statusCode == 404,
          ).thenNullable());
  return Future.wait(futures).then((list) => list.whereType<PokemonEntity>().toList()).then(
      (list) => list
          .map((entity) =>
              Pokemon.fromEntity(entity: entity, isFavorite: favorites[entity.id] ?? false))
          .toList());
}

@riverpod
Future<bool> isPokemonFavorite(IsPokemonFavoriteRef ref, int id) =>
    ref.watch(_favoritesStreamProvider.selectAsync((data) => data[id] ?? false));

// final _isPokemonFavoriteProvider = StreamProvider.autoDispose.family<bool, int>((ref, id) async* {
//   final box = await ref.watch(_favoritesStreamProvider.selectAsync((data) => data[id] ?? false));
//   final stream = box.watch(key: id).map((event) => event.value).cast<bool>();
//   yield box.get(id) ?? false;
//   yield* stream;
// });

final _favoritesStreamProvider = StreamProvider.autoDispose((ref) async* {
  final box = await ref.watch(pokemonFavoriteBoxProvider.future);
  final stream = box.watch().map((event) => box.toMap());
  yield box.toMap();
  yield* stream;
});

@riverpod
Future<void> toggleFavoritePokemon(ToggleFavoritePokemonRef ref, int id) async {
  final isFavorite = await ref.read(isPokemonFavoriteProvider(id).future);
  return ref.read(pokemonFavoriteBoxProvider.selectAsync((box) => box.put(id, !isFavorite)));
}

@riverpod
Future<PokemonEntity> pokemonEntity(PokemonEntityRef ref, int id) async {
  final pokemonApi = ref.read(pokemonApiProvider);
  final pokemonEntityBox = await ref.read(pokemonEntityBoxProvider.future);
  final entity = pokemonEntityBox.get(id);
  if (entity != null) return entity;
  final detail = await pokemonApi.getPokemon(id);
  final species = await pokemonApi.getPokemonSpecies(id);
  final entityFromResponse = PokemonEntity.from(detail: detail, species: species);
  await pokemonEntityBox.put(id, entityFromResponse);
  return entityFromResponse;
}

@riverpod
Future<Pokemon> pokemon(PokemonRef ref, int id) async {
  final data = await ref.watch(pokemonListProvider
      .selectAsync((list) => list.firstWhereOrNull((element) => element.id == id)));
  if (data != null) return data;
  final entity = await ref.watch(pokemonEntityProvider(id).future);
  final isFavorite = await ref.watch(isPokemonFavoriteProvider(id).future);
  return Pokemon.fromEntity(
    entity: entity,
    isFavorite: isFavorite,
  );
}
