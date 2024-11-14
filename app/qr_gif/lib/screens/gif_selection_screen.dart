import 'package:flutter/material.dart';
import 'package:qr_gif/widgets/qr_creation/qr_creation_controller.dart';
import 'package:qr_gif/widgets/qr_creation/gif_selection_view.dart';
import 'package:get_it/get_it.dart';

class GifSelectionScreen extends StatelessWidget {
  final qrCreationController = GetIt.instance<QrCreationController>();
  final TabController tabController;

  GifSelectionScreen({super.key, required this.tabController});

  @override
  Widget build(BuildContext context) {
    return GifSelectionView(
        tabController: tabController,
        qrCreationController: qrCreationController,
        key: const Key('gifSelectionView'));
  }
}
