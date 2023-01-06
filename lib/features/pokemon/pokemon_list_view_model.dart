import 'package:pokedex/features/pokemon/model/pokemon_list_item.dart';
import 'package:pokedex/features/pokemon/pokemon_repository.dart';
import 'package:pokedex/features/pokemon/providers/pokemon_repository_provider.dart';
import 'package:pokedex/features/pokemon/states/pokemon_list_state.dart';
import 'package:pokedex/utils/result.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'pokemon_list_view_model.g.dart';

@riverpod
class PokemonListViewModel extends _$PokemonListViewModel {
  @override
  FutureOr<PokemonListState> build() async {
    final repository = await _pokemonRepositoryFuture;
    repository.favoriteEventStream.listen(_updateFavorite);
    return const PokemonListState();
  }

  Future<PokemonRepository> get _pokemonRepositoryFuture =>
      ref.read(pokemonRepositoryProvider.future);

  static const int limit = 20;

  Future<void> fetch() => _fetch();

  Future<void> refresh() => _fetch(isRefresh: true);

  Future<void> _fetch({bool isRefresh = false}) async {
    if (state.isReloading) return;
    await _emitLoadingState();
    final currentStateValue = state.valueOrNull ?? const PokemonListState();
    int offset = isRefresh ? 0 : currentStateValue.offset;
    final list = currentStateValue.list;
    final repository = await _pokemonRepositoryFuture;
    final result = await repository.getPokemonList(offset, limit);
    result
        .onSuccess(
          (resultList) => _emit(
            list: isRefresh ? resultList : list + resultList,
            offset: offset + limit,
            isLoadedToLast: resultList.length < limit,
          ),
        )
        .onFailure(_onError);
  }

  Future<void> favorite(PokemonListItem item) async {
    final currentStateValue = state.valueOrNull;
    if (currentStateValue == null) return;
    // TODO refactor by use case
    final repository = await _pokemonRepositoryFuture;
    final favoriteRequest =
        item.isFavorite ? repository.unfavoritePokemon : repository.favoritePokemon;
    await favoriteRequest(item.id).then((_) => _updateFavorite(item.id));
  }

  Future<void> _updateFavorite(int id) async {
    final currentStateValue = state.valueOrNull;
    if (currentStateValue == null) return;
    final repository = await _pokemonRepositoryFuture;
    final result = await repository.getPokemonListItem(id);
    result.onSuccess((resultItem) {
      final list = currentStateValue.list.toList();
      final index = list.indexWhere((item) => item.id == id);
      if (index == -1) return;
      list[index] = resultItem;
      _emit(list: list);
    }).onFailure(_onError);
  }

  void _emit({
    required List<PokemonListItem> list,
    int? offset,
    bool? isLoadedToLast,
  }) {
    final currentStateValue = state.valueOrNull ?? const PokemonListState();
    state = AsyncData(
      currentStateValue.copyWith(
        list: list,
        offset: offset ?? currentStateValue.offset,
        isLoadedToLast: isLoadedToLast ?? currentStateValue.isLoadedToLast,
      ),
    ).copyWithPrevious(state);
  }

  void _onError(Object error, StackTrace stackTrace) {
    state = AsyncError<PokemonListState>(error, stackTrace).copyWithPrevious(state);
  }

  Future<void> _emitLoadingState() => Future(() {
        state = const AsyncLoading<PokemonListState>().copyWithPrevious(state);
      });
}
