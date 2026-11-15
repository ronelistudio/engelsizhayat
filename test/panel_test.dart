import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:engelsiz_yasam/main.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('Giriş yapılır ve panel açılır', (tester) async {
    await tester.pumpWidget(const EngelsizYasamApp());
    await tester.pumpAndSettle();

    final alanlar = find.byType(TextField);
    await tester.enterText(alanlar.at(0), 'demo@engelsiz.com');
    await tester.enterText(alanlar.at(1), '123456');
    await tester.pumpAndSettle();

    await tester.tap(find.text('Giriş Yap').last);
    await tester.pumpAndSettle(const Duration(seconds: 2));

    expect(find.text('Ana Menü'), findsWidgets);
    expect(find.text('Rezervasyonlarım'), findsWidgets);
    expect(find.text('Demo Kullanıcı'), findsWidgets);
  });
}
