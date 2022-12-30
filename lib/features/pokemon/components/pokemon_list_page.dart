import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:pokedex/components/progress_view.dart';

import 'package:pokedex/features/pokemon/model/pokemon_list_item.dart';
import 'package:pokedex/features/pokemon/pokemon_list_view_model.dart';
import 'package:pokedex/hooks/use_paging_controller.dart';

class PokemonListPage extends HookConsumerWidget {
  const PokemonListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
          itemBuilder: (context, item, index) => ListTile(
            title: Text(item.name),
            subtitle: Text(item.url),
          ),
          newPageProgressIndicatorBuilder: (_) => const ProgressView(),
          noItemsFoundIndicatorBuilder: (_) => const ProgressView(),
        ),
      ),
    );
  }
}
