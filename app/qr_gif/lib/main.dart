import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:giphy_flutter_sdk/giphy_flutter_sdk.dart';
import 'package:qr_gif/infrastructure/cloud/amplify_auth.dart';
import 'package:qr_gif/infrastructure/cloud/qr_code_store.dart';
import 'package:qr_gif/infrastructure/cloud/qr_code_api.dart';
import 'package:qr_gif/infrastructure/interfaces/amplify_auth.dart';
import 'package:qr_gif/infrastructure/interfaces/qr_code_store.dart';
import 'package:qr_gif/infrastructure/interfaces/qr_code_api.dart';
import 'package:qr_gif/screens/home_screen.dart';
import 'package:qr_gif/widgets/auth/auth_controller.dart';
import 'package:qr_gif/widgets/collection/collection_controller.dart';
import 'package:qr_gif/widgets/qr_creation/qr_creation_controller.dart';
import 'package:qr_gif/widgets/tab/vsync.dart';
import 'dart:io';

void main() async {
  await setupSingletons();
  runApp(MyApp());
}

Future<void> setupSingletons() async {
  await dotenv.load(fileName: ".env.automated");
  final qrCodeApi = QrCodeApiInteractor(url: dotenv.env['API_GATEWAY_URL']!);
  // This app doesn't support windows, but it's used for testing because I couldn't
  // find an easy/reliable way to test on an emulator in the CICD pipeline.
  if (!Platform.isWindows) {
    GiphyFlutterSDK.configure(apiKey: dotenv.env['GIPHY_API_KEY']!);
  }
  GetIt.I.registerSingleton<IQrCodeApiInteractor>(qrCodeApi);
  GetIt.I.registerSingleton<IQrCodeStore>(QrCodeStore());
  GetIt.I.registerSingleton<IAmplifyAuthenticator>(AmplifyAuthenticator());
  GetIt.I.registerSingleton<AuthController>(AuthController());
  GetIt.I.registerSingleton<QrCreationController>(QrCreationController());
  final collectionController = CollectionController();
  await collectionController.loadCollection();
  GetIt.I.registerSingleton<CollectionController>(collectionController);
}

class MyApp extends StatelessWidget {
  final String initialRoute;
  final bool configure;
  final authController = GetIt.instance<AuthController>();

  MyApp({
    super.key,
    this.initialRoute = '/gif',
    this.configure = true,
    String? initialSelectedMediaId,
  }) {
    final qrCreationController = GetIt.instance<QrCreationController>();
    qrCreationController.setMediaId(initialSelectedMediaId);
  }

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
        '/gif': (context) => HomeScreen(tabController: createTabController(0)),
        '/qr': (context) => HomeScreen(tabController: createTabController(1)),
        '/collection': (context) =>
            HomeScreen(tabController: createTabController(2)),
      },
    );
  }

  TabController createTabController(int initialIndex) {
    return TabController(
      length: 3,
      vsync: const VSync(),
      initialIndex: initialIndex,
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
        useMaterial3Typography: true,
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
        useMaterial3Typography: true,
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
