import 'package:flutter/material.dart';
import 'package:qr_gif/widgets/qr_creation/qr_creation_controller.dart';
import 'package:qr_gif/widgets/qr_creation/gif_selection_view.dart';
import 'package:get_it/get_it.dart';

class GifSelectionScreen extends StatelessWidget {
  final qrCreationController = GetIt.instance<QrCreationController>();

  GifSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GifSelectionView(
        qrCreationController: qrCreationController,
        key: const Key('gifSelectionView'));
  }
}
