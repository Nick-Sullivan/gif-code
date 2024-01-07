import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:integration_test/integration_test.dart';
import 'package:qr_gif/main.dart';
import 'package:qr_gif/widgets/auth/auth_controller.dart';

final getIt = GetIt.instance;

void main() {
  late String username;
  late String password;
  late AuthController authController;

  setUpAll(() async {
    IntegrationTestWidgetsFlutterBinding.ensureInitialized();
    await dotenv.load(fileName: ".env.automated");
    username = dotenv.env['AUTOMATED_TESTER_USERNAME']!;
    password = dotenv.env['AUTOMATED_TESTER_PASSWORD']!;
    await setupSingletons();
    authController = AuthController();
    await setupAmplify(authController);
  });

  testWidgets('when opened, it should show the sign up screen',
      (WidgetTester tester) async {
    await tester.pumpWidget(
        MyApp(authController: authController, initialRoute: '/account'));
    final signUpView = find.byKey(const Key('signUpView'));
    expect(signUpView, findsOneWidget);
  });

  testWidgets('when logging in with bad details, it should error',
      (WidgetTester tester) async {
    await tester.pumpWidget(
        MyApp(authController: authController, initialRoute: '/account'));
    final emailText = find.byKey(const Key('emailText'));
    await tester.enterText(emailText, 'bad@test.com');
    final passwordText = find.byKey(const Key('passwordText'));
    await tester.enterText(passwordText, 'password');
    final signInButton = find.byKey(const Key('signInButton'));
    await tester.tap(signInButton);
    await tester.pumpAndSettle();
    final errorMessage = find.byKey(const Key('errorMessage'));
    expect(errorMessage, findsOneWidget);
  });

  testWidgets('when logging in, it should should the signed in screen',
      (WidgetTester tester) async {
    await tester.pumpWidget(
        MyApp(authController: authController, initialRoute: '/account'));
    final emailText = find.byKey(const Key('emailText'));
    await tester.enterText(emailText, username);
    final passwordText = find.byKey(const Key('passwordText'));
    await tester.enterText(passwordText, password);
    final signInButton = find.byKey(const Key('signInButton'));
    await tester.tap(signInButton);
    await tester.pumpAndSettle();
    final signedInView = find.byKey(const Key('signedInView'));
    expect(signedInView, findsOneWidget);
  });

  testWidgets(
      'when opened after logging in, it should should the signed in screen',
      (WidgetTester tester) async {
    await tester.pumpWidget(
        MyApp(authController: authController, initialRoute: '/account'));
    final signedInView = find.byKey(const Key('signedInView'));
    expect(signedInView, findsOneWidget);
  });
}
