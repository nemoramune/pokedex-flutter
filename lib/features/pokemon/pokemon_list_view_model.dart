import 'package:pokedex/features/pokemon/providers/pokemon_repository_provider.dart';
import 'package:pokedex/features/pokemon/states/pokemon_list_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'pokemon_list_view_model.g.dart';

@riverpod
class PokemonListViewModel extends _$PokemonListViewModel {
  @override
  FutureOr<PokemonListState> build() {
    fetch();
    return const PokemonListState();
  }

  static const int limit = 20;

  Future<void> fetch() async {
    final currentStateValue = state.valueOrNull ?? const PokemonListState();
    int offset = currentStateValue.offset;
    final list = currentStateValue.list;
    final result = await ref.read(pokemonRepositoryProvider).getPokemonList(offset, limit);
    result.when(
        success: ((resultList) => state = AsyncData(currentStateValue.copyWith(
              list: list + resultList,
              offset: offset + limit,
              isLoadedToLast: resultList.isEmpty,
            )).copyWithPrevious(state)),
        failure: ((e, stack) =>
            state = AsyncError<PokemonListState>(e, stack).copyWithPrevious(state)));
  }

  Future<void> refresh() async {
    final currentStateValue = state.valueOrNull;
    if (currentStateValue == null) return fetch();
    state = AsyncData(currentStateValue.copyWith(list: [], offset: 0)).copyWithPrevious(state);
    fetch();
  }
}
