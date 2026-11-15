import 'package:material_ui/material_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'panel_ekrani.dart';

/// Uygulamanın giriş ekranı.
/// Referans tasarıma yakın, Engelsiz Yaşam renkleriyle:
/// üstte turkuaz hero + alttaki beyaz yuvarlak "Hoş geldiniz" kartı.
class GirisEkrani extends StatefulWidget {
  const GirisEkrani({super.key});

  @override
  State<GirisEkrani> createState() => _GirisEkraniState();
}

class _GirisEkraniState extends State<GirisEkrani> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _sifreController = TextEditingController();

  bool _sifreGizli = true;
  bool _beniHatirla = true;
  bool _yukleniyor = false;
  bool _oturumKontrolEdiliyor = true;

  @override
  void initState() {
    super.initState();
    _oturumKontrolEt();
  }

  /// "Beni hatırla" açıkken kullanıcı tekrar giriş yapmadan panele geçer.
  Future<void> _oturumKontrolEt() async {
    final prefs = await SharedPreferences.getInstance();
    final girisYapildi = prefs.getBool('giris_yapildi') ?? false;
    if (girisYapildi && mounted) {
      final ad = prefs.getString('kullanici_ad') ?? 'Kullanıcı';
      final email = prefs.getString('kullanici_email') ?? '';
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => PanelEkrani(ad: ad, email: email),
        ),
      );
      return;
    }
    if (mounted) setState(() => _oturumKontrolEdiliyor = false);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _sifreController.dispose();
    super.dispose();
  }

  String _adHesapla(String email) {
    final kisi = email.split('@').first.replaceAll(RegExp(r'[._-]+'), ' ').trim();
    if (kisi.isEmpty) return 'Kullanıcı';
    return kisi
        .split(' ')
        .where((p) => p.isNotEmpty)
        .map((p) => p[0].toUpperCase() + p.substring(1))
        .join(' ');
  }

  void _yakinda(String mesaj) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text(mesaj),
      ),
    );
  }

  Future<void> _girisYap() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _yukleniyor = true);
    // Gerçek bir backend bağlanana kadar küçük bir gecikme ile simüle edilir.
    await Future.delayed(const Duration(milliseconds: 700));
    if (!mounted) return;

    final email = _emailController.text.trim();
    final ad = email.toLowerCase() == 'demo@engelsiz.com'
        ? 'Demo Kullanıcı'
        : _adHesapla(email);

    if (_beniHatirla) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('giris_yapildi', true);
      await prefs.setString('kullanici_ad', ad);
      await prefs.setString('kullanici_email', email);
    }

    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => PanelEkrani(ad: ad, email: email)),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_oturumKontrolEdiliyor) {
      return const Scaffold(
        backgroundColor: Color(0xFF004D40),
        body: Center(
          child: CircularProgressIndicator(color: Colors.white),
        ),
      );
    }

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF004D40), Color(0xFF00695C), Color(0xFF00897B)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          top: true,
          child: Column(
            children: [
              // ─── HERO ───────────────────────────────────────────────
              Expanded(
                flex: 4,
                child: Semantics(
                  label: 'Engelsiz Yaşam tanıtım illüstrasyonu',
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Arka plan ışık halkaları
                      Positioned(
                        width: 220,
                        height: 220,
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withValues(alpha: 0.08),
                          ),
                        ),
                      ),
                      Positioned(
                        width: 150,
                        height: 150,
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withValues(alpha: 0.1),
                          ),
                        ),
                      ),
                      // Hizmet ikonları — "her şey burada" hissi
                      _heroIkon(Icons.local_parking,
                          const Alignment(-0.72, -0.42), -0.18),
                      _heroIkon(Icons.local_hospital,
                          const Alignment(0.66, -0.46), 0.16),
                      _heroIkon(Icons.directions_bus,
                          const Alignment(-0.82, 0.52), 0.12),
                      _heroIkon(Icons.theater_comedy,
                          const Alignment(0.76, 0.44), -0.12),
                      // Merkez: erişilebilirlik simgesi
                      Container(
                        width: 112,
                        height: 112,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.3),
                              blurRadius: 22,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.accessible,
                          size: 68,
                          color: Color(0xFF00695C),
                        ),
                      ),
                      // Başlık
                      Positioned(
                        bottom: 0,
                        child: Column(
                          children: [
                            const Text(
                              'Engelsiz Yaşam',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 27,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                            Text(
                              'Herkes için erişilebilir bir yaşam',
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.92),
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // ─── BEYAZ KART ─────────────────────────────────────────
              Expanded(
                flex: 5,
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(32),
                    ),
                  ),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(24, 18, 24, 16),
                    child: LayoutBuilder(
                      builder: (context, constraints) => SizedBox(
                        width: constraints.maxWidth.clamp(0.0, 460.0),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                'Hoş Geldiniz',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF004D40),
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Giriş yaparak rezervasyonlarınızı yönetin',
                                style: TextStyle(
                                  fontSize: 12.5,
                                  color: Colors.grey.shade800,
                                ),
                              ),
                              const SizedBox(height: 14),
                              TextFormField(
                                controller: _emailController,
                                keyboardType:
                                    TextInputType.emailAddress,
                                textInputAction: TextInputAction.next,
                                autofillHints: const [AutofillHints.email],
                                autofocus: true,
                                decoration: InputDecoration(
                                  labelText: 'E-posta',
                                  hintText: 'ornek@eposta.com',
                                  prefixIcon: const Icon(Icons.email_outlined),
                                  filled: true,
                                  fillColor: const Color(0xFFF1F6F5),
                                  border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.circular(14),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                                validator: (deger) {
                                  final v = deger?.trim() ?? '';
                                  if (v.isEmpty) return 'E-posta gerekli';
                                  final gecerli = RegExp(
                                    r'^[\w.+-]+@[\w-]+\.[\w.-]+$',
                                  ).hasMatch(v);
                                  if (!gecerli) {
                                    return 'Geçerli bir e-posta yazın';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 12),
                              TextFormField(
                                controller: _sifreController,
                                obscureText: _sifreGizli,
                                textInputAction: TextInputAction.done,
                                onFieldSubmitted: (_) => _girisYap(),
                                autofillHints: const [AutofillHints.password],
                                decoration: InputDecoration(
                                  labelText: 'Parola',
                                  prefixIcon: const Icon(Icons.lock_outline),
                                  filled: true,
                                  fillColor: const Color(0xFFF1F6F5),
                                  border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.circular(14),
                                    borderSide: BorderSide.none,
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.circular(14),
                                    borderSide: const BorderSide(
                                      color: Color(0xFF00695C),
                                      width: 3,
                                    ),
                                  ),
                                  suffixIcon: IconButton(
                                    tooltip: _sifreGizli
                                        ? 'Parolayı göster'
                                        : 'Parolayı gizle',
                                    icon: Icon(_sifreGizli
                                        ? Icons.visibility_outlined
                                        : Icons
                                            .visibility_off_outlined),
                                    onPressed: () => setState(() =>
                                        _sifreGizli = !_sifreGizli),
                                  ),
                                ),
                                validator: (deger) {
                                  final v = deger ?? '';
                                  if (v.isEmpty) return 'Parola gerekli';
                                  if (v.length < 6) {
                                    return 'Parola en az 6 karakter olmalı';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  Checkbox(
                                    value: _beniHatirla,
                                    activeColor: const Color(0xFF00695C),
                                    onChanged: (v) => setState(
                                        () => _beniHatirla = v ?? true),
                                  ),
                                  const Expanded(
                                    child: Text('Beni hatırla',
                                        style:
                                            TextStyle(fontSize: 13)),
                                  ),
                                  TextButton(
                                    onPressed: () => _yakinda(
                                        'Parola sıfırlama çok yakında eklenecek.'),
                                    style: TextButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 4),
                                    ),
                                    child: const Text(
                                      'Parolamı unuttum?',
                                      style: TextStyle(fontSize: 12.5),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              SizedBox(
                                height: 54,
                                child: FilledButton(
                                  onPressed:
                                      _yukleniyor ? null : _girisYap,
                                  style: FilledButton.styleFrom(
                                    backgroundColor:
                                        const Color(0xFF00695C),
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(14),
                                    ),
                                  ),
                                  child: _yukleniyor
                                      ? const SizedBox(
                                          width: 26,
                                          height: 26,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 3,
                                            color: Colors.white,
                                          ),
                                        )
                                      : const Text(
                                          'Giriş Yap',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight:
                                                FontWeight.bold,
                                          ),
                                        ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              // ── Sosyal giriş ──
                              Row(
                                children: [
                                  const Expanded(child: Divider()),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: Text(
                                      'veya devam edin',
                                      style: TextStyle(
                                        fontSize: 11.5,
                                        color: Colors.grey.shade800,
                                      ),
                                    ),
                                  ),
                                  const Expanded(child: Divider()),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  Expanded(
                                    child: SizedBox(
                                      height: 48,
                                      child: OutlinedButton.icon(
                                        onPressed: () => _yakinda(
                                            'Google ile giriş çok yakında.'),
                                        style: OutlinedButton.styleFrom(
                                          side: BorderSide(
                                              color:
                                                  Colors.grey.shade300),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                        ),
                                        icon: const Text(
                                          'G',
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF4285F4),
                                          ),
                                        ),
                                        label: const Text('Google',
                                            style: TextStyle(
                                                color: Colors.black87)),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: SizedBox(
                                      height: 48,
                                      child: OutlinedButton.icon(
                                        onPressed: () => _yakinda(
                                            'Apple ile giriş çok yakında.'),
                                        style: OutlinedButton.styleFrom(
                                          side: BorderSide(
                                              color:
                                                  Colors.grey.shade300),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                        ),
                                        icon: const Icon(
                                            Icons.phone_iphone,
                                            color: Colors.black87),
                                        label: const Text('Apple',
                                            style: TextStyle(
                                                color: Colors.black87)),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Center(
                                child: Wrap(
                                  crossAxisAlignment:
                                      WrapCrossAlignment.center,
                                  children: [
                                    Text(
                                      'Hesabınız yok mu? ',
                                      style: TextStyle(
                                        fontSize: 12.5,
                                        color: Colors.grey.shade800,
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () => _yakinda(
                                          'Kayıt olma çok yakında eklenecek.'),
                                      style: TextButton.styleFrom(
                                        padding: EdgeInsets.zero,
                                      ),
                                      child: const Text(
                                        'Kayıt olun',
                                        style: TextStyle(
                                          color: Color(0xFF00695C),
                                          fontWeight:
                                              FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 4),
                              // Demo hesap
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFE0F2F1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Row(
                                  children: [
                                    Icon(Icons.info_outline,
                                        size: 18,
                                        color: Color(0xFF00695C)),
                                    SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        'Demo hesap: demo@engelsiz.com / 123456',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFF004D40),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 6),
                              Center(
                                child: Text(
                                  'Sürüm 1.0.0',
                                  style: TextStyle(
                                    color: Colors.grey.shade800,
                                    fontSize: 11,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
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

  /// Hero içindeki yüzen servis ikonu.
  Widget _heroIkon(IconData ikon, Alignment alignment, double aci) {
    return Align(
      alignment: alignment,
      child: Transform.rotate(
        angle: aci,
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.18),
            shape: BoxShape.circle,
          ),
          child: Icon(ikon, size: 22, color: Colors.white),
        ),
      ),
    );
  }
}
