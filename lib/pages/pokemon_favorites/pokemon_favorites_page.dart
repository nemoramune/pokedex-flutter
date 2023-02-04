import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pokedex/components/pokemon/pokemon_list_view.dart';
import 'package:pokedex/hooks/use_strings.dart';
import 'package:pokedex/pages/pokemon_detail/pokemon_detail_provider.dart';
import 'package:pokedex/routes/routes.dart';

class PokemonFavoritesPage extends HookConsumerWidget {
  const PokemonFavoritesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = useStrings();
    final list = ref.watch(pokemonFavoritesProvider);
    final isLast = ref.watch(isPokemonFavoritesLastProvider);
    loadMore() => WidgetsBinding.instance
        .addPostFrameCallback(((_) => ref.read(loadFavoritesNextPageProvider)()));
    return Scaffold(
      appBar: AppBar(title: Text(strings.favorite)),
      body: PokemonListView(
        list: list.valueOrNull,
        isLast: isLast,
        error: list.error,
        loadMore: loadMore,
        onTapListItem: (item) => PokemonFavoritesDetailRoute(id: item.id).go(context),
        onPressedFavorite: (item) => ref.read(toggleFavoritePokemonProvider(item.id)),
        refresh: () => ref.refresh(pokemonFavoritesProvider),
        emptyErrorMessage: strings.favoriteListEmptyError,
        enableRetryButton: false,
      ),
    );
  }
}
