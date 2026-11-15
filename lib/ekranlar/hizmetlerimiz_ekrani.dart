import 'package:material_ui/material_ui.dart';

import 'otopark_ekrani.dart';

/// "Hizmetlerimiz" sekmesi — erişilebilir hizmetler listesi.
class HizmetlerimizEkrani extends StatelessWidget {
  const HizmetlerimizEkrani({super.key});

  static const _hizmetler = [
    _Hizmet(
      ikon: Icons.local_parking,
      baslik: 'Otopark',
      aciklama: 'Engelli park yerlerini bulun, rezervasyon yapın',
      renk: Color(0xFF00695C),
      aktif: true,
    ),
    _Hizmet(
      ikon: Icons.local_hospital_outlined,
      baslik: 'Sağlık',
      aciklama: 'Erişilebilir hastane ve klinikleri bulun',
      renk: Color(0xFF1565C0),
      aktif: false,
    ),
    _Hizmet(
      ikon: Icons.directions_bus_outlined,
      baslik: 'Ulaşım',
      aciklama: 'Engelsiz toplu ulaşım rotalarını keşfedin',
      renk: Color(0xFFE65100),
      aktif: false,
    ),
    _Hizmet(
      ikon: Icons.theater_comedy_outlined,
      baslik: 'Kültür & Etkinlik',
      aciklama: 'Erişilebilir etkinlik ve mekânları görün',
      renk: Color(0xFF6A1B9A),
      aktif: false,
    ),
    _Hizmet(
      ikon: Icons.credit_card,
      baslik: 'Engelli Araç Kartı',
      aciklama: 'Aracınızı kaydedin, park hakkınızı yönetin',
      renk: Color(0xFF00695C),
      aktif: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F8F7),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 860),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
              children: [
                const Text(
                  'Hizmetlerimiz',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF004D40),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Size en uygun erişilebilir hizmetler',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade800,
                  ),
                ),
                const SizedBox(height: 16),
                for (final hizmet in _hizmetler)
                  _HizmetKarti(hizmet: hizmet),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Hizmet {
  final IconData ikon;
  final String baslik;
  final String aciklama;
  final Color renk;
  final bool aktif;

  const _Hizmet({
    required this.ikon,
    required this.baslik,
    required this.aciklama,
    required this.renk,
    required this.aktif,
  });
}

class _HizmetKarti extends StatelessWidget {
  final _Hizmet hizmet;
  const _HizmetKarti({required this.hizmet});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: hizmet.aktif ? 2 : 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(
          color: hizmet.aktif ? Colors.transparent : Colors.grey.shade300,
        ),
      ),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        leading: Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            color: hizmet.renk.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(hizmet.ikon, color: hizmet.renk, size: 28),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                hizmet.baslik,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
            if (!hizmet.aktif)
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.amber.shade100,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  'YAKINDA',
                  style: TextStyle(
                    fontSize: 9.5,
                    fontWeight: FontWeight.bold,
                    color: Colors.amber.shade900,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
          ],
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 2),
          child: Text(
            hizmet.aciklama,
            style: TextStyle(fontSize: 12, color: Colors.grey.shade800),
          ),
        ),
        trailing: const Icon(Icons.chevron_right, color: Colors.grey),
        onTap: () {
          if (hizmet.aktif) {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const OtoparkEkrani()),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                behavior: SnackBarBehavior.floating,
                content: Text(
                  '${hizmet.baslik} çok yakında eklenecek.',
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
