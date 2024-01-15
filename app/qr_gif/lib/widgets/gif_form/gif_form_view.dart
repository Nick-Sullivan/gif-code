import 'package:flutter/material.dart';
import 'package:qr_gif/widgets/gif_form/gif_form_controller.dart';
import 'package:qr_gif/widgets/qr_code/qr_code_controller.dart';

class GifFormView extends StatelessWidget {
  final GifFormController gifFormController;
  final QrCodeController qrCodeController;
  final _formKey = GlobalKey<FormState>();

  GifFormView(
      {super.key,
      required this.gifFormController,
      required this.qrCodeController});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
        listenable: gifFormController,
        builder: (BuildContext context, Widget? child) {
          return Form(
            key: _formKey,
            onChanged: () {
              gifFormController.setValid(_formKey.currentState!.validate());
            },
            child: Column(
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.all(20.0),
                  child: TextFormField(
                    key: const Key("qrText"),
                    controller: gifFormController.textController,
                    autofocus: true,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Enter text",
                        prefixIcon: Icon(Icons.qr_code_2),
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
                    icon: const Icon(Icons.image),
                    label: const Text('Select from GIPHY'),
                    onPressed: gifFormController.isValid
                        ? () async {
                            FocusScope.of(context).unfocus();
                            final gifId =
                                await gifFormController.createGif(context);
                            if (gifId != null) {
                              qrCodeController.createGif(
                                  gifId, gifFormController.text);
                            }
                          }
                        : null,
                  ),
                  ElevatedButton.icon(
                    key: const Key("randomGifButton"),
                    icon: const Icon(Icons.question_mark),
                    label: const Text('Random'),
                    onPressed: gifFormController.isValid
                        ? () async {
                            FocusScope.of(context).unfocus();
                            qrCodeController
                                .createRandom(gifFormController.text);
                          }
                        : null,
                  )
                ]),
              ],
            ),
          );
        });
  }
}
