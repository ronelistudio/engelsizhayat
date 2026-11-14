import 'package:material_ui/material_ui.dart';

import '../data/ornek_veriler.dart';
import '../models/park_yeri.dart';
import 'otopark_detay_ekrani.dart';

enum _Filtre { tumu, yakin, bos, ucretsiz }

/// Erişilebilir otoparkların listelendiği ve arandığı ekran.
class OtoparkEkrani extends StatefulWidget {
  const OtoparkEkrani({super.key});

  @override
  State<OtoparkEkrani> createState() => _OtoparkEkraniState();
}

class _OtoparkEkraniState extends State<OtoparkEkrani> {
  final _aramaController = TextEditingController();
  String _arama = '';
  _Filtre _filtre = _Filtre.tumu;

  @override
  void dispose() {
    _aramaController.dispose();
    super.dispose();
  }

  List<ParkYeri> get _filtreliListe {
    var liste = ornekParkYerleri.where((p) {
      if (_arama.isEmpty) return true;
      final q = _arama.toLowerCase();
      return p.ad.toLowerCase().contains(q) ||
          p.adres.toLowerCase().contains(q);
    }).toList();

    switch (_filtre) {
      case _Filtre.yakin:
        liste = liste.where((p) => p.mesafeKm <= 5).toList();
      case _Filtre.bos:
        liste = liste.where((p) => p.bosYer > 0).toList();
      case _Filtre.ucretsiz:
        liste = liste.where((p) => p.ucretsiz).toList();
      case _Filtre.tumu:
        break;
    }
    liste.sort((a, b) => a.mesafeKm.compareTo(b.mesafeKm));
    return liste;
  }

  @override
  Widget build(BuildContext context) {
    final liste = _filtreliListe;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Engelli Otopark Bul'),
        backgroundColor: const Color(0xFF00695C),
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Arama kutusu
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: TextField(
              controller: _aramaController,
              decoration: InputDecoration(
                hintText: 'Otopark adı veya adres ara...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _arama.isEmpty
                    ? null
                    : IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _aramaController.clear();
                          setState(() => _arama = '');
                        },
                      ),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (deger) => setState(() => _arama = deger.trim()),
            ),
          ),

          // Filtre çipleri
          SizedBox(
            height: 44,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: [
                _filtreCipi('Tümü', _Filtre.tumu, Icons.apps),
                _filtreCipi('5 km içinde', _Filtre.yakin, Icons.near_me),
                _filtreCipi('Boş yeri var', _Filtre.bos,
                    Icons.event_available),
                _filtreCipi('Ücretsiz', _Filtre.ucretsiz, Icons.sell_outlined),
              ],
            ),
          ),
          const SizedBox(height: 4),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                '${liste.length} park yeri listelendi',
                style: TextStyle(color: Colors.grey.shade600, fontSize: 12.5),
              ),
            ),
          ),

          // Liste
          Expanded(
            child: liste.isEmpty
                ? _bosListe()
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                    itemCount: liste.length,
                    itemBuilder: (context, index) =>
                        _ParkKarti(park: liste[index]),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _filtreCipi(String etiket, _Filtre filtre, IconData ikon) {
    final secili = _filtre == filtre;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: FilterChip(
        avatar: Icon(
          ikon,
          size: 17,
          color: secili ? Colors.white : const Color(0xFF00695C),
        ),
        label: Text(etiket),
        selected: secili,
        showCheckmark: false,
        selectedColor: const Color(0xFF00695C),
        labelStyle: TextStyle(
          color: secili ? Colors.white : const Color(0xFF004D40),
          fontWeight: FontWeight.w600,
        ),
        onSelected: (_) => setState(() => _filtre = filtre),
      ),
    );
  }

  Widget _bosListe() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.search_off, size: 64, color: Colors.grey.shade400),
            const SizedBox(height: 12),
            const Text(
              'Sonuç bulunamadı',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text(
              'Arama veya filtreleri değiştirmeyi deneyin.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ],
        ),
      ),
    );
  }
}

class _ParkKarti extends StatelessWidget {
  final ParkYeri park;
  const _ParkKarti({required this.park});

  @override
  Widget build(BuildContext context) {
    final bosVar = park.bosYer > 0;
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => OtoparkDetayEkrani(parkYeri: park),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              // İkon
              Container(
                width: 62,
                height: 62,
                decoration: BoxDecoration(
                  color: const Color(0xFF00695C),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.accessible,
                  color: Colors.white,
                  size: 34,
                ),
              ),
              const SizedBox(width: 12),
              // Bilgiler
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      park.ad,
                      style: const TextStyle(
                        fontSize: 15.5,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      park.adres,
                      style: TextStyle(
                        fontSize: 11.5,
                        color: Colors.grey.shade600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 6,
                      runSpacing: 4,
                      children: [
                        _etiket(
                          Icons.near_me,
                          '${park.mesafeKm.toStringAsFixed(1)} km',
                          Colors.blueGrey,
                        ),
                        _etiket(
                          bosVar ? Icons.event_available : Icons.event_busy,
                          bosVar ? '${park.bosYer} boş yer' : 'Dolu',
                          bosVar ? Colors.green.shade800 : Colors.red.shade800,
                        ),
                        _etiket(
                          Icons.sell_outlined,
                          park.ucret,
                          Colors.teal.shade800,
                        ),
                        _etiket(
                          Icons.star,
                          park.puan.toStringAsFixed(1),
                          Colors.amber.shade900,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }

  Widget _etiket(IconData ikon, String metin, Color renk) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: renk.withValues(alpha: 0.09),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(ikon, size: 12, color: renk),
          const SizedBox(width: 3),
          Text(
            metin,
            style: TextStyle(
              fontSize: 10.5,
              fontWeight: FontWeight.w600,
              color: renk,
            ),
          ),
        ],
      ),
    );
  }
}
