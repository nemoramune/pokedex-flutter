import 'package:pokedex/model/pokemon.dart';
import 'package:pokedex/repositories/pokemon_repository_provider.dart';
import 'package:pokedex/utils/result.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'get_pokemon.g.dart';

@riverpod
Future<Result<Pokemon>> getPokemon(GetPokemonRef ref, int id) async {
  final repository = await ref.watch(pokemonRepositoryProvider.future);
  return repository.getPokemon(id);
}
