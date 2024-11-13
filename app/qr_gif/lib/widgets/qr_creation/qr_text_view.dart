import 'package:flutter/material.dart';
import 'package:qr_gif/widgets/qr_creation/qr_creation_controller.dart';
import 'package:qr_gif/widgets/qr_code/qr_code_controller.dart';

class QrTextView extends StatelessWidget {
  final QrCodeController qrCodeController;
  final QrCreationController qrCreationController;
  final _formKey = GlobalKey<FormState>();

  QrTextView(
      {super.key,
      required this.qrCreationController,
      required this.qrCodeController});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
        listenable: qrCreationController,
        builder: (BuildContext context, Widget? child) {
          return Form(
            key: _formKey,
            onChanged: () {
              qrCreationController
                  .setIsQrTextValid(_formKey.currentState!.validate());
            },
            child: Column(
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.all(20.0),
                  child: TextFormField(
                    key: const Key("qrText"),
                    controller: qrCreationController.qrTextController,
                    autofocus: true,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Text to encode",
                        contentPadding: EdgeInsets.all(20.0)),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter some text";
                      }
                      if (value.length > 65) {
                        return "Too many characters";
                      }
                      return null;
                    },
                  ),
                ),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  ElevatedButton.icon(
                    key: const Key("gifButton"),
                    icon: const Icon(Icons.build),
                    label: qrCreationController.isMediaSelected
                        ? const Text('Build')
                        : const Text("No GIF selected"),
                    onPressed: qrCreationController.isReadyToMake
                        ? () {
                            qrCodeController.createGif(
                                qrCreationController.mediaId!,
                                qrCreationController.qrText);
                          }
                        : null,
                  ),
                ]),
              ],
            ),
          );
        });
  }
}
