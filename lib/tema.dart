import 'package:material_ui/material_ui.dart';

const _font = 'Atkinson Hyperlegible';

/// WCAG AA/AAA uyumlu standart açık tema.
ThemeData acikTema({bool altiCiziliBaglantilar = false}) {
  const birincil = Color(0xFF00695C);
  const birincilKoyu = Color(0xFF004D40);
  const metinKoyu = Color(0xFF1A2A27);

  return ThemeData(
    useMaterial3: true,
    fontFamily: _font,
    materialTapTargetSize: MaterialTapTargetSize.padded,
    colorScheme: ColorScheme.fromSeed(seedColor: birincil).copyWith(
      primary: birincil,
      onPrimary: Colors.white,
      surface: Colors.white,
      onSurface: metinKoyu,
    ),
    scaffoldBackgroundColor: const Color(0xFFF4F8F7),

    textTheme: _metinDuzeni(metinKoyu),

    // Klavye odağının her yerde belirgin olması için güçlü bir focus rengi.
    // (Material InkResponse, focused durumda bu rengi overlay olarak kullanır.)
    focusColor: const Color(0xFF26A69A).withValues(alpha: 0.55),

    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        minimumSize: const Size(88, 48),
        textStyle: _dugmeMetni(altiCiziliBaglantilar, false),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(88, 48),
        textStyle: _dugmeMetni(altiCiziliBaglantilar, false),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(88, 48),
        textStyle: _dugmeMetni(altiCiziliBaglantilar, false),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        minimumSize: const Size(88, 48),
        textStyle: _dugmeMetni(altiCiziliBaglantilar, true),
      ),
    ),

    inputDecorationTheme: _girdiDuzeni(birincil, birincilKoyu, metinKoyu),

    chipTheme: ChipThemeData(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      labelStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
      selectedColor: birincil,
      checkmarkColor: Colors.white,
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: birincil,
      foregroundColor: Colors.white,
      centerTitle: false,
    ),

    dividerColor: const Color(0xFFB2DFDB),
  );
}

/// Yüksek kontrast modu: siyah zemin, beyaz metin, canlı sarı vurgu.
/// WCAG AAA'ya yakın kontrast sağlar.
ThemeData yuksekKontrastTema({bool altiCiziliBaglantilar = false}) {
  const zemin = Color(0xFF000000);
  const yuzey = Color(0xFF121212);
  const metin = Colors.white;
  const vurgu = Color(0xFFFFEB3B); // canlı sarı

  return ThemeData(
    useMaterial3: true,
    fontFamily: _font,
    materialTapTargetSize: MaterialTapTargetSize.padded,
    colorScheme: const ColorScheme(
      brightness: Brightness.dark,
      primary: vurgu,
      onPrimary: Colors.black,
      secondary: vurgu,
      onSecondary: Colors.black,
      error: Color(0xFFFF6E40),
      onError: Colors.black,
      surface: yuzey,
      onSurface: metin,
    ),
    scaffoldBackgroundColor: zemin,
    canvasColor: zemin,
    cardColor: yuzey,

    textTheme: _metinDuzeni(metin),

    focusColor: vurgu.withValues(alpha: 0.6),

    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        minimumSize: const Size(88, 48),
        backgroundColor: vurgu,
        foregroundColor: Colors.black,
        textStyle: _dugmeMetni(altiCiziliBaglantilar, false),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(88, 48),
        backgroundColor: vurgu,
        foregroundColor: Colors.black,
        textStyle: _dugmeMetni(altiCiziliBaglantilar, false),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(88, 48),
        foregroundColor: vurgu,
        side: const BorderSide(color: vurgu, width: 2),
        textStyle: _dugmeMetni(altiCiziliBaglantilar, false),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        minimumSize: const Size(88, 48),
        foregroundColor: vurgu,
        textStyle: _dugmeMetni(altiCiziliBaglantilar, true),
      ),
    ),

    inputDecorationTheme: _girdiDuzeni(vurgu, vurgu, metin),

    chipTheme: const ChipThemeData(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      labelStyle: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w700,
        color: metin,
      ),
      selectedColor: vurgu,
      checkmarkColor: Colors.black,
      side: BorderSide(color: metin, width: 1.5),
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.black,
      foregroundColor: Colors.white,
      centerTitle: false,
    ),

    dividerColor: Colors.white54,
  );
}

/// Disleksi dostu: 1.6 satır aralığı ve ferah harf aralığı.
TextTheme _metinDuzeni(Color renk) {
  const h = 1.6; // line-height: 1.6
  TextStyle s(double boyut, {FontWeight w = FontWeight.w400}) => TextStyle(
        fontSize: boyut,
        height: h,
        letterSpacing: 0.15,
        fontWeight: w,
        color: renk,
      );

  return TextTheme(
    displayLarge: s(57, w: FontWeight.w700),
    displayMedium: s(45, w: FontWeight.w700),
    displaySmall: s(36, w: FontWeight.w700),
    headlineLarge: s(32, w: FontWeight.w700),
    headlineMedium: s(28, w: FontWeight.w700),
    headlineSmall: s(24, w: FontWeight.w700),
    titleLarge: s(22, w: FontWeight.w700),
    titleMedium: s(16, w: FontWeight.w600),
    titleSmall: s(14, w: FontWeight.w600),
    bodyLarge: s(16),
    bodyMedium: s(14),
    bodySmall: s(12),
    labelLarge: s(14, w: FontWeight.w600),
    labelMedium: s(12, w: FontWeight.w500),
    labelSmall: s(11, w: FontWeight.w500),
  );
}

TextStyle _dugmeMetni(bool altiCizili, bool yaziDugmesi) => TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w700,
      letterSpacing: 0.15,
      decoration: (altiCizili && yaziDugmesi)
          ? TextDecoration.underline
          : TextDecoration.none,
      decorationThickness: 2,
    );

InputDecorationTheme _girdiDuzeni(Color birincil, Color odakCizgisi, Color metin) =>
    InputDecorationTheme(
      filled: true,
      fillColor: Colors.transparent,
      labelStyle: TextStyle(color: metin),
      hintStyle: TextStyle(color: metin.withValues(alpha: 0.65)),
      // Klavye odağı 3px kalınlığında belirgin çerçeve ile gösterilir.
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: birincil.withValues(alpha: 0.6), width: 1.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: odakCizgisi, width: 3),
      ),
      errorBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(14)),
        borderSide: BorderSide(color: Colors.red, width: 2),
      ),
      focusedErrorBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(14)),
        borderSide: BorderSide(color: Colors.red, width: 3),
      ),
    );

/// Gri tonlama matrisi (luma katsayıları, Rec.709).
const List<double> griTonMatrisi = [
  0.2126, 0.7152, 0.0722, 0, 0,
  0.2126, 0.7152, 0.0722, 0, 0,
  0.2126, 0.7152, 0.0722, 0, 0,
  0, 0, 0, 1, 0,
];
