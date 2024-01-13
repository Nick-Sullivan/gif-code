import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:qr_gif/widgets/collection/collection_controller.dart';
import 'package:qr_gif/widgets/collection/collection_list_view.dart';

class CollectionListScreen extends StatelessWidget {
  final collectionController = GetIt.instance<CollectionController>();
  CollectionListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: buildBody(context),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text('Collection'),
    );
  }

  Widget buildBody(BuildContext context) {
    return CollectionListView(
      key: const Key('collectionView'),
    );
  }
}
