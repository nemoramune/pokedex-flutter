import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:pokedex/components/favorite_button.dart';
import 'package:pokedex/model/pokemon.dart';

import 'pokemon_type_chips.dart';

class PokemonListItemView extends StatelessWidget {
  const PokemonListItemView({
    required this.data,
    required this.onTapListItem,
    required this.onPressedFavorite,
    super.key,
  });

  final Pokemon data;
  final void Function(Pokemon item) onTapListItem;
  final void Function(Pokemon item) onPressedFavorite;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        onTapListItem(data);
      },
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 400),
          child: IntrinsicHeight(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Gap(4),
                CachedNetworkImage(
                  imageUrl: data.imageUrl,
                  width: 128,
                  height: 128,
                  fit: BoxFit.fitHeight,
                  placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) =>
                      const Center(child: Icon(Icons.error_outline, size: 64, color: Colors.red)),
                ),
                Expanded(
                  flex: 1,
                  child: _PokemonListItemInfo(data: data),
                ),
                FavoriteButton(
                  isFavorite: data.isFavorite,
                  onPressedFavorite: () {
                    onPressedFavorite(data);
                  },
                ),
                const Gap(4),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PokemonListItemInfo extends StatelessWidget {
  const _PokemonListItemInfo({required this.data});

  final Pokemon data;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          data.name,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        PokemonTypeChips(types: data.types),
      ],
    );
  }
}
