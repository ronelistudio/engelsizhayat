import 'package:material_ui/material_ui.dart';

/// Uygulama genelinde erişilebilirlik tercihlerini tutar ve dinler.
///
/// - `fontOlcegi`: metin ölçeği (0.85 – 1.6 arası)
/// - `yuksekKontrast`: siyah zemin / beyaz metin / sarı vurgu (WCAG AAA benzeri)
/// - `griTon`: sayfayı gri tonlamaya çevirir (renk körlüğü olan kullanıcılar
///   için renk yerine şekil ve metne odaklanmak)
/// - `altiCiziliBaglantilar`: metin düğmelerinin altını çizer
class ErisilebilirlikAyarlari extends ChangeNotifier {
  double fontOlcegi = 1.0;
  bool yuksekKontrast = false;
  bool griTon = false;
  bool altiCiziliBaglantilar = false;

  static const _adim = 0.15;
  static const _min = 0.85;
  static const _max = 1.6;

  void fontBuyut() {
    fontOlcegi = (fontOlcegi + _adim).clamp(_min, _max);
    notifyListeners();
  }

  void fontKucult() {
    fontOlcegi = (fontOlcegi - _adim).clamp(_min, _max);
    notifyListeners();
  }

  void fontOlcegiSifirla() {
    fontOlcegi = 1.0;
    notifyListeners();
  }

  void yuksekKontrastDegistir() {
    yuksekKontrast = !yuksekKontrast;
    notifyListeners();
  }

  void griTonDegistir() {
    griTon = !griTon;
    notifyListeners();
  }

  void altiCiziliBaglantilarDegistir() {
    altiCiziliBaglantilar = !altiCiziliBaglantilar;
    notifyListeners();
  }
}

/// Alt ağaca erişilebilirlik ayarlarını taşıyan inherited widget.
class ErisilebilirlikKapsam extends InheritedNotifier<ErisilebilirlikAyarlari> {
  const ErisilebilirlikKapsam({
    super.key,
    required ErisilebilirlikAyarlari ayarlar,
    required super.child,
  }) : super(notifier: ayarlar);

  static ErisilebilirlikAyarlari of(BuildContext context) {
    final kapsam =
        context.dependOnInheritedWidgetOfExactType<ErisilebilirlikKapsam>();
    assert(kapsam != null, 'ErisilebilirlikKapsam bulunamadı');
    return kapsam!.notifier!;
  }
}
