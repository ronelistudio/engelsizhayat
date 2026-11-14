/// Engelli bireyler için erişilebilir bir otoparkı temsil eder.
class ParkYeri {
  final String id;
  final String ad;
  final String adres;
  final double mesafeKm;
  final int toplamEngelliYeri;
  final int bosYer;
  final double puan;
  final String ucret; // Örnek: "₺25 / saat" veya "Ücretsiz"
  final String calismaSaatleri;
  final List<String> ozellikler;

  const ParkYeri({
    required this.id,
    required this.ad,
    required this.adres,
    required this.mesafeKm,
    required this.toplamEngelliYeri,
    required this.bosYer,
    required this.puan,
    required this.ucret,
    required this.calismaSaatleri,
    required this.ozellikler,
  });

  bool get ucretsiz => ucret.toLowerCase() == 'ücretsiz';
  int get doluYer => toplamEngelliYeri - bosYer;
  double get dolulukOrani =>
      toplamEngelliYeri == 0 ? 0 : doluYer / toplamEngelliYeri;
}
