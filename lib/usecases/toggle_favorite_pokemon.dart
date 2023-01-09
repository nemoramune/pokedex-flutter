import 'package:pokedex/repositories/pokemon_repository_provider.dart';
import 'package:pokedex/utils/result.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'toggle_favorite_pokemon.g.dart';

@riverpod
Future<Result<void>> toggleFavoritePokemon(ToggleFavoritePokemonRef ref, int id) async {
  final repository = await ref.watch(pokemonRepositoryProvider.future);
  final isFavorite = repository.isFavorite(id);
  final toggleFavoriteRequest =
      isFavorite ? repository.unfavoritePokemon : repository.favoritePokemon;
  return toggleFavoriteRequest(id);
}
