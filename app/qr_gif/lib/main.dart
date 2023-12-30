import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:qr_gif/infrastructure/cloud/giphy_api.dart';
import 'package:qr_gif/infrastructure/cloud/qr_code_api.dart';
import 'package:qr_gif/infrastructure/interfaces/giphy_api.dart';
import 'package:qr_gif/infrastructure/interfaces/qr_code_api.dart';
import 'package:qr_gif/screens/home_screen.dart';

final getIt = GetIt.instance;

void main() async {
  await dotenv.load(fileName: ".env.automated");

  final qrCodeApi = QrCodeApiInteractor(url: dotenv.env['API_GATEWAY_URL']!);
  final giphyApi = GiphyApiInteractor(apiKey: dotenv.env['GIPHY_API_KEY']!);
  getIt.registerSingleton<IQrCodeApiInteractor>(qrCodeApi);
  getIt.registerSingleton<IGiphyApiInteractor>(giphyApi);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GIF Code',
      initialRoute: '/home',
      routes: {
        '/home': (context) => HomeScreen(),
      },
    );
  }
}
