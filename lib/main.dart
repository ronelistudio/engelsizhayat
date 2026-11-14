import 'package:material_ui/material_ui.dart';
import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:flutter_localizations/flutter_localizations.dart'
    show GlobalWidgetsLocalizations;

import 'ekranlar/giris_ekrani.dart';
import 'erisilebilirlik/erisilebilirlik.dart';
import 'erisilebilirlik/erisilebilirlik_araci.dart';
import 'tema.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const EngelsizYasamApp());
}

class EngelsizYasamApp extends StatefulWidget {
  const EngelsizYasamApp({super.key});

  @override
  State<EngelsizYasamApp> createState() => _EngelsizYasamAppState();
}

class _EngelsizYasamAppState extends State<EngelsizYasamApp> {
  final ErisilebilirlikAyarlari _ayar = ErisilebilirlikAyarlari();

  @override
  void initState() {
    super.initState();
    _ayar.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _ayar.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tema = _ayar.yuksekKontrast
        ? yuksekKontrastTema(altiCiziliBaglantilar: _ayar.altiCiziliBaglantilar)
        : acikTema(altiCiziliBaglantilar: _ayar.altiCiziliBaglantilar);

    return ErisilebilirlikKapsam(
      ayarlar: _ayar,
      child: MaterialApp(
        title: 'Engelsiz Yaşam',
        debugShowCheckedModeBanner: false,
        locale: const Locale('tr'),
        supportedLocales: const [Locale('tr'), Locale('en')],
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        theme: tema,
        // Erişilebilirlik katmanı: yazı ölçeği + gri tonlama + araç çubuğu
        builder: (context, child) {
          final mq = MediaQuery.of(context);
          Widget sayfa = MediaQuery(
            data: mq.copyWith(
              textScaler: TextScaler.linear(_ayar.fontOlcegi),
            ),
            child: child ?? const SizedBox(),
          );
          if (_ayar.griTon) {
            sayfa = ColorFiltered(
              colorFilter: const ColorFilter.matrix(griTonMatrisi),
              child: sayfa,
            );
          }
          return Stack(
            children: [
              sayfa,
              const ErisilebilirlikAraci(),
            ],
          );
        },
        home: const GirisEkrani(),
      ),
    );
  }
}
