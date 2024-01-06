import 'package:flutter/material.dart';
import 'package:qr_gif/widgets/qr_code/qr_code_controller.dart';

class QrCodeView extends StatefulWidget {
  final QrCodeController controller;
  const QrCodeView({super.key, required this.controller});

  @override
  State<QrCodeView> createState() => _QrCodeViewState();
}

class _QrCodeViewState extends State<QrCodeView> {
  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
        listenable: widget.controller,
        builder: (BuildContext context, Widget? child) {
          if (widget.controller.isLoading) {
            return const CircularProgressIndicator(key: Key('loadingImage'));
          }
          if (widget.controller.qrCode == null) {
            return const SizedBox();
          }
          return widget.controller.qrCode!.image;
        });
  }
}
