import 'package:flutter/material.dart';

class QrCreationController extends ChangeNotifier {
  final gifTextController = TextEditingController();
  final qrTextController = TextEditingController();

  String? _mediaId;
  String? get mediaId => _mediaId;
  String get gifText => gifTextController.text;
  String get qrText => qrTextController.text;
  bool _isQrTextValid = false;
  bool get isQrTextValid => _isQrTextValid;
  bool get isReadyToMake => _isQrTextValid && isMediaSelected;
  bool get isMediaSelected => _mediaId != null;

  QrCreationController() {
    gifTextController.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    notifyListeners();
  }

  void setIsQrTextValid(bool value) {
    if (value == _isQrTextValid) {
      return;
    }
    _isQrTextValid = value;
    notifyListeners();
  }

  void setMediaId(String? value) {
    if (value == _mediaId) {
      return;
    }
    _mediaId = value;
    notifyListeners();
  }
}
