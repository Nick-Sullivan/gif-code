import 'package:flutter/material.dart';
import 'package:qr_gif/widgets/qr_creation/qr_text_view.dart';
import 'package:qr_gif/widgets/qr_creation/qr_creation_controller.dart';
import 'package:qr_gif/widgets/qr_code/qr_code_controller.dart';
import 'package:qr_gif/widgets/qr_code/qr_code_view.dart';
import 'package:get_it/get_it.dart';

class QrTextScreen extends StatelessWidget {
  final qrCodeController = QrCodeController();
  final qrCreationController = GetIt.instance<QrCreationController>();

  QrTextScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          QrTextView(
              qrCreationController: qrCreationController,
              qrCodeController: qrCodeController),
          QrCodeView(
              controller: qrCodeController, key: const Key('qrCodeView')),
        ],
      ),
    );
  }
}
