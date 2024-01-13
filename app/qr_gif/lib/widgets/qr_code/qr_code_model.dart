import 'dart:typed_data';

import 'package:flutter/widgets.dart';

class QrCode {
  final String id;
  final Image image;
  final Uint8List imageBytes;
  final String text;

  const QrCode({
    required this.id,
    required this.image,
    required this.imageBytes,
    required this.text,
  });
}
