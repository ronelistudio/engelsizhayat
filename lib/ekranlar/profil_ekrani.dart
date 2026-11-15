import 'package:material_ui/material_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'giris_ekrani.dart';
import 'rezervasyonlarim_ekrani.dart';

/// "Profil" sekmesi — kullanıcı bilgileri.
/// Ad soyad ve telefon düzenlenebilir; kaydedilince uygulamaya yansır.
class ProfilEkrani extends StatefulWidget {
  final String ad;
  final String email;
  final ValueChanged<String> onGuncelle;

  const ProfilEkrani({
    super.key,
    required this.ad,
    required this.email,
    required this.onGuncelle,
  });

  @override
  State<ProfilEkrani> createState() => _ProfilEkraniState();
}

class _ProfilEkraniState extends State<ProfilEkrani> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _adController;
  late final TextEditingController _telefonController;
  bool _kaydediliyor = false;

  @override
  void initState() {
    super.initState();
    _adController = TextEditingController(text: widget.ad);
    _telefonController = TextEditingController();
    _telefonYukle();
  }

  Future<void> _telefonYukle() async {
    final prefs = await SharedPreferences.getInstance();
    _telefonController.text = prefs.getString('kullanici_telefon') ?? '';
  }

  @override
  void dispose() {
    _adController.dispose();
    _telefonController.dispose();
    super.dispose();
  }

  Future<void> _kaydet() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _kaydediliyor = true);
    final yeniAd = _adController.text.trim();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('kullanici_ad', yeniAd);
    await prefs.setString('kullanici_telefon', _telefonController.text.trim());
    if (!mounted) return;
    setState(() => _kaydediliyor = false);

    widget.onGuncelle(yeniAd); // Ana Menü karşılama vb. yerlere yansır
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text('Profiliniz güncellendi.'),
      ),
    );
  }

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
    final ad = widget.ad;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F8F7),
      body: SafeArea(
        bottom: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: ListView(
              padding: const EdgeInsets.only(bottom: 96),
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
                        radius: 42,
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
                        widget.email,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.9),
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // ── Profil bilgilerim ──
                _bolumBaslik('Profil Bilgilerim'),
                Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _adController,
                            textCapitalization:
                                TextCapitalization.words,
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                              labelText: 'Ad Soyad',
                              prefixIcon: const Icon(Icons.person_outline),
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(14),
                              ),
                            ),
                            validator: (v) {
                              if (v == null || v.trim().length < 3) {
                                return 'Adınızı soyadınızı yazın';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: _telefonController,
                            keyboardType: TextInputType.phone,
                            textInputAction: TextInputAction.done,
                            onFieldSubmitted: (_) => _kaydet(),
                            decoration: InputDecoration(
                              labelText: 'Telefon',
                              hintText: '05xx xxx xx xx',
                              prefixIcon: const Icon(Icons.phone_outlined),
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(14),
                              ),
                            ),
                            validator: (v) {
                              final rakamlar = (v ?? '')
                                  .replaceAll(RegExp(r'\D'), '');
                              if (rakamlar.isNotEmpty &&
                                  (rakamlar.length < 10 ||
                                      rakamlar.length > 13)) {
                                return 'Geçerli bir telefon numarası yazın';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 14),
                          SizedBox(
                            height: 50,
                            child: FilledButton.icon(
                              onPressed: _kaydediliyor ? null : _kaydet,
                              style: FilledButton.styleFrom(
                                backgroundColor: const Color(0xFF00695C),
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(14),
                                ),
                              ),
                              icon: _kaydediliyor
                                  ? const SizedBox(
                                      width: 18,
                                      height: 18,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2.5,
                                        color: Colors.white,
                                      ),
                                    )
                                  : const Icon(Icons.save_outlined),
                              label: const Text(
                                'Kaydet',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
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
                        subtitle:
                            const Text('Otopark rezervasyonlarınızı görüntüleyin'),
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
                        side: const BorderSide(
                            color: Colors.red, width: 1.5),
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
