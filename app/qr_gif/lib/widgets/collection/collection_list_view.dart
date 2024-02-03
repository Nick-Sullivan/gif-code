import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:qr_gif/screens/collection_item_screen.dart';
import 'package:qr_gif/widgets/collection/collection_controller.dart';

class CollectionListView extends StatelessWidget {
  final controller = GetIt.instance<CollectionController>();

  CollectionListView({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
        listenable: controller,
        builder: (BuildContext context, Widget? child) {
          if (controller.isLoading) {
            return const CircularProgressIndicator(key: Key('loadingImage'));
          }
          return ListView.builder(
              itemBuilder: _buildItem,
              itemCount: controller.qrIds.length,
              scrollDirection: Axis.vertical,
              shrinkWrap: true);
        });
  }

  Widget _buildItem(BuildContext context, int index) {
    final qrId = controller.qrIds[index];
    return ListTile(
      title: Text(controller.getQrCode(qrId).text),
      trailing: const Icon(Icons.arrow_forward),
      onTap: () async {
        controller.setSelectedId(qrId);
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => CollectionItemScreen()));
      },
      onLongPress: () async {
        final text = controller.getQrCode(qrId).text;
        await Clipboard.setData(ClipboardData(text: text)).then((value) =>
            ScaffoldMessenger.of(context)
                .showSnackBar(const SnackBar(content: Text("Text copied."))));
      },
    );
  }
}
