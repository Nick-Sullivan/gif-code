import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:qr_gif/main.dart';
import 'collection_item_screen.dart';
import 'collection_list_screen.dart';
import 'gif_selection_screen.dart';
import 'qr_text_screen.dart';

void main() async {
  await dotenv.load(fileName: ".env.automated");
  // final username = dotenv.env['AUTOMATED_TESTER_USERNAME']!;
  // final password = dotenv.env['AUTOMATED_TESTER_PASSWORD']!;

  setUpAll(() async {
    IntegrationTestWidgetsFlutterBinding.ensureInitialized();
    await setupSingletons();
  });

  // Disabling, no account login needed for right now.
  // testAccountScreen(username, password);
  testGifSelectionScreen();
  testQrTextScreen();
  testCollectionListScreen();
  testCollectionItemScreen();
}
