import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:pokedex/features/pokemon/model/pokemon_type.dart';

class PokemonTypeChips extends StatelessWidget {
  const PokemonTypeChips({required this.types, super.key});

  final List<PokemonType> types;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: types.fold(
        <Widget>[],
        (list, type) {
          final chipColor = Color(type.color);
          final textColor = chipColor.computeLuminance() > 0.5 ? Colors.black87 : Colors.white;
          final chip = Chip(
            label: Text(
              type.nameJp,
              style: TextStyle(color: textColor),
            ),
            backgroundColor: chipColor,
          );
          if (list.isNotEmpty) list.add(const Gap(8));
          list.add(chip);
          return list;
        },
      ),
    );
  }
}
