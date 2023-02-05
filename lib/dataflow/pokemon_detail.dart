import 'package:pokedex/model/pokemon.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'pokedex.dart';

part 'pokemon_detail.g.dart';

@riverpod
Future<Pokemon> pokemon(PokemonRef ref, int id) async {
  await ref.read(fetchPokemonDataProvider([id]).future);
  return ref.watch(pokeDexProvider.selectAsync((data) => data[id]!));
}
