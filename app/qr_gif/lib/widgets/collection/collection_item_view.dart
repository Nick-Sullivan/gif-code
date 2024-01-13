import 'package:flutter/material.dart';
import 'package:qr_gif/widgets/collection/collection_controller.dart';

class CollectionItemView extends StatelessWidget {
  final CollectionController controller;

  const CollectionItemView({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
        listenable: controller,
        builder: (BuildContext context, Widget? child) {
          if (controller.selectedQrCode == null || controller.isLoading) {
            return const CircularProgressIndicator(key: Key('loadingImage'));
          }
          return Column(children: <Widget>[
            controller.selectedQrCode!.image,
            IconButton(
              key: const Key('deleteButton'),
              iconSize: 50,
              icon: const Icon(Icons.delete),
              onPressed: () {
                showDialog<String>(
                    context: context,
                    builder: (context) => AlertDialog(
                          title: const Text('Confirm delete?'),
                          content: const Text('This action cannot be undone.'),
                          actions: [
                            TextButton(
                              key: const Key('confirmDeleteButton'),
                              child: const Text('Delete'),
                              onPressed: () {
                                controller.deleteSelectedQrCode();
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
              },
            ),
          ]);
        });
  }
}
