import 'package:hive/hive.dart';
import 'package:pokedex/entity/pokemon_entity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'pokemon_entity_box_provider.g.dart';

@riverpod
Future<Box<PokemonEntity>> pokemonEntityBox(_) async =>
    await Hive.openBox<PokemonEntity>('pokemonEntityBox');
