import 'package:pokedex/api/pokemon_api_provider.dart';
import 'package:pokedex/database/pokemon_entity_box_provider.dart';
import 'package:pokedex/entity/pokemon_entity.dart';
import 'package:pokedex/utils/result.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'pokemon_entities.g.dart';

@riverpod
Future<List<PokemonEntity>> pokemonEntities(PokemonEntitiesRef ref, List<int> ids) async {
  final pokemonEntityBox = await ref.read(pokemonEntityBoxProvider.future);
  final pokemonApi = ref.read(pokemonApiProvider);
  getPokemonEntity(id) async {
    final entity = pokemonEntityBox.get(id);
    if (entity != null) return entity;
    final detail = await pokemonApi.getPokemon(id);
    final species = await pokemonApi.getPokemonSpecies(id);
    final entityFromResponse = PokemonEntity.from(detail: detail, species: species);
    await pokemonEntityBox.put(id, entityFromResponse);
    return entityFromResponse;
  }

  return Future.wait(ids.map((id) => getPokemonEntity(id).onNotFoundErrorToNull()))
      .then((list) => list.whereType<PokemonEntity>().toList());
}
