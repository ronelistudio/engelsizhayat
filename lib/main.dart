import 'package:material_ui/material_ui.dart';
import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:flutter_localizations/flutter_localizations.dart'
    show GlobalWidgetsLocalizations;

import 'ekranlar/giris_ekrani.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const EngelsizYasamApp());
}

class EngelsizYasamApp extends StatelessWidget {
  const EngelsizYasamApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Engelsiz Yaşam',
      debugShowCheckedModeBanner: false,
      locale: const Locale('tr'),
      supportedLocales: const [Locale('tr'), Locale('en')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF00695C),
        ),
        scaffoldBackgroundColor: const Color(0xFFF4F8F7),
        appBarTheme: const AppBarTheme(
          centerTitle: false,
        ),
      ),
      home: const GirisEkrani(),
    );
  }
}
