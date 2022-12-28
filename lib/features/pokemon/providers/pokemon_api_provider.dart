import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../api/pokemon_api.dart';

part 'pokemon_api_provider.g.dart';

@riverpod
PokemonApi pokemonApi(_) => PokemonApi(Dio());
