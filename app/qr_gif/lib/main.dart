import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:qr_gif/infrastructure/cloud/amplify_auth.dart';
import 'package:qr_gif/infrastructure/cloud/giphy_api.dart';
import 'package:qr_gif/infrastructure/cloud/qr_code_store.dart';
import 'package:qr_gif/infrastructure/cloud/qr_code_api.dart';
import 'package:qr_gif/infrastructure/interfaces/amplify_auth.dart';
import 'package:qr_gif/infrastructure/interfaces/giphy_api.dart';
import 'package:qr_gif/infrastructure/interfaces/qr_code_store.dart';
import 'package:qr_gif/infrastructure/interfaces/qr_code_api.dart';
import 'package:qr_gif/screens/account_screen.dart';
import 'package:qr_gif/screens/collection_list_screen.dart';
import 'package:qr_gif/screens/home_screen.dart';
import 'package:qr_gif/widgets/auth/auth_controller.dart';
import 'package:qr_gif/widgets/collection/collection_controller.dart';

void main() async {
  await setupSingletons();
  runApp(MyApp());
}

Future<void> setupSingletons() async {
  await dotenv.load(fileName: ".env.automated");
  final qrCodeApi = QrCodeApiInteractor(url: dotenv.env['API_GATEWAY_URL']!);
  final giphyApi = GiphyApiInteractor(apiKey: dotenv.env['GIPHY_API_KEY']!);
  GetIt.I.registerSingleton<IQrCodeApiInteractor>(qrCodeApi);
  GetIt.I.registerSingleton<IGiphyApiInteractor>(giphyApi);
  GetIt.I.registerSingleton<IQrCodeStore>(QrCodeStore());
  GetIt.I.registerSingleton<IAmplifyAuthenticator>(AmplifyAuthenticator());
  GetIt.I.registerSingleton<AuthController>(AuthController());
  final collectionController = CollectionController();
  await collectionController.loadCollection();
  GetIt.I.registerSingleton<CollectionController>(collectionController);
}

class MyApp extends StatelessWidget {
  final String initialRoute;
  final bool configure;
  final authController = GetIt.instance<AuthController>();

  MyApp({super.key, this.initialRoute = '/home', this.configure = true});

  @override
  Widget build(BuildContext context) {
    if (configure) {
      authController.configureAmplify();
    }
    const scheme = FlexScheme.bigStone;
    return MaterialApp(
      title: 'GIF Code',
      initialRoute: initialRoute,
      theme: FlexThemeData.light(scheme: scheme),
      darkTheme: FlexThemeData.dark(scheme: scheme),
      color: Colors.black,
      routes: {
        '/home': (context) => HomeScreen(),
        '/account': (context) => AccountScreen(),
        '/collection': (context) => CollectionListScreen(),
      },
    );
  }
}
