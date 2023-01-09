import 'package:pokedex/providers/pokemon_api_provider.dart';
import 'package:pokedex/providers/pokemon_entity_box_provider.dart';
import 'package:pokedex/providers/pokemon_favorite_box_provider.dart';
import 'package:pokedex/repositories/pokemon_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'pokemon_repository_provider.g.dart';

@riverpod
Future<PokemonRepository> pokemonRepository(PokemonRepositoryRef ref) async =>
    PokemonRepositoryImpl(
      ref.read(pokemonApiProvider),
      await ref.read(pokemonEntityBoxProvider.future),
      await ref.read(pokemonFavoriteBoxProvider.future),
    );
