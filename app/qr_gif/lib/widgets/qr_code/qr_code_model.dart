import 'dart:convert';
import 'package:flutter/widgets.dart';

class QrCode {
  final Image image;
  final String text;

  const QrCode({
    required this.image,
    required this.text,
  });

  factory QrCode.fromJson(Map<String, dynamic> json) {
    final decoded = base64.decode(json['image']);
    final image = Image.memory(decoded);
    return QrCode(
      image: image,
      text: json['text'],
    );
  }
}
