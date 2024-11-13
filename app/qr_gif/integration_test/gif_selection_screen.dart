import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qr_gif/main.dart';

void testGifSelectionScreen() {
  group('gifSelection: ', () {
    testWidgets('when opened, text should be empty',
        (WidgetTester tester) async {
      await tester.pumpWidget(MyApp(configure: true));
      final gifTextInput = find.byKey(const Key('gifText'));
      await tester.pumpAndSettle();
      final text = tester.widget<TextField>(gifTextInput).controller?.text;
      expect(text, "");
    });
  });
}
