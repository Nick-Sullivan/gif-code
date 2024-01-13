import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:qr_gif/infrastructure/interfaces/giphy_api.dart';
import 'package:qr_gif/screens/account_screen.dart';
import 'package:qr_gif/screens/collection_list_screen.dart';
import 'package:qr_gif/widgets/auth/auth_controller.dart';
import 'package:qr_gif/widgets/qr_code/qr_code_controller.dart';
import 'package:qr_gif/widgets/qr_code/qr_code_view.dart';

class HomeScreen extends StatelessWidget {
  final authController = GetIt.instance<AuthController>();
  final giphyApi = GetIt.instance<IGiphyApiInteractor>();
  final qrCodeController = QrCodeController();
  final textController = TextEditingController();

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: buildBody(context),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text('Generator'),
      actions: [
        PopupMenuButton(
          key: const Key("popupMenuButton"),
          itemBuilder: (_) {
            var popMenus = [
              const PopupMenuItem(
                value: 0,
                child: Text("Account", key: Key("accountMenuButton")),
              ),
              const PopupMenuItem(
                value: 1,
                child: Text("Collection", key: Key("collectionMenuButton")),
              ),
            ];
            return popMenus;
          },
          onSelected: ((value) {
            if (value == 0) {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AccountScreen()));
            }
            if (value == 1) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CollectionListScreen()));
            }
          }),
        ),
      ],
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
                key: const Key("qrText"),
                controller: textController..text = "",
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Enter text",
                    prefixIcon: Icon(Icons.qr_code_2),
                    contentPadding: EdgeInsets.all(20.0)),
              ),
            ),
            ElevatedButton.icon(
              key: const Key("gifButton"),
              icon: const Icon(Icons.image),
              label: const Text('Select from GIPHY'),
              onPressed: () async {
                final gif = await giphyApi.create(context);
                if (gif != null) {
                  qrCodeController.createGif(gif.id, textController.text);
                }
              },
            ),
            ElevatedButton.icon(
              key: const Key("randomGifButton"),
              icon: const Icon(Icons.question_mark),
              label: const Text('Random'),
              onPressed: () async {
                qrCodeController.createRandom(textController.text);
              },
            ),
            QrCodeView(
                controller: qrCodeController, key: const Key('qrCodeView')),
          ],
        ),
      ),
    );
  }
}
