import 'package:material_ui/material_ui.dart';

import 'hizmetlerimiz_ekrani.dart';
import 'menu_ekrani.dart';
import 'profil_ekrani.dart';
import 'rezervasyonlarim_govde.dart';

/// Uygulamanın ana paneli: yüzen hap şeklinde alt gezinme çubuğu.
/// Sekmeler: Ana Menü · Rezervasyonlarım · Hizmetlerimiz · Profil
/// Sağ uçta, şimdilik pasif olan QR düğmesi.
class PanelEkrani extends StatefulWidget {
  final String ad;
  final String email;

  const PanelEkrani({super.key, required this.ad, required this.email});

  @override
  State<PanelEkrani> createState() => _PanelEkraniState();
}

class _PanelEkraniState extends State<PanelEkrani> {
  int _index = 0;

  static const _sekmeler = [
    (ikon: Icons.home_rounded, etiket: 'Ana Menü'),
    (ikon: Icons.event_available, etiket: 'Rezervasyonlarım'),
    (ikon: Icons.grid_view_rounded, etiket: 'Hizmetlerimiz'),
    (ikon: Icons.person_outline, etiket: 'Profil'),
  ];

  late final List<Widget> _sayfalar = [
    MenuEkrani(ad: widget.ad, email: widget.email),
    const Scaffold(
      backgroundColor: Color(0xFFF4F8F7),
      body: SafeArea(bottom: false, child: RezervasyonlarimGovde()),
    ),
    const HizmetlerimizEkrani(),
    ProfilEkrani(ad: widget.ad, email: widget.email),
  ];

  void _qrTeknik(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text('Karekod özelliği çok yakında eklenecek.'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: IndexedStack(
        index: _index,
        children: _sayfalar,
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 0, 12, 10),
          child: Container(
            height: 64,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(32),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.16),
                  blurRadius: 14,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Row(
              children: [
                // 4 sekme
                for (int i = 0; i < _sekmeler.length; i++)
                  Expanded(
                    child: _Sekme(
                      ikon: _sekmeler[i].ikon,
                      etiket: _sekmeler[i].etiket,
                      secili: _index == i,
                      onTap: () => setState(() => _index = i),
                    ),
                  ),
                const SizedBox(width: 2),
                // QR düğmesi (şimdilik pasif)
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Semantics(
                    button: true,
                    label: 'Karekod tara, yakında',
                    child: InkWell(
                      onTap: () => _qrTeknik(context),
                      customBorder: const CircleBorder(),
                      child: Container(
                        width: 48,
                        height: 48,
                        decoration: const BoxDecoration(
                          color: Color(0xFF00897B),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.qr_code,
                          color: Colors.white,
                          size: 26,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Sekme extends StatelessWidget {
  final IconData ikon;
  final String etiket;
  final bool secili;
  final VoidCallback onTap;

  const _Sekme({
    required this.ikon,
    required this.etiket,
    required this.secili,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const birincil = Color(0xFF00695C);
    final soluk = Colors.grey.shade700;

    return InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeOut,
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: secili ? birincil : Colors.transparent,
                shape: BoxShape.circle,
              ),
              child: Icon(
                ikon,
                size: 20,
                color: secili ? Colors.white : soluk,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              etiket,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 9.5,
                height: 1.1,
                fontWeight: secili ? FontWeight.bold : FontWeight.w500,
                color: secili ? birincil : soluk,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
