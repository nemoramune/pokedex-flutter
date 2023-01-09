import 'package:collection/collection.dart';
import 'package:pokedex/model/pokemon_list_item.dart';
import 'package:pokedex/states/pokemon_list_state.dart';
import 'package:pokedex/usecases/get_favorite_event_stream.dart';
import 'package:pokedex/usecases/get_favorite_pokemon_list.dart';
import 'package:pokedex/usecases/get_pokemon_list_item.dart';
import 'package:pokedex/usecases/toggle_favorite_pokemon.dart';
import 'package:pokedex/utils/result.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'pokemon_favorites_view_model.g.dart';

@riverpod
class PokemonFavoritesViewModel extends _$PokemonFavoritesViewModel {
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
    final list = currentStateValue.list;
    final result = await ref.read(getFavoritePokemonListProvider(offset, limit).future);
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

  Future<void> toggleFavorite(PokemonListItem item) async {
    final currentStateValue = state.valueOrNull;
    if (currentStateValue == null) return;
    await ref
        .read(toggleFavoritePokemonProvider(item.id).future)
        .then((_) => _updateFavorite(item.id));
  }

  Future<void> _updateFavorite(int id) async {
    final currentStateValue = state.valueOrNull;
    if (currentStateValue == null) return;
    final result = await ref.read(getPokemonListItemProvider(id).future);
    result.onSuccess((resultItem) {
      final list = currentStateValue.list.toList();
      if (resultItem.isFavorite) {
        list.add(resultItem);
      } else {
        list.removeWhere((item) => item.id == id);
      }
      _emit(list: list.sorted((lhs, rhs) => lhs.id.compareTo(rhs.id)));
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
