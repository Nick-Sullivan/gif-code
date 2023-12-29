import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:qr_gif/infrastructure/interfaces/giphy_api.dart';
import 'package:qr_gif/infrastructure/interfaces/qr_code_api.dart';
import 'package:qr_gif/widgets/qr_code/qr_code_controller.dart';
import 'package:qr_gif/widgets/qr_code/qr_code_view.dart';

final getIt = GetIt.instance;

class HomeScreen extends StatelessWidget {
  final IQrCodeApiInteractor qrApi = getIt<IQrCodeApiInteractor>();
  final IGiphyApiInteractor giphyApi = getIt<IGiphyApiInteractor>();
  final QrCodeController qrCodeController = QrCodeController();
  final TextEditingController textController = TextEditingController();

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: buildAppBar(context),
      body: buildBody(context),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      leading: const Image(image: AssetImage("assets/images/flutter_logo.png")),
      title: const Text('QR GIF'),
      backgroundColor: Theme.of(context).primaryColor,
    );
  }

  Widget buildBody(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(20.0),
              child: TextField(
                controller: textController..text = "Hello from QR GIF!",
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Enter text",
                    contentPadding: EdgeInsets.all(20.0)),
              ),
            ),
            TextButton(
              child: const Text('SELECT GIF'),
              onPressed: () async {
                final gif = await giphyApi.create(context);
                if (gif != null) {
                  qrCodeController.isLoading = true;
                  final newQr = await qrApi.create(gif.id, textController.text);
                  qrCodeController.isLoading = false;
                  qrCodeController.qrCode = newQr;
                }
              },
            ),
            QrCodeView(controller: qrCodeController),
          ],
        ),
      ),
    );
  }
}
