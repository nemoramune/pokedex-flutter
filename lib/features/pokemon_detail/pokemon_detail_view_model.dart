import 'package:pokedex/model/pokemon_detail.dart';
import 'package:pokedex/providers/pokemon_repository_provider.dart';
import 'package:pokedex/repositories/pokemon_repository.dart';
import 'package:pokedex/states/pokemon_detail_state.dart';
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

  Future<PokemonRepository> get _pokemonRepositoryFuture =>
      ref.read(pokemonRepositoryProvider.future);

  Future<void> favorite(PokemonDetail item) async {
    final currentStateValue = state.valueOrNull;
    if (currentStateValue == null) return;
    // TODO refactor by use case if needed
    final repository = await _pokemonRepositoryFuture;
    final favoriteRequest =
        item.isFavorite ? repository.unfavoritePokemon : repository.favoritePokemon;
    final result = await favoriteRequest(item.id).then((_) => repository.getPokemonDetail(item.id));
    result.onSuccess((resultItem) {
      state = AsyncData(currentStateValue.copyWith(data: resultItem)).copyWithPrevious(state);
    }).onFailure(_onError);
  }

  Future<void> _fetch(int id) async {
    await _emitLoadingState();
    final currentStateValue = state.valueOrNull ?? const PokemonDetailState();
    final repository = await _pokemonRepositoryFuture;
    final result = await repository.getPokemonDetail(id);
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
