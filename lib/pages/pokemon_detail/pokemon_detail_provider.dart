import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pokedex/api/pokemon_api_provider.dart';
import 'package:pokedex/database/pokemon_entity_box_provider.dart';
import 'package:pokedex/database/pokemon_favorite_box_provider.dart';
import 'package:pokedex/entity/pokemon_entity.dart';
import 'package:pokedex/model/pokemon.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'pokemon_detail_provider.g.dart';

final _isPokemonFavoriteProvider = StreamProvider.autoDispose.family<bool, int>((ref, id) async* {
  final box = await ref.watch(pokemonFavoriteBoxProvider.future);
  final stream = box.watch(key: id).map((event) => event.value).cast<bool>();
  yield box.get(id) ?? false;
  yield* stream;
});

@riverpod
Future<void> toggleFavoritePokemon(ToggleFavoritePokemonRef ref, int id) async {
  final isFavorite = await ref.watch(_isPokemonFavoriteProvider(id).future);
  return ref.watch(pokemonFavoriteBoxProvider.selectAsync((box) => box.put(id, !isFavorite)));
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
  final entity = await ref.watch(pokemonEntityProvider(id).future);
  final isFavorite = await ref.watch(_isPokemonFavoriteProvider(id).future);
  return Pokemon.fromEntity(
    entity: entity,
    isFavorite: isFavorite,
  );
}
