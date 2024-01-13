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
          if (controller.notificationMessage != null) {
            final text = controller.notificationMessage!;
            WidgetsBinding.instance.addPostFrameCallback(
                (_) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(text),
                      key: const Key('notificationMessage'),
                    )));
            controller.clearNotification();
          }
          if (controller.isLoading) {
            return const CircularProgressIndicator(key: Key('loadingImage'));
          }
          if (controller.hasLoaded) {
            return Column(children: <Widget>[
              controller.qrCode!.image,
              ElevatedButton.icon(
                key: const Key("saveQrButton"),
                icon: const Icon(Icons.save),
                label: const Text('Save to Collection'),
                onPressed: () async {
                  controller.save(controller.qrCode!);
                },
              )
            ]);
          }
          return const SizedBox();
        });
  }
}
