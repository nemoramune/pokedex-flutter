import 'package:pokedex/model/pokemon.dart';
import 'package:pokedex/utils/result.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'get_pokemon_detail.dart';
import 'toggle_favorite_pokemon.dart';

part 'get_pokemon_detail_with_favorite_toggled.g.dart';

@riverpod
Future<Result<Pokemon>> getPokemonDetailWithFavoriteToggled(
  GetPokemonDetailWithFavoriteToggledRef ref,
  int id,
) =>
    ref
        .read(toggleFavoritePokemonProvider(id).future)
        .then((_) => ref.read(getPokemonDetailProvider(id).future));
