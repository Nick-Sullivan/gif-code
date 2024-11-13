import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qr_gif/main.dart';

void testQrTextScreen() {
  group('qrText: ', () {
    testWidgets('when opened, it should not show a default image',
        (WidgetTester tester) async {
      await tester.pumpWidget(MyApp(configure: false, initialRoute: '/qr'));
      final qrCodeView = find.byKey(const Key('qrCodeView'));
      final qrCodeImage = find.descendant(
          of: qrCodeView, matching: find.byKey(const Key('qrCodeImage')));
      expect(qrCodeImage, findsNothing);
    });

    testWidgets('when text is empty, it should show an error',
        (WidgetTester tester) async {
      await tester.pumpWidget(MyApp(configure: false, initialRoute: '/qr'));
      final qrTextInput = find.byKey(const Key('qrText'));
      await tester.enterText(qrTextInput, "something");
      await tester.enterText(qrTextInput, "");
      await tester.pumpAndSettle();
      final textError = find.text('Please enter some text');
      expect(textError, findsOneWidget);
    });

    testWidgets('when text is too long, it should show an error',
        (WidgetTester tester) async {
      await tester.pumpWidget(MyApp(configure: false, initialRoute: '/qr'));
      final qrTextInput = find.byKey(const Key('qrText'));
      await tester.enterText(qrTextInput, "a" * 70);
      await tester.pumpAndSettle();
      final textError = find.text('Too many characters');
      expect(textError, findsOneWidget);
    });

    testWidgets('when erroring, buttons should be disabled',
        (WidgetTester tester) async {
      await tester.pumpWidget(MyApp(configure: false, initialRoute: '/qr'));
      final qrTextInput = find.byKey(const Key('qrText'));
      await tester.enterText(qrTextInput, "a" * 70);
      await tester.pumpAndSettle();
      final gifInput = find.byKey(const Key('gifButton'));
      final isEnabled = tester.widget<ElevatedButton>(gifInput).enabled;
      expect(isEnabled, isFalse);
    });

    testWidgets('when entering text, it should show the text',
        (WidgetTester tester) async {
      await tester.pumpWidget(MyApp(configure: false, initialRoute: '/qr'));
      final qrTextInput = find.byKey(const Key('qrText'));
      await tester.enterText(qrTextInput, "My text");
      await tester.pumpAndSettle();
      expect(find.text('My text'), findsOneWidget);
    });

    testWidgets('when no media is selected, buttons should be disabled',
        (WidgetTester tester) async {
      await tester.pumpWidget(MyApp(configure: false, initialRoute: '/qr'));
      final gifInput = find.byKey(const Key('gifButton'));
      final isEnabled = tester.widget<ElevatedButton>(gifInput).enabled;
      expect(isEnabled, isFalse);
    });

    testWidgets('when clicking build, it should create a gif',
        (WidgetTester tester) async {
      await tester.pumpWidget(MyApp(
          configure: false,
          initialRoute: '/qr',
          initialSelectedMediaId: "gw3IWyGkC0rsazTi"));

      expect(find.text('Text to encode'), findsOneWidget);
      final qrTextInput = find.byKey(const Key('qrText'));
      await tester.enterText(qrTextInput, "My text");
      await tester.pumpAndSettle();

      FocusScope.of(tester.element(qrTextInput)).unfocus();
      await tester.pumpAndSettle();

      final gifInput = find.byKey(const Key('gifButton'));
      await tester.tap(gifInput);
      await tester.pumpAndSettle();

      final qrCodeView = find.byKey(const Key('qrCodeView'));
      final qrCodeImage = find.descendant(
          of: qrCodeView, matching: find.byKey(const Key('qrCodeImage')));
      expect(qrCodeImage, findsOneWidget);

      final saveInput = find.byKey(const Key('saveQrButton'));
      await tester.tap(saveInput);
      await tester.pumpAndSettle();

      final saveNotification = find.byKey(const Key('notificationMessage'));
      expect(saveNotification, findsOneWidget);
    });
  });
}
