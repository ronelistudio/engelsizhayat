import 'package:material_ui/material_ui.dart';

import 'erisilebilirlik.dart';

/// Sayfanın sağ alt köşesine sabitlenen erişilebilirlik araç çubuğu.
/// Yazı boyutu, yüksek kontrast, gri tonlama ve bağlantı alt çizgisi ayarları.
class ErisilebilirlikAraci extends StatefulWidget {
  const ErisilebilirlikAraci({super.key});

  @override
  State<ErisilebilirlikAraci> createState() => _ErisilebilirlikAraciState();
}

class _ErisilebilirlikAraciState extends State<ErisilebilirlikAraci> {
  bool _acik = false;

  @override
  Widget build(BuildContext context) {
    final ayar = ErisilebilirlikKapsam.of(context);

    return Positioned(
      right: 12,
      bottom: 12,
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (_acik)
              _Panel(ayar: ayar, kapat: () => setState(() => _acik = false)),
            const SizedBox(height: 8),
            Semantics(
              button: true,
              label: _acik
                  ? 'Erişilebilirlik araç çubuğunu kapat'
                  : 'Erişilebilirlik araç çubuğunu aç',
              child: FloatingActionButton(
                heroTag: 'erisilebilirlik-fab',
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
                onPressed: () => setState(() => _acik = !_acik),
                child: Icon(
                  _acik ? Icons.close : Icons.accessible,
                  size: 30,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Panel extends StatelessWidget {
  final ErisilebilirlikAyarlari ayar;
  final VoidCallback kapat;

  const _Panel({required this.ayar, required this.kapat});

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);

    return Material(
      elevation: 8,
      borderRadius: BorderRadius.circular(20),
      color: tema.colorScheme.surface,
      clipBehavior: Clip.antiAlias,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 320),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.accessible,
                      color: tema.colorScheme.primary, size: 22),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Erişilebilirlik',
                      style: tema.textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Semantics(
                    button: true,
                    label: 'Erişilebilirlik panelini kapat',
                    child: IconButton(
                      onPressed: kapat,
                      icon: const Icon(Icons.close),
                    ),
                  ),
                ],
              ),
              const Divider(),

              // Yazı boyutu
              Text(
                'Yazı boyutu',
                style: tema.textTheme.labelLarge,
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _panelDugme(
                    ikon: Icons.text_decrease,
                    etiket: 'Yazıyı küçült',
                    onTap: ayar.fontKucult,
                  ),
                  Semantics(
                    label:
                        'Metin ölçeği yüzde ${(ayar.fontOlcegi * 100).round()}',
                    child: Text(
                      '%${(ayar.fontOlcegi * 100).round()}',
                      style: tema.textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                  _panelDugme(
                    ikon: Icons.text_increase,
                    etiket: 'Yazıyı büyüt',
                    onTap: ayar.fontBuyut,
                  ),
                  _panelDugme(
                    ikon: Icons.restart_alt,
                    etiket: 'Yazı boyutunu sıfırla',
                    onTap: ayar.fontOlcegiSifirla,
                  ),
                ],
              ),
              const SizedBox(height: 8),

              _anahtarSatir(
                ikon: Icons.contrast,
                etiket: 'Yüksek kontrast',
                aciklama: 'Siyah zemin, sarı vurgu',
                deger: ayar.yuksekKontrast,
                onChanged: (_) => ayar.yuksekKontrastDegistir(),
              ),
              _anahtarSatir(
                ikon: Icons.filter_b_and_w,
                etiket: 'Gri tonlama',
                aciklama: 'Renk bilgisini kaldırır',
                deger: ayar.griTon,
                onChanged: (_) => ayar.griTonDegistir(),
              ),
              _anahtarSatir(
                ikon: Icons.format_underlined,
                etiket: 'Altı çizili bağlantılar',
                aciklama: 'Bağlantıların altını çizer',
                deger: ayar.altiCiziliBaglantilar,
                onChanged: (_) => ayar.altiCiziliBaglantilarDegistir(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _panelDugme({
    required IconData ikon,
    required String etiket,
    required VoidCallback onTap,
  }) {
    return Semantics(
      button: true,
      label: etiket,
      child: IconButton(
        iconSize: 26,
        onPressed: onTap,
        icon: Icon(ikon),
      ),
    );
  }

  Widget _anahtarSatir({
    required IconData ikon,
    required String etiket,
    required String aciklama,
    required bool deger,
    required ValueChanged<bool> onChanged,
  }) {
    return SizedBox(
      height: 56,
      child: Row(
        children: [
          Icon(ikon, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(etiket, style: const TextStyle(fontWeight: FontWeight.w600)),
                Text(aciklama, style: const TextStyle(fontSize: 11)),
              ],
            ),
          ),
          Switch(
            value: deger,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
