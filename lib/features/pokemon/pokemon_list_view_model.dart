import 'package:pokedex/features/pokemon/model/pokemon_list_item.dart';
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
    if (state is AsyncLoading) return;
    await _emitLoadingState();
    final currentStateValue = state.valueOrNull ?? const PokemonListState();
    int offset = currentStateValue.offset;
    final list = currentStateValue.list;
    final result = await ref.read(pokemonRepositoryProvider).getPokemonList(offset, limit);
    result.when(
      success: ((resultList) => _emit(
            list: list + resultList,
            offset: offset + limit,
            isLoadedToLast: resultList.isEmpty,
          )),
      failure: _onError,
    );
  }

  Future<void> refresh() async {
    final currentStateValue = state.valueOrNull;
    if (currentStateValue == null) return fetch();
    await _emitLoadingState();
    final result = await ref.read(pokemonRepositoryProvider).getPokemonList(0, limit);
    result.when(
      success: ((resultList) => _emit(
            list: resultList,
            offset: limit,
            isLoadedToLast: resultList.isEmpty,
          )),
      failure: _onError,
    );
  }

  Future<void> _emitLoadingState() => Future(() {
        state = const AsyncLoading<PokemonListState>().copyWithPrevious(state);
      });

  void _emit({
    required List<PokemonListItem> list,
    required int offset,
    required bool isLoadedToLast,
  }) {
    final currentStateValue = state.valueOrNull ?? const PokemonListState();
    state = AsyncData(
      currentStateValue.copyWith(
        list: list,
        offset: limit,
        isLoadedToLast: list.isEmpty,
      ),
    ).copyWithPrevious(state);
  }

  void _onError(Object error, StackTrace stackTrace) {
    state = AsyncError<PokemonListState>(error, stackTrace).copyWithPrevious(state);
  }
}
