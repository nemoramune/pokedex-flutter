import 'package:flutter/cupertino.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pokedex/features/pokemon/pokemon_list_view_model.dart';

class PokemonListView extends HookConsumerWidget {
  const PokemonListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(pokemonListViewModelProvider);
    final viewModel = ref.watch(pokemonListViewModelProvider.notifier);
    useEffect(() {
      viewModel.fetch();
    });
    final list = state.valueOrNull?.list?.results;
    return ListView.builder(
        itemCount: list?.length ?? 0,
        itemBuilder: ((context, index) {
          final name = list?[index].name;
          return Text(name ?? "");
        }));
  }
}
