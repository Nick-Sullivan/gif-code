import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:qr_gif/infrastructure/interfaces/giphy_api.dart';

class GifFormController extends ChangeNotifier {
  final textController = TextEditingController();
  final giphyApi = GetIt.instance<IGiphyApiInteractor>();

  bool _isValid = false;
  bool get isValid => _isValid;
  String get text => textController.text;

  void setValid(bool value) {
    if (value == _isValid) {
      return;
    }
    _isValid = value;
    notifyListeners();
  }

  Future<String?> createGif(BuildContext context) async {
    final gif = await giphyApi.create(context);
    return gif?.id;
  }
}
