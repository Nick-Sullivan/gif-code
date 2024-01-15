import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qr_gif/main.dart';

void testCollectionItemScreen() {
  group('collectionItem: ', () {
    testWidgets('when opening, it should show the QR code',
        (WidgetTester tester) async {
      await tester
          .pumpWidget(MyApp(configure: false, initialRoute: '/collect'));
      final item = find.text('My text').first;
      await tester.tap(item);
      await tester.pumpAndSettle();
      final qrCodeImage = find.byKey(const Key('qrCodeImage'));
      expect(qrCodeImage, findsOneWidget);
    });

    testWidgets('when deleting, it should return to the list screen',
        (WidgetTester tester) async {
      await tester
          .pumpWidget(MyApp(configure: false, initialRoute: '/collect'));
      final item = find.text('My text').first;
      await tester.tap(item);
      await tester.pumpAndSettle();

      final menuButton = find.byKey(const Key('menuButton'));
      await tester.tap(menuButton);
      await tester.pumpAndSettle();

      final deleteButton = find.text('Delete');
      await tester.tap(deleteButton);
      await tester.pumpAndSettle();

      final confirmDeleteButton = find.byKey(const Key('confirmDeleteButton'));
      await tester.tap(confirmDeleteButton);
      await tester.pumpAndSettle();

      final itemAfter = find.text('Default name');
      expect(itemAfter, findsNothing);
    });
  });
}
