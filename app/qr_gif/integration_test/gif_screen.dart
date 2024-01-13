import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qr_gif/main.dart';

void testGifScreen() {
  group('gif: ', () {
    testWidgets('when opened, it should not show a default image',
        (WidgetTester tester) async {
      await tester.pumpWidget(MyApp(configure: true));
      final qrCodeView = find.byKey(const Key('qrCodeView'));
      final qrCodeImage = find.descendant(
          of: qrCodeView, matching: find.byKey(const Key('qrCodeImage')));
      expect(qrCodeImage, findsNothing);
    });

    testWidgets('when entering text, it should show the text',
        (WidgetTester tester) async {
      await tester.pumpWidget(MyApp(configure: false));
      expect(find.text('Enter text'), findsOneWidget);
      final qrTextInput = find.byKey(const Key('qrText'));
      await tester.enterText(qrTextInput, "My text");
      await tester.pumpAndSettle();
      expect(find.text('My text'), findsOneWidget);
    });

    testWidgets('when clicking randomise, it should create a gif',
        (WidgetTester tester) async {
      await tester.pumpWidget(MyApp(configure: false));
      final gifInput = find.byKey(const Key('randomGifButton'));
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

    testWidgets('when clicking account, it should load the account screen',
        (WidgetTester tester) async {
      await tester.pumpWidget(MyApp(configure: false));

      final menuButton = find.byKey(const Key('popupMenuButton'));
      await tester.tap(menuButton);
      await tester.pumpAndSettle();

      final accountButton = find.byKey(const Key('accountMenuButton'));
      await tester.tap(accountButton);
      await tester.pumpAndSettle();

      final accountTitle = find.byKey(const Key('accountTitle'));
      expect(accountTitle, findsOneWidget);
    });
  });
}
