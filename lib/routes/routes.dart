import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:pokedex/features/pokemon_detail/pokemon_detail_page.dart';
import 'package:pokedex/features/pokemon_favorites/pokemon_favorites_page.dart';
import 'package:pokedex/features/pokemon_list/pokemon_list_page.dart';

part 'routes.g.dart';

@TypedGoRoute<PokemonListRoute>(
  path: '/',
  routes: [TypedGoRoute<PokemonListDetailRoute>(path: 'pokemon/:id')],
)
class PokemonListRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const PokemonListPage();
  }
}

class PokemonListDetailRoute extends GoRouteData {
  PokemonListDetailRoute({required this.id});
  final int id;
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return PokemonDetailPage(id: id);
  }
}

@TypedGoRoute<PokemonFavoritesRoute>(
  path: '/favorites',
  routes: [TypedGoRoute<PokemonFavoritesDetailRoute>(path: ':id')],
)
class PokemonFavoritesRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const PokemonFavoritesPage();
  }
}

class PokemonFavoritesDetailRoute extends GoRouteData {
  PokemonFavoritesDetailRoute({required this.id});
  final int id;
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return PokemonDetailPage(id: id);
  }
}
