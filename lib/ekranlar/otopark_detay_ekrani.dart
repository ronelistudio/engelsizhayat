import 'package:material_ui/material_ui.dart';

import '../models/park_yeri.dart';
import 'rezervasyon_ekrani.dart';

/// Seçilen park yerinin detaylarını gösterir.
class OtoparkDetayEkrani extends StatelessWidget {
  final ParkYeri parkYeri;
  const OtoparkDetayEkrani({super.key, required this.parkYeri});

  @override
  Widget build(BuildContext context) {
    final dolu = parkYeri.doluYer;
    final boslukVar = parkYeri.bosYer > 0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Park Yeri Detayı'),
        backgroundColor: const Color(0xFF00695C),
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
        children: [
          // Başlık kartı
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: const Color(0xFF00897B),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF00897B).withValues(alpha: 0.4),
                  blurRadius: 14,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(Icons.local_parking,
                          size: 36, color: Color(0xFF00695C)),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            parkYeri.ad,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(Icons.star,
                                  size: 16, color: Colors.amber),
                              const SizedBox(width: 4),
                              Text(
                                '${parkYeri.puan.toStringAsFixed(1)} / 10',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                ),
                              ),
                              const SizedBox(width: 10),
                              const Icon(Icons.near_me,
                                  size: 16, color: Colors.white70),
                              const SizedBox(width: 4),
                              Text(
                                '${parkYeri.mesafeKm.toStringAsFixed(1)} km',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Temel bilgiler
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                _bilgiSatiri(Icons.place_outlined, 'Adres', parkYeri.adres),
                const Divider(height: 1, indent: 56),
                _bilgiSatiri(
                    Icons.schedule, 'Çalışma Saatleri', parkYeri.calismaSaatleri),
                const Divider(height: 1, indent: 56),
                _bilgiSatiri(Icons.payments_outlined, 'Ücret', parkYeri.ucret),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Doluluk durumu
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Engelli Park Yeri Durumu',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${parkYeri.bosYer} / ${parkYeri.toplamEngelliYeri} yer boş',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: boslukVar
                              ? Colors.green.shade800
                              : Colors.red.shade800,
                        ),
                      ),
                      Text(
                        '$dolu dolu',
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: parkYeri.dolulukOrani,
                      minHeight: 12,
                      backgroundColor: Colors.green.shade100,
                      valueColor: AlwaysStoppedAnimation(
                        boslukVar ? const Color(0xFF00695C) : Colors.red,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    boslukVar
                        ? 'Rezervasyon yaparak yerinizi ayırtabilirsiniz.'
                        : 'Şu an tüm yerler dolu. İlerleyen saatlerde tekrar kontrol edin.',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Erişilebilirlik özellikleri
          const Text(
            'Erişilebilirlik Özellikleri',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final ozellik in parkYeri.ozellikler)
                Chip(
                  avatar: const Icon(
                    Icons.check_circle,
                    size: 18,
                    color: Color(0xFF00695C),
                  ),
                  label: Text(ozellik),
                  backgroundColor: const Color(0xFFE0F2F1),
                  side: BorderSide.none,
                ),
            ],
          ),
          const SizedBox(height: 16),

          // Bilgilendirme
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.amber.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.amber.shade200),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline,
                    color: Colors.amber.shade800, size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Rezervasyon sonrası yeriniz 30 dakika boyunca ayrılır. '
                    'Süre içinde gelmezseniz rezervasyonunuz iptal edilir.',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.amber.shade900,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      // Rezervasyon yap butonu
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          child: SizedBox(
            height: 56,
            child: FilledButton.icon(
              onPressed: boslukVar
                  ? () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) =>
                              RezervasyonEkrani(parkYeri: parkYeri),
                        ),
                      )
                  : null,
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF00695C),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              icon: const Icon(Icons.event_available),
              label: const Text(
                'Rezervasyon Yap',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _bilgiSatiri(IconData ikon, String baslik, String deger) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: const Color(0xFFE0F2F1),
        child: Icon(ikon, color: const Color(0xFF00695C), size: 20),
      ),
      title: Text(
        baslik,
        style: TextStyle(fontSize: 11.5, color: Colors.grey.shade600),
      ),
      subtitle: Text(
        deger,
        style: const TextStyle(
          fontSize: 13.5,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
      ),
    );
  }
}
