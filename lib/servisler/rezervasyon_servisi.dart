import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/rezervasyon.dart';

/// Rezervasyonları cihazda (shared_preferences ile) kalıcı olarak saklar.
/// İleride bu sınıf yerine gerçek bir backend API çağrısına geçilecektir.
class RezervasyonServisi {
  static const _anahtar = 'rezervasyonlar';

  Future<List<Rezervasyon>> getir() async {
    final prefs = await SharedPreferences.getInstance();
    final ham = prefs.getString(_anahtar);
    if (ham == null || ham.isEmpty) return [];
    final List<dynamic> decoded = jsonDecode(ham) as List<dynamic>;
    return decoded
        .map((e) => Rezervasyon.fromJson(e as Map<String, dynamic>))
        .toList()
      ..sort((a, b) => b.id.compareTo(a.id)); // yeni kayıtlar üstte
  }

  Future<void> ekle(Rezervasyon rezervasyon) async {
    final liste = await _getirHam();
    liste.add(rezervasyon.toJson());
    await _kaydet(liste);
  }

  Future<void> sil(String id) async {
    final liste = await _getirHam();
    liste.removeWhere((e) => e['id'] == id);
    await _kaydet(liste);
  }

  Future<List<Map<String, dynamic>>> _getirHam() async {
    final prefs = await SharedPreferences.getInstance();
    final ham = prefs.getString(_anahtar);
    if (ham == null || ham.isEmpty) return [];
    return (jsonDecode(ham) as List<dynamic>)
        .map((e) => Map<String, dynamic>.from(e as Map))
        .toList();
  }

  Future<void> _kaydet(List<Map<String, dynamic>> liste) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_anahtar, jsonEncode(liste));
  }
}
