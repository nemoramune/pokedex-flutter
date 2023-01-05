import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:pokedex/features/pokemon/components/pokemon_detail_page.dart';
import 'package:pokedex/features/pokemon/components/pokemon_list_page.dart';

part 'routes.g.dart';

@TypedGoRoute<PokemonListRoute>(
  path: '/',
  routes: <TypedGoRoute<GoRouteData>>[
    TypedGoRoute<PokemonDetailRoute>(
      path: ':id',
    )
  ],
)
class PokemonListRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const PokemonListPage();
  }
}

class PokemonDetailRoute extends GoRouteData {
  PokemonDetailRoute({required this.id});
  final int id;
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return PokemonDetailPage(id: id);
  }
}
