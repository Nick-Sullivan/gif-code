import 'package:flutter/material.dart';
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
      final item = find.text('Default name');
      expect(item, findsWidgets);
    });

    testWidgets('when tapping the item, it should show item detail screen',
        (WidgetTester tester) async {
      await tester
          .pumpWidget(MyApp(configure: false, initialRoute: '/collection'));
      final item = find.text('Default name').first;
      await tester.tap(item);
      await tester.pumpAndSettle();
      final collectionItemView = find.byKey(const Key('collectionItemView'));
      expect(collectionItemView, findsOneWidget);
    });
  });
}
