import 'package:material_ui/material_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../erisilebilirlik/erisilebilirlik.dart';
import 'giris_ekrani.dart';
import 'rezervasyonlarim_ekrani.dart';

/// "Profil" sekmesi — kullanıcı bilgileri ve tercihler.
class ProfilEkrani extends StatelessWidget {
  final String ad;
  final String email;

  const ProfilEkrani({super.key, required this.ad, required this.email});

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

  @override
  Widget build(BuildContext context) {
    final erisilebilirlik = ErisilebilirlikKapsam.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF4F8F7),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: ListView(
              padding: const EdgeInsets.only(bottom: 16),
              children: [
                // ── Profil başlığı ──
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF004D40), Color(0xFF00897B)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.white,
                        child: Text(
                          ad.isNotEmpty ? ad[0].toUpperCase() : 'K',
                          style: const TextStyle(
                            fontSize: 34,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF00695C),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        ad,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 21,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        email,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.9),
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.verified,
                                size: 15, color: Colors.white),
                            SizedBox(width: 6),
                            Text(
                              'Engelsiz Yaşam Üyesi',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 11),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // ── Araçlarım ve Kartlarım ──
                _bolumBaslik('Kartlarım'),
                Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Color(0xFFE0F2F1),
                      child: Icon(Icons.credit_card, color: Color(0xFF00695C)),
                    ),
                    title: Text('Engelli Araç Kartı'),
                    subtitle: Text('Doğrulandı'),
                    trailing: Icon(Icons.check_circle, color: Colors.green),
                  ),
                ),

                const SizedBox(height: 14),

                // ── Erişilebilirlik tercihlerim ──
                _bolumBaslik('Erişilebilirlik Tercihlerim'),
                Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      SwitchListTile(
                        secondary: const Icon(Icons.contrast,
                            color: Color(0xFF00695C)),
                        title: const Text('Yüksek kontrast'),
                        subtitle: const Text(
                            'Siyah zemin, sarı vurgu — AAA kontrast'),
                        value: erisilebilirlik.yuksekKontrast,
                        activeThumbColor: const Color(0xFF00695C),
                        onChanged: (_) =>
                            erisilebilirlik.yuksekKontrastDegistir(),
                      ),
                      SwitchListTile(
                        secondary: const Icon(Icons.filter_b_and_w,
                            color: Color(0xFF00695C)),
                        title: const Text('Gri tonlama'),
                        subtitle:
                            const Text('Renk bilgisini kaldır'),
                        value: erisilebilirlik.griTon,
                        activeThumbColor: const Color(0xFF00695C),
                        onChanged: (_) => erisilebilirlik.griTonDegistir(),
                      ),
                      SwitchListTile(
                        secondary: const Icon(Icons.format_underlined,
                            color: Color(0xFF00695C)),
                        title: const Text('Altı çizili bağlantılar'),
                        value: erisilebilirlik.altiCiziliBaglantilar,
                        activeThumbColor: const Color(0xFF00695C),
                        onChanged: (_) =>
                            erisilebilirlik.altiCiziliBaglantilarDegistir(),
                      ),
                      ListTile(
                        leading: const Icon(Icons.text_fields,
                            color: Color(0xFF00695C)),
                        title: const Text('Metin boyutu'),
                        subtitle: Text(
                            'Şu an: %${(erisilebilirlik.fontOlcegi * 100).round()}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              tooltip: 'Yazıyı küçült',
                              icon: const Icon(Icons.text_decrease),
                              onPressed: erisilebilirlik.fontKucult,
                            ),
                            IconButton(
                              tooltip: 'Yazıyı büyüt',
                              icon: const Icon(Icons.text_increase),
                              onPressed: erisilebilirlik.fontBuyut,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 14),

                // ── Diğer ──
                _bolumBaslik('Diğer'),
                Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      ListTile(
                        leading: const CircleAvatar(
                          backgroundColor: Color(0xFFE0F2F1),
                          child: Icon(Icons.event_available,
                              color: Color(0xFF00695C)),
                        ),
                        title: const Text('Rezervasyonlarım'),
                        subtitle: const Text(
                            'Otopark rezervasyonlarınızı görüntüleyin'),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const RezervasyonlarimEkrani(),
                          ),
                        ),
                      ),
                      ListTile(
                        leading: const CircleAvatar(
                          backgroundColor: Color(0xFFE0F2F1),
                          child: Icon(Icons.help_outline,
                              color: Color(0xFF00695C)),
                        ),
                        title: const Text('Yardım & Destek'),
                        subtitle:
                            const Text('Sık sorulan sorular ve iletişim'),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () => ScaffoldMessenger.of(context)
                            .showSnackBar(
                          const SnackBar(
                            behavior: SnackBarBehavior.floating,
                            content: Text('Yardım bölümü çok yakında.'),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // ── Çıkış ──
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: SizedBox(
                    height: 52,
                    child: OutlinedButton.icon(
                      onPressed: () => _cikisYap(context),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red,
                        side: const BorderSide(color: Colors.red, width: 1.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      icon: const Icon(Icons.logout),
                      label: const Text(
                        'Çıkış Yap',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Center(
                  child: Text(
                    'Engelsiz Yaşam • Sürüm 1.0.0',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey.shade800,
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

  static Widget _bolumBaslik(String metin) => Padding(
        padding: const EdgeInsets.fromLTRB(24, 0, 16, 8),
        child: Text(
          metin,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: Color(0xFF004D40),
            letterSpacing: 0.3,
          ),
        ),
      );
}
