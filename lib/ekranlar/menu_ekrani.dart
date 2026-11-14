import 'package:material_ui/material_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'giris_ekrani.dart';
import 'otopark_ekrani.dart';
import 'rezervasyonlarim_ekrani.dart';

/// Uygulamanın ana menüsü.
/// Şimdilik yalnızca Otopark bölümü aktiftir; diğer bölümler "Yakında".
class MenuEkrani extends StatelessWidget {
  final String ad;
  final String email;

  const MenuEkrani({super.key, required this.ad, required this.email});

  Future<void> _cikisYap(BuildContext context) async {
    final onay = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Çıkış Yap'),
        content: const Text('Hesabınızdan çıkmak istediğinize emin misiniz?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Vazgeç'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text(
              'Çıkış Yap',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
    if (onay != true || !context.mounted) return;

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('giris_yapildi');
    await prefs.remove('kullanici_ad');
    await prefs.remove('kullanici_email');

    if (!context.mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const GirisEkrani()),
      (rota) => false,
    );
  }

  String _selamlama() {
    final s = DateTime.now().hour;
    if (s < 6) return 'İyi geceler';
    if (s < 12) return 'Günaydın';
    if (s < 18) return 'İyi günler';
    return 'İyi akşamlar';
  }

  String _bugun() {
    const aylar = [
      'Ocak', 'Şubat', 'Mart', 'Nisan', 'Mayıs', 'Haziran',
      'Temmuz', 'Ağustos', 'Eylül', 'Ekim', 'Kasım', 'Aralık'
    ];
    const gunler = [
      'Pazartesi', 'Salı', 'Çarşamba', 'Perşembe', 'Cuma', 'Cumartesi', 'Pazar'
    ];
    final simdi = DateTime.now();
    return '${simdi.day} ${aylar[simdi.month - 1]} ${simdi.year}, '
        '${gunler[simdi.weekday - 1]}';
  }

  @override
  Widget build(BuildContext context) {
    final bolumler = [
      const _BolumKarti(
        ikon: Icons.local_parking,
        baslik: 'Otopark',
        aciklama: 'Engelli park yerlerini bulun, rezervasyon yapın',
        renk: Color(0xFF00695C),
        aktif: true,
      ),
      const _BolumKarti(
        ikon: Icons.local_hospital_outlined,
        baslik: 'Sağlık',
        aciklama: 'Erişilebilir hastane ve klinikleri bulun',
        renk: Color(0xFF1565C0),
        aktif: false,
      ),
      const _BolumKarti(
        ikon: Icons.directions_bus_outlined,
        baslik: 'Ulaşım',
        aciklama: 'Engelsiz toplu ulaşım rotalarını keşfedin',
        renk: Color(0xFFE65100),
        aktif: false,
      ),
      const _BolumKarti(
        ikon: Icons.theater_comedy_outlined,
        baslik: 'Kültür & Etkinlik',
        aciklama: 'Erişilebilir etkinlik ve mekânları görün',
        renk: Color(0xFF6A1B9A),
        aktif: false,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.accessible, size: 26),
            SizedBox(width: 8),
            Text(
              'Engelsiz Yaşam',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF00695C),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            tooltip: 'Rezervasyonlarım',
            icon: const Icon(Icons.event_available),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => const RezervasyonlarimEkrani(),
              ),
            ),
          ),
          IconButton(
            tooltip: 'Çıkış Yap',
            icon: const Icon(Icons.logout),
            onPressed: () => _cikisYap(context),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Karşılama bandı
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF00695C), Color(0xFF26A69A)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF00695C).withValues(alpha: 0.35),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white,
                  child: Text(
                    ad.isNotEmpty ? ad[0].toUpperCase() : 'E',
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF00695C),
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${_selamlama()},',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.9),
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        ad,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _bugun(),
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.75),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Bölümler',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),

          // Bölüm kartları
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 0.92,
            children: [
              for (final bolum in bolumler)
                _BolumKartWidget(
                  kart: bolum,
                  onTik: () {
                    if (bolum.aktif) {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const OtoparkEkrani(),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          behavior: SnackBarBehavior.floating,
                          content: Text(
                            '${bolum.baslik} bölümü çok yakında eklenecek.',
                          ),
                        ),
                      );
                    }
                  },
                ),
            ],
          ),
          const SizedBox(height: 12),

          // Rezervasyonlarım kısayolu
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: Colors.teal.shade100),
            ),
            child: ListTile(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              leading: const CircleAvatar(
                backgroundColor: Color(0xFFE0F2F1),
                child: Icon(Icons.event_available, color: Color(0xFF00695C)),
              ),
              title: const Text(
                'Rezervasyonlarım',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: const Text('Otopark rezervasyonlarınızı görüntüleyin'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const RezervasyonlarimEkrani(),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Engelsiz Yaşam — Herkes için erişilebilir bir yaşam',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }
}

class _BolumKarti {
  final IconData ikon;
  final String baslik;
  final String aciklama;
  final Color renk;
  final bool aktif;

  const _BolumKarti({
    required this.ikon,
    required this.baslik,
    required this.aciklama,
    required this.renk,
    required this.aktif,
  });
}

class _BolumKartWidget extends StatelessWidget {
  final _BolumKarti kart;
  final VoidCallback onTik;

  const _BolumKartWidget({required this.kart, required this.onTik});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: kart.aktif ? 3 : 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: kart.aktif ? Colors.transparent : Colors.grey.shade300,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTik,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    radius: 26,
                    backgroundColor: kart.renk.withValues(alpha: 0.12),
                    child: Icon(kart.ikon, size: 28, color: kart.renk),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    kart.baslik,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    kart.aciklama,
                    style: TextStyle(fontSize: 11.5, color: Colors.grey.shade600),
                  ),
                ],
              ),
              if (!kart.aktif)
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
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
                ),
            ],
          ),
        ),
      ),
    );
  }
}
