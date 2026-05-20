import 'package:flutter_test/flutter_test.dart';
import 'package:rescuea_miniapp/main.dart';

void main() {
  testWidgets('App should build', (WidgetTester tester) async {
    await tester.pumpWidget(const RescueaApp());
    expect(find.text('SAA 吉诺道路救援'), findsOneWidget);
  });
}
