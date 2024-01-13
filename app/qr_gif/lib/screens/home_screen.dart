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
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: buildAppBar(context),
      body: buildBody(context),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text('Generator'),
      backgroundColor: Theme.of(context).primaryColor,
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
                controller: textController..text = "Enter your QR text here",
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Enter text",
                    contentPadding: EdgeInsets.all(20.0)),
              ),
            ),
            TextButton(
              key: const Key("gifButton"),
              child: const Text('SELECT GIF'),
              onPressed: () async {
                final gif = await giphyApi.create(context);
                if (gif != null) {
                  qrCodeController.createGif(gif.id, textController.text);
                }
              },
            ),
            TextButton(
              key: const Key("randomGifButton"),
              child: const Text('CREATE RANDOM GIF'),
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
