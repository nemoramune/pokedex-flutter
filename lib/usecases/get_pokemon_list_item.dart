import 'package:pokedex/model/pokemon_list_item.dart';
import 'package:pokedex/repositories/pokemon_repository_provider.dart';
import 'package:pokedex/utils/result.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'get_pokemon_list_item.g.dart';

@riverpod
Future<Result<PokemonListItem>> getPokemonListItem(GetPokemonListItemRef ref, int id) async {
  final repository = await ref.watch(pokemonRepositoryProvider.future);
  return repository.getPokemonListItem(id);
}
