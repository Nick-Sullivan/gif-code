import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qr_gif/main.dart';

void testCollectionListScreen() {
  group('collectionList: ', () {
    testWidgets('when opened, it should show the collection list screen',
        (WidgetTester tester) async {
      await tester
          .pumpWidget(MyApp(configure: false, initialRoute: '/collection'));
      final collectionView = find.byKey(const Key('collectionView'));
      expect(collectionView, findsOneWidget);
    });

    testWidgets('when opened, it should show the saved item',
        (WidgetTester tester) async {
      await tester
          .pumpWidget(MyApp(configure: false, initialRoute: '/collection'));
      await tester.pumpAndSettle();
      final item = find.text('My text');
      expect(item, findsWidgets);
    });

    testWidgets('when long pressing an item, it should copy the text',
        (WidgetTester tester) async {
      await tester
          .pumpWidget(MyApp(configure: false, initialRoute: '/collection'));
      await tester.pumpAndSettle();
      final item = find.text('My text').first;
      await tester.longPress(item);
      await tester.pumpAndSettle();

      final clipboardData = await Clipboard.getData(Clipboard.kTextPlain);
      expect(clipboardData!.text, 'My text');
    });

    testWidgets('when long pressing an item, it should show a notification',
        (WidgetTester tester) async {
      await tester
          .pumpWidget(MyApp(configure: false, initialRoute: '/collection'));
      await tester.pumpAndSettle();
      final item = find.text('My text').first;
      await tester.longPress(item);
      await tester.pumpAndSettle();

      final notification = find.text('Text copied.');
      expect(notification, findsOneWidget);
    });

    testWidgets('when tapping the item, it should show item detail screen',
        (WidgetTester tester) async {
      await tester
          .pumpWidget(MyApp(configure: false, initialRoute: '/collection'));
      final item = find.text('My text').first;
      await tester.tap(item);
      await tester.pumpAndSettle();
      final collectionItemView = find.byKey(const Key('collectionItemView'));
      expect(collectionItemView, findsOneWidget);
    });
  });
}
