import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:pokedex/features/pokemon/model/pokemon_list_item.dart';
import 'package:pokedex/features/pokemon/pokemon_list_view_model.dart';

class PokemonListItemView extends HookConsumerWidget {
  const PokemonListItemView({
    required this.data,
    super.key,
  });

  final PokemonListItem data;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 640),
        child: IntrinsicHeight(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Gap(8),
              Image.network(
                data.imageUrl,
                width: 128,
                height: 128,
                fit: BoxFit.fitHeight,
              ),
              const Gap(4),
              Expanded(
                flex: 2,
                child: _PokemonListItemInfo(data: data),
              ),
              const Icon(
                Icons.favorite,
                color: Colors.red,
                size: 32,
                semanticLabel: 'Remove from saved',
              ),
              const Gap(32)
            ],
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
        Row(
          children: data.types.map(
            (type) {
              final chipColor = Color(type.color);
              final textColor = chipColor.computeLuminance() > 0.5 ? Colors.black87 : Colors.white;
              return Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Chip(
                  label: Text(
                    type.nameJp,
                    style: TextStyle(color: textColor),
                  ),
                  backgroundColor: chipColor,
                ),
              );
            },
          ).toList(),
        ),
      ],
    );
  }
}
