import 'package:flutter/material.dart';

class FavoriteButton extends StatelessWidget {
  const FavoriteButton({
    required this.isFavorite,
    required this.onPressedFavorite,
    super.key,
  });

  final bool isFavorite;
  final void Function() onPressedFavorite;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      iconSize: 32,
      color: isFavorite ? Colors.red : Colors.grey,
      isSelected: isFavorite,
      icon: const Icon(Icons.favorite_border),
      selectedIcon: const Icon(Icons.favorite),
      onPressed: () => onPressedFavorite(),
    );
  }
}
