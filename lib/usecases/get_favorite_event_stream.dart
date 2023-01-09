import 'package:pokedex/repositories/pokemon_repository_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'get_favorite_event_stream.g.dart';

@riverpod
Future<Stream<int>> getFavoriteEventStream(GetFavoriteEventStreamRef ref) => ref
    .watch(pokemonRepositoryProvider.selectAsync((repository) => repository.favoriteEventStream));
