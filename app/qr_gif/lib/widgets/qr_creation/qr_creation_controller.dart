import 'package:flutter/material.dart';

enum QrTransparencyLevel {
  veryTransparent,
  transparent,
  solid,
}

class QrCreationController extends ChangeNotifier {
  final gifTextController = TextEditingController();
  final qrTextController = TextEditingController();

  String? _mediaId;
  bool _isQrTextValid = false;
  bool _isBoomerang = false;
  QrTransparencyLevel _qrTransparency = QrTransparencyLevel.transparent;
  String? get mediaId => _mediaId;
  String get gifText => gifTextController.text;
  String get qrText => qrTextController.text;
  bool get isQrTextValid => _isQrTextValid;
  bool get isBoomerang => _isBoomerang;
  bool get isReadyToMake => _isQrTextValid && isMediaSelected;
  bool get isMediaSelected => _mediaId != null;
  QrTransparencyLevel get qrTransparency => _qrTransparency;
  int get qrTransparencyValue {
    switch (_qrTransparency) {
      case QrTransparencyLevel.veryTransparent:
        return 100;
      case QrTransparencyLevel.transparent:
        return 190;
      case QrTransparencyLevel.solid:
        return 255;
    }
  }

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

  void setIsBoomerang(bool value) {
    if (value == _isBoomerang) {
      return;
    }
    _isBoomerang = value;
    notifyListeners();
  }

  void setQrTransparency(QrTransparencyLevel value) {
    if (value == _qrTransparency) {
      return;
    }
    _qrTransparency = value;
    notifyListeners();
  }
}
