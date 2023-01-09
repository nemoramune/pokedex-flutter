import 'package:pokedex/model/pokemon_detail.dart';
import 'package:pokedex/repositories/pokemon_repository_provider.dart';
import 'package:pokedex/utils/result.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'get_pokemon_detail.g.dart';

@riverpod
Future<Result<PokemonDetail>> getPokemonDetail(GetPokemonDetailRef ref, int id) async {
  final repository = await ref.watch(pokemonRepositoryProvider.future);
  return repository.getPokemonDetail(id);
}
