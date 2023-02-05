import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pokedex/database/pokemon_favorite_box_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'favorite.g.dart';

final favoritesStreamProvider = StreamProvider.autoDispose((ref) async* {
  final box = await ref.read(pokemonFavoriteBoxProvider.future);
  final stream = box.watch().map((event) => box.toMap());
  yield box.toMap();
  yield* stream;
});

@riverpod
Future<void> toggleFavoritePokemon(ToggleFavoritePokemonRef ref, int id) async {
  final isFavorite =
      await ref.read(favoritesStreamProvider.future).then(((data) => data[id] ?? false));
  return ref.read(pokemonFavoriteBoxProvider.selectAsync((box) => box.put(id, !isFavorite)));
}
