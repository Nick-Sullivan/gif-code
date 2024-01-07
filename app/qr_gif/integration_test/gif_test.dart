import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:integration_test/integration_test.dart';
import 'package:qr_gif/main.dart';
import 'package:qr_gif/widgets/auth/auth_controller.dart';

final getIt = GetIt.instance;

void main() {
  setUpAll(() async {
    IntegrationTestWidgetsFlutterBinding.ensureInitialized();
    await setupSingletons();
  });

  testWidgets('when opened, it should not show a default image',
      (WidgetTester tester) async {
    await tester.pumpWidget(MyApp(authController: AuthController()));
    final qrCodeView = find.byKey(const Key('qrCodeView'));
    final qrCodeImage = find.descendant(
        of: qrCodeView, matching: find.byKey(const Key('qrCodeImage')));
    expect(qrCodeImage, findsNothing);
  });

  testWidgets('when entering text, it should show the text',
      (WidgetTester tester) async {
    await tester.pumpWidget(MyApp(authController: AuthController()));
    expect(find.text('Enter text'), findsOneWidget);
    final qrTextInput = find.byKey(const Key('qrText'));
    await tester.enterText(qrTextInput, "My text");
    await tester.pumpAndSettle();
    expect(find.text('My text'), findsOneWidget);
  });

  testWidgets('when clicking randomise, it should create a gif',
      (WidgetTester tester) async {
    await tester.pumpWidget(MyApp(authController: AuthController()));
    final gifInput = find.byKey(const Key('randomGifButton'));
    await tester.tap(gifInput);
    await tester.pumpAndSettle();
    final qrCodeView = find.byKey(const Key('qrCodeView'));
    final qrCodeImage = find.descendant(
        of: qrCodeView, matching: find.byKey(const Key('qrCodeImage')));
    expect(qrCodeImage, findsOneWidget);
  });

  testWidgets('when clicking account, it should load the account screen',
      (WidgetTester tester) async {
    await tester.pumpWidget(MyApp(authController: AuthController()));

    final menuButton = find.byKey(const Key('popupMenuButton'));
    await tester.tap(menuButton);
    await tester.pumpAndSettle();

    final accountButton = find.byKey(const Key('accountMenuButton'));
    await tester.tap(accountButton);
    await tester.pumpAndSettle();

    final accountTitle = find.byKey(const Key('accountTitle'));
    expect(accountTitle, findsOneWidget);
  });
}
