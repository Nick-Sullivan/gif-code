import 'package:flutter/material.dart';
import 'package:qr_gif/widgets/qr_code/qr_code_controller.dart';

class QrCodeView extends StatelessWidget {
  final QrCodeController controller;
  const QrCodeView({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
        listenable: controller,
        builder: (BuildContext context, Widget? child) {
          if (controller.isLoading) {
            return const CircularProgressIndicator(key: Key('loadingImage'));
          }
          if (controller.qrCode == null) {
            return const SizedBox();
          }
          return controller.qrCode!.image;
        });
  }
}
