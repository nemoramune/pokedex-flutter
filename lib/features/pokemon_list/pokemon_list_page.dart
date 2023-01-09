import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pokedex/components/pokemon/pokemon_list_view.dart';
import 'package:pokedex/hooks/use_strings.dart';
import 'package:pokedex/routes/routes.dart';

import 'pokemon_list_view_model.dart';

class PokemonListPage extends HookConsumerWidget {
  const PokemonListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = useStrings();
    final viewModel = ref.watch(pokemonListViewModelProvider.notifier);
    final state = ref.watch(pokemonListViewModelProvider);
    return Scaffold(
      appBar: AppBar(title: Text(strings.appName)),
      body: PokemonListView(
        list: state.valueOrNull?.list,
        isLast: state.valueOrNull?.isLoadedToLast,
        error: state.error,
        loadMore: viewModel.fetch,
        onTapListItem: (item) => PokemonListDetailRoute(id: item.id).go(context),
        onPressedFavorite: viewModel.toggleFavorite,
        refresh: viewModel.refresh,
        emptyErrorMessage: strings.pokemonListEmptyError,
      ),
    );
  }
}
