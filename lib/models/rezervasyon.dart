/// Kullanıcının yaptığı bir otopark rezervasyonunu temsil eder.
class Rezervasyon {
  final String id;
  final String parkYeriId;
  final String parkYeriAd;
  final String kisiAd;
  final String telefon;
  final String plaka;
  final String tarih;
  final String saat;
  final String sure;

  const Rezervasyon({
    required this.id,
    required this.parkYeriId,
    required this.parkYeriAd,
    required this.kisiAd,
    required this.telefon,
    required this.plaka,
    required this.tarih,
    required this.saat,
    required this.sure,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'parkYeriId': parkYeriId,
        'parkYeriAd': parkYeriAd,
        'kisiAd': kisiAd,
        'telefon': telefon,
        'plaka': plaka,
        'tarih': tarih,
        'saat': saat,
        'sure': sure,
      };

  factory Rezervasyon.fromJson(Map<String, dynamic> json) => Rezervasyon(
        id: json['id'] as String,
        parkYeriId: json['parkYeriId'] as String,
        parkYeriAd: json['parkYeriAd'] as String,
        kisiAd: json['kisiAd'] as String,
        telefon: json['telefon'] as String,
        plaka: json['plaka'] as String,
        tarih: json['tarih'] as String,
        saat: json['saat'] as String,
        sure: json['sure'] as String,
      );
}
