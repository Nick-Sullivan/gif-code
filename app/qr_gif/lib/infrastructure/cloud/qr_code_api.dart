import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:qr_gif/infrastructure/interfaces/qr_code_api.dart';
import 'package:qr_gif/widgets/qr_code/qr_code_model.dart';
import 'package:flutter/widgets.dart';

class QrCodeApiInteractor implements IQrCodeApiInteractor {
  final String url;
  final String giphyIdForTesting = "gw3IWyGkC0rsazTi";
  final bool isTesting =
      const bool.fromEnvironment("IS_TESTING", defaultValue: false);

  QrCodeApiInteractor({required this.url});

  @override
  Future<QrCode> create(String giphyId, String text) async {
    final uri = Uri.parse('$url/gif');
    final request = '''{
      "text": "$text",
      "giphy_id": "$giphyId",
      "transparency": 160,
      "version": 6
    }''';
    return await sendRequest(uri, request);
  }

  @override
  Future<QrCode> createRandom(String text) async {
    final giphyId = isTesting ? giphyIdForTesting : "";
    final uri = Uri.parse('$url/gif');

    final request = '''{
      "text": "$text",
      "giphy_id": "$giphyId",
      "transparency": 160,
      "version": 6
    }''';
    return await sendRequest(uri, request);
  }

  Future<QrCode> sendRequest(Uri uri, String request) async {
    final response = await http.post(uri, body: request);
    if (response.statusCode != 200) {
      throw Exception('uh oh');
    }
    final json = jsonDecode(response.body);
    final image = await loadImageFromS3(json['url']);
    final qr = QrCode(text: json['text'], image: image);
    return qr;
  }

  Future<Image> loadImageFromS3(String url) async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode != 200) {
      throw Exception('uh oh');
    }
    final image =
        Image.memory(response.bodyBytes, key: const Key("qrCodeImage"));
    return image;
  }
}
