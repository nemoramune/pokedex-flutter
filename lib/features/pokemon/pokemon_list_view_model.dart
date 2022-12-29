import 'package:pokedex/features/pokemon/providers/pokemon_repository_provider.dart';
import 'package:pokedex/features/pokemon/states/pokemon_list_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'pokemon_list_view_model.g.dart';

@riverpod
class PokemonListViewModel extends _$PokemonListViewModel {
  @override
  FutureOr<PokemonListState> build() => const PokemonListState();

  static const int limit = 20;

  Future<void> fetch() async {
    // state = const AsyncLoading();
    int offset = state.value?.offset ?? 0;
    final result = await ref.read(pokemonRepositoryProvider).getPokemonList(offset, limit);
    final currentState = state.valueOrNull ?? const PokemonListState();
    result.when(
        success: ((list) => state = AsyncData(currentState.copyWith(list: list))),
        failure: ((e, stack) => state = AsyncError(e, stack)));
  }
}
