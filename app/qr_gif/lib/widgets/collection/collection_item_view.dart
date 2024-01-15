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
          ]);
        });
  }
}
