import 'package:hive/hive.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'pokemon_favorite_box_provider.g.dart';

@riverpod
Future<Box<bool>> pokemonFavoriteBox(_) async => await Hive.openBox<bool>('pokemonFavoriteBox');
