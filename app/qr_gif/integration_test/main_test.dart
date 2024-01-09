import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:integration_test/integration_test.dart';
import 'package:qr_gif/main.dart';
import 'account_screen.dart';
import 'gif_screen.dart';

void main() async {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env.automated");
  final username = dotenv.env['AUTOMATED_TESTER_USERNAME']!;
  final password = dotenv.env['AUTOMATED_TESTER_PASSWORD']!;
  await setupSingletons();

  testGifScreen();
  testAccountScreen(username, password);
}
