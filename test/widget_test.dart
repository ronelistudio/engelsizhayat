import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:engelsiz_yasam/main.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('Giriş ekranı açılır ve karşılama gösterilir', (tester) async {
    await tester.pumpWidget(const EngelsizYasamApp());
    await tester.pumpAndSettle();

    expect(find.text('Engelsiz Yaşam'), findsWidgets);
    expect(find.text('Giriş Yap'), findsWidgets);
    expect(find.textContaining('demo@engelsiz.com'), findsOneWidget);
  });
}
