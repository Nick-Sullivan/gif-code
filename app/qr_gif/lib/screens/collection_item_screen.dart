import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:qr_gif/widgets/collection/collection_controller.dart';
import 'package:qr_gif/widgets/collection/collection_item_view.dart';
import 'package:share_plus/share_plus.dart';

class CollectionItemScreen extends StatelessWidget {
  final collectionController = GetIt.instance<CollectionController>();
  CollectionItemScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: buildBody(context),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(title: const Text(""), actions: [
      PopupMenuButton(
          key: const Key("menuButton"),
          itemBuilder: (_) {
            var popMenus = [
              const PopupMenuItem(
                  value: 0,
                  child: Row(children: [Icon(Icons.share), Text(" Share")])),
              const PopupMenuItem(
                  value: 1,
                  child: Row(children: [Icon(Icons.delete), Text(" Delete")])),
            ];
            return popMenus;
          },
          onSelected: ((value) {
            if (value == 0) {
              final path = collectionController.getQrImagePath();
              Share.shareXFiles([XFile(path)]);
            }
            if (value == 1) {
              showDialog<String>(
                  context: context,
                  builder: (context) => AlertDialog(
                        title: const Text('Delete?'),
                        content: const Text('This action cannot be undone.'),
                        actions: [
                          TextButton(
                            key: const Key('confirmDeleteButton'),
                            child: const Text('Delete'),
                            onPressed: () {
                              collectionController.deleteSelectedQrCode();
                              Navigator.of(context).pop();
                              Navigator.of(context).pop();
                            },
                          ),
                          TextButton(
                            child: const Text('Cancel'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      ));
            }
          })),
    ]);
  }

  Widget buildBody(BuildContext context) {
    return ListenableBuilder(
        listenable: collectionController,
        builder: (BuildContext context, Widget? child) {
          return CollectionItemView(
              controller: collectionController,
              key: const Key('collectionItemView'));
        });
  }
}
