import 'package:flutter/material.dart';
import 'package:qr_gif/widgets/qr_creation/qr_creation_controller.dart';
import 'package:giphy_flutter_sdk/dto/giphy_media.dart';
import 'package:giphy_flutter_sdk/dto/giphy_content_request.dart';
import 'package:giphy_flutter_sdk/dto/giphy_media_type.dart';
import 'package:giphy_flutter_sdk/giphy_grid_view.dart';
import 'dart:io';

class GifSelectionView extends StatelessWidget {
  final QrCreationController qrCreationController;
  final TabController tabController;
  final _formKey = GlobalKey<FormState>();

  GifSelectionView({
    super.key,
    required this.qrCreationController,
    required this.tabController,
  });

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
                        labelText: "Search GIPHY",
                        prefixIcon: Icon(Icons.search),
                        contentPadding: EdgeInsets.all(20.0)),
                    validator: (value) {
                      return null;
                    },
                  ),
                ),
                if (!Platform.isWindows)
                  Expanded(
                      child: SingleChildScrollView(
                          child: SizedBox(
                              height: 3000,
                              child: GiphyGridView(
                                content: qrCreationController.gifText.isNotEmpty
                                    ? GiphyContentRequest(
                                        mediaType: GiphyMediaType.gif,
                                        requestType:
                                            GiphyContentRequestType.search,
                                        searchQuery:
                                            qrCreationController.gifText)
                                    : GiphyContentRequest.trending(
                                        mediaType: GiphyMediaType.gif),
                                onMediaSelect: (GiphyMedia media) {
                                  qrCreationController.setMediaId(media.id);
                                  tabController.animateTo(1);
                                },
                              )))),
              ],
            ),
          );
        });
  }
}
