import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pokedex/components/scaffold_with_nav_bar.dart';
import 'package:pokedex/entity/pokemon_entity.dart';
import 'package:pokedex/hooks/use_strings.dart';
import 'package:pokedex/i18n/strings.g.dart';
import 'package:pokedex/routes/routes.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(PokemonEntityAdapter());
  WidgetsFlutterBinding.ensureInitialized();
  LocaleSettings.useDeviceLocale();
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final _router = GoRouter(routes: [
    ShellRoute(
      routes: $appRoutes,
      builder: (context, state, child) => ScaffoldWithNavBar(child: child),
    ),
  ]);

  @override
  Widget build(BuildContext context) {
    final strings = useStrings();
    return MaterialApp.router(
      title: strings.appName,
      theme: ThemeData(
        useMaterial3: true,
        primarySwatch: Colors.blue,
        fontFamily: "Noto Sans JP",
      ),
      supportedLocales: LocaleSettings.supportedLocales,
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      routeInformationParser: _router.routeInformationParser,
      routerDelegate: _router.routerDelegate,
      routeInformationProvider: _router.routeInformationProvider,
    );
  }
}
