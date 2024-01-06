import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:qr_gif/infrastructure/cloud/giphy_api.dart';
import 'package:qr_gif/infrastructure/cloud/qr_code_api.dart';
import 'package:qr_gif/infrastructure/interfaces/giphy_api.dart';
import 'package:qr_gif/infrastructure/interfaces/qr_code_api.dart';
import 'package:qr_gif/main.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

void main() {
  bool isSetUp = false;

  setup() async {
    if (isSetUp) return;
    await dotenv.load(fileName: ".env.automated");
    final qrCodeApi = QrCodeApiInteractor(url: dotenv.env['API_GATEWAY_URL']!);
    final giphyApi = GiphyApiInteractor(apiKey: dotenv.env['GIPHY_API_KEY']!);
    getIt.registerSingleton<IQrCodeApiInteractor>(qrCodeApi);
    getIt.registerSingleton<IGiphyApiInteractor>(giphyApi);
    isSetUp = true;
  }

  testWidgets('when opened, it should not show a default image',
      (WidgetTester tester) async {
    await setup();
    await tester.pumpWidget(const MyApp());
    final qrCodeView = find.byKey(const Key('qrCodeView'));
    final defaultImage = find.descendant(
        of: qrCodeView, matching: find.byKey(const Key('defaultImage')));
    expect(defaultImage, findsNothing);
  });

  testWidgets('when entering text, it should show the text',
      (WidgetTester tester) async {
    await setup();
    await tester.pumpWidget(const MyApp());
    expect(find.text('Enter text'), findsOneWidget);
    final qrTextInput = find.byKey(const Key('qrText'));
    await tester.enterText(qrTextInput, "My text");
    await tester.pumpAndSettle();
    expect(find.text('My text'), findsOneWidget);
  });

  testWidgets('when clicking randomise, it should create a gif',
      (WidgetTester tester) async {
    await setup();
    await tester.pumpWidget(const MyApp());
    final gifInput = find.byKey(const Key('randomGifButton'));
    await tester.tap(gifInput);
    await tester.pumpAndSettle();
    final qrCodeView = find.byKey(const Key('qrCodeView'));
    final qrCodeImage = find.descendant(
        of: qrCodeView, matching: find.byKey(const Key('qrCodeImage')));
    expect(qrCodeImage, findsOneWidget);
  });
}
