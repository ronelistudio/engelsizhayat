import 'package:material_ui/material_ui.dart';

import 'rezervasyonlarim_govde.dart';

/// Kullanıcının tüm otopark rezervasyonlarını listeler (tam ekran hali).
class RezervasyonlarimEkrani extends StatelessWidget {
  const RezervasyonlarimEkrani({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rezervasyonlarım'),
        backgroundColor: const Color(0xFF00695C),
        foregroundColor: Colors.white,
      ),
      body: const RezervasyonlarimGovde(),
    );
  }
}
