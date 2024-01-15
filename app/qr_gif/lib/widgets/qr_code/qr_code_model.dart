import 'dart:convert';
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

  List<int> serialiseMetaData() {
    final json = jsonEncode({"id": id, "text": text});
    final serialised = utf8.encode(json);
    return serialised;
  }

  factory QrCode.fromSerialised(List<int> metadata, Uint8List imageBytes) {
    final json = utf8.decode(metadata);
    final Map map = jsonDecode(json);
    final image = Image.memory(imageBytes, key: const Key("qrCodeImage"));
    return QrCode(
      id: map['id'],
      image: image,
      imageBytes: imageBytes,
      text: map['text'],
    );
  }
}
