import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'features/pokemon/components/pokemon_list_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized(); // add this
  // LocaleSettings.useDeviceLocale(); // and this
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
        ),
        home: Scaffold(
          appBar: AppBar(title: const Text('PokeDex')),
          body: const PokemonListPage(),
        ));
  }
}
