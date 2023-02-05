import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pokedex/components/pokemon/pokemon_list_view.dart';
import 'package:pokedex/dataflow/favorite.dart';
import 'package:pokedex/dataflow/pokemon_list.dart';
import 'package:pokedex/hooks/use_strings.dart';
import 'package:pokedex/routes/routes.dart';

class PokemonListPage extends HookConsumerWidget {
  const PokemonListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = useStrings();
    final list = ref.watch(pokemonListProvider);
    final isLast = ref.watch(isPokemonListLastProvider);
    loadMore() =>
        WidgetsBinding.instance.addPostFrameCallback(((_) => ref.read(loadListNextPageProvider)()));
    return Scaffold(
      appBar: AppBar(title: Text(strings.appName)),
      body: PokemonListView(
        list: list.valueOrNull,
        isLast: isLast,
        error: list.error,
        loadMore: loadMore,
        onTapListItem: (item) => PokemonListDetailRoute(id: item.id).go(context),
        onPressedFavorite: (item) => ref.read(toggleFavoritePokemonProvider(item.id)),
        refresh: () => ref.refresh(pokemonListProvider),
        emptyErrorMessage: strings.pokemonListEmptyError,
      ),
    );
  }
}
