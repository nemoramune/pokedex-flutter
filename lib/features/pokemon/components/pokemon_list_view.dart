import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:pokedex/components/progress_view.dart';
import 'package:pokedex/features/pokemon/components/pokemon_list_item_view.dart';
import 'package:pokedex/features/pokemon/model/pokemon_list_item.dart';
import 'package:pokedex/features/pokemon/pokemon_list_view_model.dart';
import 'package:pokedex/hooks/use_paging_controller.dart';
import 'package:pokedex/hooks/use_strings.dart';

import '../../../components/error_view.dart';

class PokemonListView extends HookConsumerWidget {
  const PokemonListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = useStrings();
    final viewModel = ref.watch(pokemonListViewModelProvider.notifier);
    final state = ref.watch(pokemonListViewModelProvider);
    final pagingController = useStateLessPagingController(
      itemList: state.valueOrNull?.list,
      isLast: state.valueOrNull?.isLoadedToLast,
      loadMore: viewModel.fetch,
      error: state.error,
    );

    return RefreshIndicator(
      onRefresh: () => viewModel.refresh(),
      child: PagedListView.separated(
        pagingController: pagingController,
        separatorBuilder: (context, index) => const Divider(),
        builderDelegate: PagedChildBuilderDelegate<PokemonListItem>(
          itemBuilder: (context, item, index) => PokemonListItemView(
              data: item, onPressedFavorite: (item) => viewModel.favorite(item)),
          firstPageErrorIndicatorBuilder: (_) => ErrorView(
            text: strings.networkError,
            retry: viewModel.refresh,
          ),
          newPageProgressIndicatorBuilder: (_) => const ProgressView(),
          noItemsFoundIndicatorBuilder: (_) => ErrorView(
            text: strings.pokemonListEmptyError,
            retry: viewModel.refresh,
          ),
        ),
      ),
    );
  }
}
