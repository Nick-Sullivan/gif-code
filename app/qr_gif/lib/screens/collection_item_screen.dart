import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:qr_gif/widgets/collection/collection_controller.dart';
import 'package:qr_gif/widgets/collection/collection_item_view.dart';

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
    return AppBar(
      title: Text(collectionController.selectedQrCode!.text),
    );
  }

  Widget buildBody(BuildContext context) {
    return ListenableBuilder(
        listenable: collectionController,
        builder: (BuildContext context, Widget? child) {
          return Center(
            child: SingleChildScrollView(
              child: CollectionItemView(
                  controller: collectionController,
                  key: const Key('collectionItemView')),
            ),
          );
        });
  }
}