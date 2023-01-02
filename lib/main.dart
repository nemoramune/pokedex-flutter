import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pokedex/i18n/strings.g.dart';

import 'features/pokemon/components/pokemon_list_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  LocaleSettings.useDeviceLocale();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'PokeDex',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          fontFamily: "Noto Sans JP",
        ),
        supportedLocales: LocaleSettings.supportedLocales,
        localizationsDelegates: GlobalMaterialLocalizations.delegates,
        home: Scaffold(
          appBar: AppBar(title: const Text('PokeDex')),
          body: const PokemonListPage(),
        ));
  }
}
