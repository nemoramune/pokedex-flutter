import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pokedex/components/error_view.dart';
import 'package:pokedex/components/favorite_button.dart';
import 'package:pokedex/components/pokemon/pokemon_type_chips.dart';
import 'package:pokedex/components/progress_view.dart';
import 'package:pokedex/hooks/use_strings.dart';

import 'pokemon_detail_view_model.dart';

class PokemonDetailPage extends StatelessWidget {
  const PokemonDetailPage({required this.id, super.key});

  final int id;

  @override
  Widget build(BuildContext context) =>
      Scaffold(appBar: AppBar(), body: _PokemonDetailView(id: id));
}

class _PokemonDetailView extends HookConsumerWidget {
  const _PokemonDetailView({required this.id});

  final int id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = useStrings();
    final viewModel = ref.watch(pokemonDetailViewModelProvider(id).notifier);
    final state = ref.watch(pokemonDetailViewModelProvider(id));
    final data = state.valueOrNull?.data;
    final error = state.error;
    if (error != null) return ErrorView(text: strings.networkError);
    if (data == null) return const ProgressView();
    return Column(
      children: [
        const Gap(8),
        Center(
          child: Container(
            width: 256,
            height: 256,
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: CachedNetworkImage(
              imageUrl: data.imageUrl,
              width: 240,
              height: 240,
              fit: BoxFit.fitHeight,
              placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
              errorWidget: (context, url, error) =>
                  const Center(child: Icon(Icons.error_outline, size: 64, color: Colors.red)),
            ),
          ),
        ),
        const Gap(8),
        IntrinsicHeight(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                data.name,
                style: Theme.of(context).textTheme.headline2?.copyWith(color: Colors.black),
              ),
              FavoriteButton(
                isFavorite: data.isFavorite,
                onPressedFavorite: () {
                  viewModel.toggleFavorite(data);
                },
              )
            ],
          ),
        ),
        const Gap(8),
        PokemonTypeChips(types: data.types),
        const Gap(8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(strings.height(height: data.height),
                style: Theme.of(context).textTheme.bodyText1?.copyWith(color: Colors.black)),
            Text(strings.weight(weight: data.weight),
                style: Theme.of(context).textTheme.bodyText1?.copyWith(color: Colors.black)),
          ],
        ),
        const Gap(8),
        Text(data.flavorText,
            style: Theme.of(context).textTheme.bodyText1?.copyWith(color: Colors.black)),
      ],
    );
  }
}
