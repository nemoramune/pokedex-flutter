import 'package:pokedex/model/pokemon_detail.dart';
import 'package:pokedex/states/pokemon_detail_state.dart';
import 'package:pokedex/usecases/get_pokemon_detail.dart';
import 'package:pokedex/usecases/get_pokemon_detail_with_favorite_toggled.dart';
import 'package:pokedex/utils/result.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'pokemon_detail_view_model.g.dart';

@riverpod
class PokemonDetailViewModel extends _$PokemonDetailViewModel {
  @override
  FutureOr<PokemonDetailState> build(int id) async {
    final result = await ref.read(getPokemonDetailProvider(id).future);
    final data = result.getOrThrow;
    return PokemonDetailState(data: data);
  }

  Future<void> toggleFavorite(PokemonDetail item) async {
    final result = await ref.read(getPokemonDetailWithFavoriteToggledProvider(item.id).future);
    result.onSuccess(_onSuccess).onFailure(_onFailure);
  }

  void _onSuccess(PokemonDetail data) {
    final previousStateValue = state.valueOrNull ?? const PokemonDetailState();
    final stateValue = previousStateValue.copyWith(data: data);
    state = AsyncValue.data(stateValue).copyWithPrevious(state);
  }

  void _onFailure(Object error, StackTrace stackTrace) {
    state = AsyncValue<PokemonDetailState>.error(error, stackTrace).copyWithPrevious(state);
  }
}
