import 'package:flutter/material.dart';
import 'package:qr_gif/widgets/gif_form/gif_form_controller.dart';
import 'package:qr_gif/widgets/gif_form/gif_form_view.dart';
import 'package:qr_gif/widgets/qr_code/qr_code_controller.dart';
import 'package:qr_gif/widgets/qr_code/qr_code_view.dart';

class MakerScreen extends StatelessWidget {
  final qrCodeController = QrCodeController();
  final gifFormController = GifFormController();

  MakerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            GifFormView(
                gifFormController: gifFormController,
                qrCodeController: qrCodeController),
            QrCodeView(
                controller: qrCodeController, key: const Key('qrCodeView')),
          ],
        ),
      ),
    );
  }
}
