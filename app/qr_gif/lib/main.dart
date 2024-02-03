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

  MyApp({super.key, this.initialRoute = '/make', this.configure = true});

  @override
  Widget build(BuildContext context) {
    if (configure) {
      // Disabling, no account login needed for right now.
      // authController.configureAmplify();
    }
    return MaterialApp(
      title: 'GIF Code',
      initialRoute: initialRoute,
      theme: createLightTheme(),
      darkTheme: createDarkTheme(),
      routes: {
        '/make': (context) => const HomeScreen(initialTab: 0),
        '/collect': (context) => const HomeScreen(initialTab: 1),
      },
    );
  }

  ThemeData createLightTheme() {
    return FlexThemeData.light(
      scheme: FlexScheme.damask,
      surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
      blendLevel: 7,
      subThemesData: const FlexSubThemesData(
        blendOnLevel: 10,
        blendOnColors: false,
        useTextTheme: true,
        useM2StyleDividerInM3: true,
        useInputDecoratorThemeInDialogs: true,
      ),
      visualDensity: FlexColorScheme.comfortablePlatformDensity,
      useMaterial3: true,
      swapLegacyOnMaterial3: true,
      // To use the Playground font, add GoogleFonts package and uncomment
      // fontFamily: GoogleFonts.notoSans().fontFamily,
    );
  }

  ThemeData createDarkTheme() {
    return FlexThemeData.dark(
      scheme: FlexScheme.damask,
      surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
      blendLevel: 13,
      subThemesData: const FlexSubThemesData(
        blendOnLevel: 20,
        useTextTheme: true,
        useM2StyleDividerInM3: true,
        useInputDecoratorThemeInDialogs: true,
      ),
      visualDensity: FlexColorScheme.comfortablePlatformDensity,
      useMaterial3: true,
      swapLegacyOnMaterial3: true,
      // To use the Playground font, add GoogleFonts package and uncomment
      // fontFamily: GoogleFonts.notoSans().fontFamily,
    );
  }
}
