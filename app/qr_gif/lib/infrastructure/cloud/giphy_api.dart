import 'package:enough_giphy_flutter/enough_giphy_flutter.dart';
import 'package:flutter/material.dart';
import 'package:qr_gif/infrastructure/interfaces/giphy_api.dart';

class GiphyApiInteractor implements IGiphyApiInteractor {
  final String apiKey;

  GiphyApiInteractor({required this.apiKey});

  @override
  Future<GiphyGif?> create(BuildContext context) async {
    return await Giphy.getGif(
        context: context,
        apiKey: apiKey,
        type: GiphyType.gifs,
        lang: GiphyLanguage.english,
        rating: GiphyRating.pg13,
        showAttribution: true,
        showPreview: false,
        showTypeSwitcher: false);
  }
}
