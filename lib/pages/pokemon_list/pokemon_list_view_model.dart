import 'package:pokedex/model/pokemon.dart';
import 'package:pokedex/states/pokemon_list_state.dart';
import 'package:pokedex/usecases/get_favorite_event_stream.dart';
import 'package:pokedex/usecases/get_pokemon.dart';
import 'package:pokedex/usecases/get_pokemon_list.dart';
import 'package:pokedex/usecases/toggle_favorite_pokemon.dart';
import 'package:pokedex/utils/result.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'pokemon_list_view_model.g.dart';

@riverpod
class PokemonListViewModel extends _$PokemonListViewModel {
  @override
  FutureOr<PokemonListState> build() async {
    final favoriteEventStream = await ref.watch(getFavoriteEventStreamProvider.future);
    favoriteEventStream.listen(_updateFavorite);
    return const PokemonListState();
  }

  static const int limit = 20;

  Future<void> fetch() => _fetch();

  Future<void> refresh() => _fetch(isRefresh: true);

  Future<void> _fetch({bool isRefresh = false}) async {
    if (state.isReloading) return;
    await _emitLoadingState();
    final currentStateValue = state.valueOrNull ?? const PokemonListState();
    int offset = isRefresh ? 0 : currentStateValue.offset;
    final list = currentStateValue.list ?? [];
    final result = await ref.read(getPokemonListProvider(offset, limit).future);
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

  Future<void> toggleFavorite(Pokemon item) async {
    final currentStateValue = state.valueOrNull;
    if (currentStateValue == null) return;
    await ref
        .read(toggleFavoritePokemonProvider(item.id).future)
        .then((_) => _updateFavorite(item.id));
  }

  Future<void> _updateFavorite(int id) async {
    final currentStateValue = state.valueOrNull;
    if (currentStateValue == null) return;
    final result = await ref.read(getPokemonProvider(id).future);
    result.onSuccess((resultItem) {
      final list = currentStateValue.list?.toList() ?? [];
      final index = list.indexWhere((item) => item.id == id);
      if (index == -1) return;
      list[index] = resultItem;
      _emit(list: list);
    }).onFailure(_onError);
  }

  void _emit({
    required List<Pokemon> list,
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
