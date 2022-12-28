import 'package:dio/dio.dart';
import 'package:pokedex/providers/api_client_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../api/pokemon_api.dart';

part 'pokemon_api_provider.g.dart';

@riverpod
PokemonApi pokemonApi(PokemonApiRef ref) => PokemonApi(ref.read(apiClientProvider));
