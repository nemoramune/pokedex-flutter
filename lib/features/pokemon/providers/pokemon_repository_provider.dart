import 'package:pokedex/features/pokemon/pokemon_repository.dart';
import 'package:pokedex/features/pokemon/providers/pokemon_api_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'pokemon_repository_provider.g.dart';

@riverpod
PokemonRepository pokemonRepository(PokemonRepositoryRef ref) =>
    PokemonRepositoryImpl(ref.read(pokemonApiProvider));
