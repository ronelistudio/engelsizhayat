import 'package:material_ui/material_ui.dart';

import '../models/rezervasyon.dart';
import '../servisler/rezervasyon_servisi.dart';

/// Kullanıcının tüm otopark rezervasyonlarını listeler, iptal etmeye izin verir.
class RezervasyonlarimEkrani extends StatefulWidget {
  const RezervasyonlarimEkrani({super.key});

  @override
  State<RezervasyonlarimEkrani> createState() =>
      _RezervasyonlarimEkraniState();
}

class _RezervasyonlarimEkraniState extends State<RezervasyonlarimEkrani> {
  final _servis = RezervasyonServisi();
  late Future<List<Rezervasyon>> _future;

  @override
  void initState() {
    super.initState();
    _yukle();
  }

  void _yukle() {
    _future = _servis.getir();
  }

  Future<void> _iptalEt(Rezervasyon rezervasyon) async {
    final onay = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Rezervasyonu İptal Et'),
        content: Text(
          '${rezervasyon.parkYeriAd} için ${rezervasyon.tarih} '
          '${rezervasyon.saat} rezervasyonunuzu iptal etmek istediğinize '
          'emin misiniz?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Vazgeç'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text(
              'İptal Et',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
    if (onay == true) {
      await _servis.sil(rezervasyon.id);
      if (!mounted) return;
      setState(_yukle);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text('Rezervasyonunuz iptal edildi.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rezervasyonlarım'),
        backgroundColor: const Color(0xFF00695C),
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<List<Rezervasyon>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final liste = snapshot.data ?? [];
          if (liste.isEmpty) {
            return _bosDurum();
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: liste.length,
            itemBuilder: (context, index) {
              final r = liste[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 46,
                            height: 46,
                            decoration: BoxDecoration(
                              color: const Color(0xFF00695C),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(Icons.local_parking,
                                color: Colors.white, size: 24),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              r.parkYeriAd,
                              style: const TextStyle(
                                fontSize: 15.5,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 6,
                        children: [
                          _etiket(Icons.calendar_today, r.tarih),
                          _etiket(Icons.access_time,
                              '${r.saat} (${r.sure})'),
                          _etiket(Icons.directions_car, r.plaka),
                          _etiket(Icons.person, r.kisiAd),
                          _etiket(Icons.phone, r.telefon),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Align(
                        alignment: Alignment.centerRight,
                        child: OutlinedButton.icon(
                          onPressed: () => _iptalEt(r),
                          icon: const Icon(Icons.cancel_outlined,
                              color: Colors.red, size: 19),
                          label: const Text(
                            'İptal Et',
                            style: TextStyle(color: Colors.red),
                          ),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.red),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _etiket(IconData ikon, String metin) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFE0F2F1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(ikon, size: 13, color: const Color(0xFF00695C)),
          const SizedBox(width: 5),
          Text(
            metin,
            style: const TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w600,
              color: Color(0xFF004D40),
            ),
          ),
        ],
      ),
    );
  }

  Widget _bosDurum() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.event_busy, size: 64, color: Colors.grey.shade400),
            const SizedBox(height: 12),
            const Text(
              'Henüz rezervasyonunuz yok',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text(
              'Menüden Otopark bölümüne gidip engelli park yerleri için '
              'rezervasyon yapabilirsiniz.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade600),
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: () => Navigator.of(context).pop(),
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF00695C),
              ),
              icon: const Icon(Icons.local_parking),
              label: const Text('Otopark Bölümüne Git'),
            ),
          ],
        ),
      ),
    );
  }
}
