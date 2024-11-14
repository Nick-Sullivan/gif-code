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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ToggleButtons(
                      isSelected: [
                        !qrCreationController.isBoomerang,
                        qrCreationController.isBoomerang,
                      ],
                      onPressed: (index) => qrCreationController
                          .setIsBoomerang(index == 0 ? false : true),
                      children: const [
                        Icon(Icons.arrow_right_alt),
                        Icon(Icons.compare_arrows),
                      ],
                    ),
                    ToggleButtons(
                      isSelected: [
                        qrCreationController.qrTransparency ==
                            QrTransparencyLevel.veryTransparent,
                        qrCreationController.qrTransparency ==
                            QrTransparencyLevel.transparent,
                        qrCreationController.qrTransparency ==
                            QrTransparencyLevel.solid,
                      ],
                      onPressed: (int index) {
                        final selection = [
                          QrTransparencyLevel.veryTransparent,
                          QrTransparencyLevel.transparent,
                          QrTransparencyLevel.solid,
                        ][index];
                        qrCreationController.setQrTransparency(selection);
                      },
                      children: const <Widget>[
                        Opacity(opacity: 0.1, child: Icon(Icons.qr_code)),
                        Opacity(opacity: 0.5, child: Icon(Icons.qr_code)),
                        Opacity(opacity: 1.0, child: Icon(Icons.qr_code)),
                      ],
                    ),
                  ],
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
                              qrCreationController.qrText,
                              qrCreationController.qrTransparencyValue,
                              qrCreationController.isBoomerang,
                            );
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
