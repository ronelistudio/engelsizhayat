import 'package:material_ui/material_ui.dart';
import 'package:intl/intl.dart';

import '../models/park_yeri.dart';
import '../models/rezervasyon.dart';
import '../servisler/rezervasyon_servisi.dart';
import 'rezervasyonlarim_ekrani.dart';

/// Otopark rezervasyon formu ekranı.
class RezervasyonEkrani extends StatefulWidget {
  final ParkYeri parkYeri;
  const RezervasyonEkrani({super.key, required this.parkYeri});

  @override
  State<RezervasyonEkrani> createState() => _RezervasyonEkraniState();
}

class _RezervasyonEkraniState extends State<RezervasyonEkrani> {
  final _formKey = GlobalKey<FormState>();
  final _adController = TextEditingController();
  final _telefonController = TextEditingController();
  final _plakaController = TextEditingController();

  DateTime? _tarih;
  TimeOfDay? _saat;
  String _sure = '1 saat';
  bool _kaydediliyor = false;

  static const _sureler = ['1 saat', '2 saat', '3 saat', '4 saat', '6 saat'];

  @override
  void dispose() {
    _adController.dispose();
    _telefonController.dispose();
    _plakaController.dispose();
    super.dispose();
  }

  Future<void> _tarihSec() async {
    final simdi = DateTime.now();
    final secilen = await showDatePicker(
      context: context,
      locale: const Locale('tr'),
      initialDate: simdi,
      firstDate: simdi,
      lastDate: simdi.add(const Duration(days: 90)),
      helpText: 'Rezervasyon Tarihi',
    );
    if (secilen != null) setState(() => _tarih = secilen);
  }

  Future<void> _saatSec() async {
    final secilen = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      helpText: 'Rezervasyon Saati',
    );
    if (secilen != null) setState(() => _saat = secilen);
  }

  Future<void> _onayla() async {
    if (!_formKey.currentState!.validate()) return;
    if (_tarih == null || _saat == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text('Lütfen tarih ve saat seçin.'),
        ),
      );
      return;
    }

    setState(() => _kaydediliyor = true);

    final rezervasyon = Rezervasyon(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      parkYeriId: widget.parkYeri.id,
      parkYeriAd: widget.parkYeri.ad,
      kisiAd: _adController.text.trim(),
      telefon: _telefonController.text.trim(),
      plaka: _plakaController.text.trim().toUpperCase(),
      tarih: DateFormat('d MMMM yyyy, EEEE', 'tr').format(_tarih!),
      saat:
          '${_saat!.hour.toString().padLeft(2, '0')}:${_saat!.minute.toString().padLeft(2, '0')}',
      sure: _sure,
    );

    await RezervasyonServisi().ekle(rezervasyon);
    if (!mounted) return;
    setState(() => _kaydediliyor = false);

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle, size: 72, color: Color(0xFF00695C)),
            const SizedBox(height: 12),
            const Text(
              'Rezervasyonunuz Alındı!',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text(
              '${widget.parkYeri.ad}\n'
              '${rezervasyon.tarih} • ${rezervasyon.saat} • ${rezervasyon.sure}\n'
              'Plaka: ${rezervasyon.plaka}',
              textAlign: TextAlign.center,
              style: const TextStyle(height: 1.5),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (_) => const RezervasyonlarimEkrani(),
                ),
                (rota) => rota.isFirst,
              );
            },
            child: const Text('Rezervasyonlarım'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              Navigator.of(context)
                  .popUntil((rota) => rota.isFirst);
            },
            child: const Text('Tamam'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rezervasyon Yap'),
        backgroundColor: const Color(0xFF00695C),
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        children: [
          // Seçilen park yeri özeti
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFE0F2F1),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                const Icon(Icons.local_parking,
                    color: Color(0xFF00695C), size: 30),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.parkYeri.ad,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        widget.parkYeri.adres,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 11.5,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _adController,
                  textCapitalization: TextCapitalization.words,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: 'Ad Soyad',
                    prefixIcon: const Icon(Icons.person_outline),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
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
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: 'Telefon',
                    hintText: '05xx xxx xx xx',
                    prefixIcon: const Icon(Icons.phone_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  validator: (v) {
                    final rakamlar =
                        (v ?? '').replaceAll(RegExp(r'\D'), '');
                    if (rakamlar.length < 10 || rakamlar.length > 13) {
                      return 'Geçerli bir telefon numarası yazın';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _plakaController,
                  textCapitalization: TextCapitalization.characters,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: 'Plaka',
                    hintText: '34 ABC 1234',
                    prefixIcon: const Icon(Icons.directions_car_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onChanged: (v) {
                    final buyuk = v.toUpperCase();
                    if (buyuk != v) {
                      _plakaController.value = TextEditingValue(
                        text: buyuk,
                        selection:
                            TextSelection.collapsed(offset: buyuk.length),
                      );
                    }
                  },
                  validator: (v) {
                    final plaka =
                        (v ?? '').toUpperCase().replaceAll(' ', '');
                    final gecerli = RegExp(
                      r'^\d{2}[A-ZÇĞİÖŞÜ]{1,3}\d{2,4}$',
                    ).hasMatch(plaka);
                    if (!gecerli) return 'Geçerli bir plaka yazın (34 ABC 1234)';
                    return null;
                  },
                ),
                const SizedBox(height: 12),

                // Tarih ve saat seçimi
                Row(
                  children: [
                    Expanded(
                      child: _secimAlani(
                        ikon: Icons.calendar_today_outlined,
                        etiket: 'Tarih',
                        deger: _tarih == null
                            ? 'Seçin'
                            : DateFormat('d MMM yyyy', 'tr').format(_tarih!),
                        onTap: _tarihSec,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _secimAlani(
                        ikon: Icons.access_time,
                        etiket: 'Saat',
                        deger: _saat == null
                            ? 'Seçin'
                            : _saat!.format(context),
                        onTap: _saatSec,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Süre
                DropdownButtonFormField<String>(
                  initialValue: _sure,
                  decoration: InputDecoration(
                    labelText: 'Süre',
                    prefixIcon: const Icon(Icons.timer_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  items: [
                    for (final s in _sureler)
                      DropdownMenuItem(value: s, child: Text(s)),
                  ],
                  onChanged: (v) => setState(() => _sure = v ?? '1 saat'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          SizedBox(
            height: 56,
            child: FilledButton.icon(
              onPressed: _kaydediliyor ? null : _onayla,
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF00695C),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              icon: _kaydediliyor
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.check_circle_outline),
              label: Text(
                _kaydediliyor ? 'Kaydediliyor...' : 'Rezervasyonu Onayla',
                style: const TextStyle(
                    fontSize: 16.5, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _secimAlani({
    required IconData ikon,
    required String etiket,
    required String deger,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: etiket,
          prefixIcon: Icon(ikon),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: Text(
          deger,
          style: TextStyle(
            fontSize: 15,
            color: deger == 'Seçin' ? Colors.grey.shade800 : Colors.black87,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
