import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pokedex/features/pokemon/components/pokemon_list_view.dart';
import 'package:pokedex/hooks/use_strings.dart';

class PokemonListPage extends HookConsumerWidget {
  const PokemonListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = useStrings();
    return Scaffold(
      appBar: AppBar(title: Text(strings.appName)),
      body: const PokemonListView(),
    );
  }
}
