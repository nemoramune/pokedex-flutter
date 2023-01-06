import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:pokedex/components/favorite_button.dart';
import 'package:pokedex/features/pokemon/components/pokemon_type_chips.dart';
import 'package:pokedex/features/pokemon/model/pokemon_list_item.dart';
import 'package:pokedex/routes/routes.dart';

class PokemonListItemView extends StatelessWidget {
  const PokemonListItemView({
    required this.data,
    required this.onPressedFavorite,
    super.key,
  });

  final PokemonListItem data;
  final void Function(PokemonListItem item) onPressedFavorite;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        PokemonDetailRoute(id: data.id).go(context);
      },
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 640),
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
                Container(
                  constraints: const BoxConstraints(maxWidth: 220),
                  child: _PokemonListItemInfo(data: data),
                ),
                Center(
                  child: FavoriteButton(
                    isFavorite: data.isFavorite,
                    onPressedFavorite: () {
                      onPressedFavorite(data);
                    },
                  ),
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

  final PokemonListItem data;

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
