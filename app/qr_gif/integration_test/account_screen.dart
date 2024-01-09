import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qr_gif/main.dart';

void testAccountScreen(String username, String password) {
  group('account: ', () {
    testWidgets('when opened, it should show the sign up screen',
        (WidgetTester tester) async {
      await tester
          .pumpWidget(MyApp(configure: false, initialRoute: '/account'));
      final signUpView = find.byKey(const Key('signUpView'));
      expect(signUpView, findsOneWidget);
    });

    testWidgets('when logging in with bad details, it should error',
        (WidgetTester tester) async {
      await tester
          .pumpWidget(MyApp(configure: false, initialRoute: '/account'));
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
      await tester
          .pumpWidget(MyApp(configure: false, initialRoute: '/account'));
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
      await tester
          .pumpWidget(MyApp(configure: false, initialRoute: '/account'));
      final signedInView = find.byKey(const Key('signedInView'));
      expect(signedInView, findsOneWidget);
    });

    testWidgets('when logging out, it should should the sign up screen',
        (WidgetTester tester) async {
      await tester
          .pumpWidget(MyApp(configure: false, initialRoute: '/account'));
      final signOutButton = find.byKey(const Key('signOutButton'));
      await tester.tap(signOutButton);
      await tester.pumpAndSettle();
      // final signUpView = find.byKey(const Key('signUpView'));
      // expect(signUpView, findsOneWidget);
    });
  });
}
