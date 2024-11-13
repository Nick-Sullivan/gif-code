import 'package:flutter/material.dart';
import 'package:qr_gif/widgets/qr_creation/qr_creation_controller.dart';
import 'package:giphy_flutter_sdk/dto/giphy_media.dart';
import 'package:giphy_flutter_sdk/dto/giphy_content_request.dart';
import 'package:giphy_flutter_sdk/dto/giphy_media_type.dart';
import 'package:giphy_flutter_sdk/giphy_grid_view.dart';

class GifSelectionView extends StatelessWidget {
  final QrCreationController qrCreationController;
  final _formKey = GlobalKey<FormState>();

  GifSelectionView({super.key, required this.qrCreationController});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
        listenable: qrCreationController,
        builder: (BuildContext context, Widget? child) {
          return Form(
            key: _formKey,
            onChanged: () {},
            child: Column(
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.all(20.0),
                  child: TextFormField(
                    key: const Key("gifText"),
                    controller: qrCreationController.gifTextController,
                    autofocus: true,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Search",
                        contentPadding: EdgeInsets.all(20.0)),
                    validator: (value) {
                      return null;
                    },
                  ),
                ),
                Expanded(
                    child: GiphyGridView(
                  content: qrCreationController.gifText.isNotEmpty
                      ? GiphyContentRequest(
                          mediaType: GiphyMediaType.gif,
                          requestType: GiphyContentRequestType.search,
                          searchQuery: qrCreationController.gifText)
                      : GiphyContentRequest.trending(
                          mediaType: GiphyMediaType.gif),
                  onMediaSelect: (GiphyMedia media) {
                    qrCreationController.setMediaId(media.id);
                    Navigator.pushReplacementNamed(context, '/qr');
                  },
                ))
              ],
            ),
          );
        });
  }
}
