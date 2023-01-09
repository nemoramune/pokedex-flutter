import 'package:pokedex/model/pokemon_detail.dart';
import 'package:pokedex/states/pokemon_detail_state.dart';
import 'package:pokedex/usecases/get_pokemon_detail.dart';
import 'package:pokedex/usecases/toggle_favorite_pokemon.dart';
import 'package:pokedex/utils/result.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'pokemon_detail_view_model.g.dart';

@riverpod
class PokemonDetailViewModel extends _$PokemonDetailViewModel {
  @override
  FutureOr<PokemonDetailState> build(int id) async {
    _fetch(id);
    return const PokemonDetailState();
  }

  Future<void> favorite(PokemonDetail item) async {
    final currentStateValue = state.valueOrNull;
    if (currentStateValue == null) return;
    final result = await ref
        .read(toggleFavoritePokemonProvider(item.id).future)
        .then((_) => ref.read(getPokemonDetailProvider(item.id).future));
    result.onSuccess((resultItem) {
      state = AsyncData(currentStateValue.copyWith(data: resultItem)).copyWithPrevious(state);
    }).onFailure(_onError);
  }

  Future<void> _fetch(int id) async {
    await _emitLoadingState();
    final currentStateValue = state.valueOrNull ?? const PokemonDetailState();
    final result = await ref.read(getPokemonDetailProvider(id).future);
    result
        .onSuccess((result) =>
            state = AsyncData(currentStateValue.copyWith(data: result)).copyWithPrevious(state))
        .onFailure(_onError);
  }

  void _onError(Object error, StackTrace stackTrace) {
    state = AsyncError<PokemonDetailState>(error, stackTrace).copyWithPrevious(state);
  }

  Future<void> _emitLoadingState() => Future(() {
        state = const AsyncLoading<PokemonDetailState>().copyWithPrevious(state);
      });
}
