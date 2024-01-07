import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:qr_gif/infrastructure/cloud/amplify_auth.dart';
import 'package:qr_gif/infrastructure/cloud/giphy_api.dart';
import 'package:qr_gif/infrastructure/cloud/qr_code_api.dart';
import 'package:qr_gif/infrastructure/interfaces/amplify_auth.dart';
import 'package:qr_gif/infrastructure/interfaces/giphy_api.dart';
import 'package:qr_gif/infrastructure/interfaces/qr_code_api.dart';
import 'package:qr_gif/screens/account_screen.dart';
import 'package:qr_gif/screens/home_screen.dart';
import 'package:qr_gif/widgets/auth/auth_controller.dart';
import 'amplifyconfiguration.dart';

final getIt = GetIt.instance;

void main() async {
  await setupSingletons();
  final authController = AuthController();
  await setupAmplify(authController);
  runApp(MyApp(authController: authController));
}

Future<void> setupSingletons() async {
  await dotenv.load(fileName: ".env.automated");
  final qrCodeApi = QrCodeApiInteractor(url: dotenv.env['API_GATEWAY_URL']!);
  final giphyApi = GiphyApiInteractor(apiKey: dotenv.env['GIPHY_API_KEY']!);
  final amplifyAuth = AmplifyAuthenticator();
  getIt.registerSingleton<IQrCodeApiInteractor>(qrCodeApi);
  getIt.registerSingleton<IGiphyApiInteractor>(giphyApi);
  getIt.registerSingleton<IAmplifyAuthenticator>(amplifyAuth);
}

Future<void> setupAmplify(AuthController authController) async {
  try {
    final auth = AmplifyAuthCognito();
    await Amplify.addPlugin(auth);
    try {
      await Amplify.configure(amplifyconfig);
    } on AmplifyAlreadyConfiguredException catch (e) {
      debugPrint(e.message);
    }
    // await widget.authController.signInUserIfCredentialsSaved();
    await authController.loadUserDetailsIfSignedIn();
  } on Exception catch (e) {
    safePrint('An error occurred configuring Amplify: $e');
  }
}

class MyApp extends StatefulWidget {
  final AuthController authController;
  final String initialRoute;

  const MyApp(
      {super.key, required this.authController, this.initialRoute = '/home'});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    // _configureAmplify();
  }

  // Future<void> _configureAmplify() async {
  //   try {
  //     final auth = AmplifyAuthCognito();
  //     await Amplify.addPlugin(auth);
  //     try {
  //       await Amplify.configure(amplifyconfig);
  //     } on AmplifyAlreadyConfiguredException catch (e) {
  //       debugPrint(e.message);
  //     }
  //     // await widget.authController.signInUserIfCredentialsSaved();
  //     await widget.authController.loadUserDetailsIfSignedIn();
  //     safePrint('Successfully configured');
  //   } on Exception catch (e) {
  //     safePrint('An error occurred configuring Amplify: $e');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GIF Code',
      initialRoute: widget.initialRoute,
      color: Colors.black,
      routes: {
        '/home': (context) => HomeScreen(authController: widget.authController),
        '/account': (context) =>
            AccountScreen(authController: widget.authController),
      },
    );
  }
}
