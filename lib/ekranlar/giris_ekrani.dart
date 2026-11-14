import 'package:material_ui/material_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'menu_ekrani.dart';

/// Uygulamanın giriş ekranı.
/// Demo: demo@engelsiz.com / 123456 (ya da herhangi geçerli e-posta + 6+ karakter parola)
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

  /// "Beni hatırla" açıkken kullanıcı tekrar giriş yapmadan menüye geçer.
  Future<void> _oturumKontrolEt() async {
    final prefs = await SharedPreferences.getInstance();
    final girisYapildi = prefs.getBool('giris_yapildi') ?? false;
    if (girisYapildi && mounted) {
      final ad = prefs.getString('kullanici_ad') ?? 'Kullanıcı';
      final email = prefs.getString('kullanici_email') ?? '';
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => MenuEkrani(ad: ad, email: email),
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
      MaterialPageRoute(builder: (_) => MenuEkrani(ad: ad, email: email)),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_oturumKontrolEdiliyor) {
      return const Scaffold(
        backgroundColor: Color(0xFF00695C),
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
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Logo ve uygulama adı
                    Semantics(
                      label: 'Engelsiz Yaşam erişilebilirlik logosu',
                      image: true,
                      child: Container(
                        width: 96,
                        height: 96,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.25),
                              blurRadius: 16,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.accessible,
                          size: 56,
                          color: Color(0xFF00695C),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Engelsiz Yaşam',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Herkes için erişilebilir bir yaşam',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.95),
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Giriş kartı
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.25),
                            blurRadius: 24,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const Text(
                              'Giriş Yap',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF004D40),
                              ),
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _emailController,
                              keyboardType:
                                  TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                              autofillHints: const [AutofillHints.email],
                              autofocus: true,
                              decoration: const InputDecoration(
                                labelText: 'E-posta',
                                hintText: 'ornek@eposta.com',
                                prefixIcon: Icon(Icons.email_outlined),
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(14)),
                                ),
                              ),
                              validator: (deger) {
                                final v = deger?.trim() ?? '';
                                if (v.isEmpty) return 'E-posta gerekli';
                                final gecerli = RegExp(
                                  r'^[\w.+-]+@[\w-]+\.[\w.-]+$',
                                ).hasMatch(v);
                                if (!gecerli) return 'Geçerli bir e-posta yazın';
                                return null;
                              },
                            ),
                            const SizedBox(height: 14),
                            TextFormField(
                              controller: _sifreController,
                              obscureText: _sifreGizli,
                              textInputAction: TextInputAction.done,
                              onFieldSubmitted: (_) => _girisYap(),
                              autofillHints: const [AutofillHints.password],
                              decoration: InputDecoration(
                                labelText: 'Parola',
                                prefixIcon: const Icon(Icons.lock_outline),
                                border: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(14)),
                                ),
                                suffixIcon: IconButton(
                                  tooltip: _sifreGizli
                                      ? 'Parolayı göster'
                                      : 'Parolayı gizle',
                                  icon: Icon(_sifreGizli
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined),
                                  onPressed: () => setState(
                                      () => _sifreGizli = !_sifreGizli),
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
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Checkbox(
                                  value: _beniHatirla,
                                  activeColor: const Color(0xFF00695C),
                                  onChanged: (v) =>
                                      setState(() => _beniHatirla = v ?? true),
                                ),
                                const Expanded(
                                  child: Text(
                                    'Beni hatırla',
                                    style: TextStyle(fontSize: 14),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () => ScaffoldMessenger.of(context)
                                      .showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Parola sıfırlama çok yakında eklenecek.',
                                      ),
                                    ),
                                  ),
                                  child: const Text('Parolamı unuttum'),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            SizedBox(
                              height: 54,
                              child: FilledButton(
                                onPressed: _yukleniyor ? null : _girisYap,
                                style: FilledButton.styleFrom(
                                  backgroundColor: const Color(0xFF00695C),
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
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: const Color(0xFFE0F2F1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Row(
                                children: [
                                  Icon(Icons.info_outline,
                                      size: 18, color: Color(0xFF00695C)),
                                  SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      'Demo hesap: demo@engelsiz.com / 123456',
                                      style: TextStyle(
                                        fontSize: 12.5,
                                        color: Color(0xFF004D40),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Sürüm 1.0.0',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.75),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
