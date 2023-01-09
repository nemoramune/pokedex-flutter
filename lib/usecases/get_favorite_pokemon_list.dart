import 'package:pokedex/model/pokemon_list_item.dart';
import 'package:pokedex/repositories/pokemon_repository_provider.dart';
import 'package:pokedex/utils/result.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'get_favorite_pokemon_list.g.dart';

@riverpod
Future<Result<List<PokemonListItem>>> getFavoritePokemonList(
    GetFavoritePokemonListRef ref, int offset, int limit) async {
  final repository = await ref.watch(pokemonRepositoryProvider.future);
  return repository.getFavoritePokemonList(offset, limit);
}
