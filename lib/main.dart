import 'package:boletim_campoverde/boletim.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // initializeDateFormatting('pt-BR');
    return ChangeNotifierProvider<ValoresBoletim>(
      create: (_) => ValoresBoletim(),
      child: MaterialApp(
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('pt', 'BR')],
        theme: ThemeData(
          useMaterial3: true,
          fontFamily: 'Nexa',
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 70, 165, 30),
          ),
        ),
        home: const HomePage(),
      ),
    );
  }
}
