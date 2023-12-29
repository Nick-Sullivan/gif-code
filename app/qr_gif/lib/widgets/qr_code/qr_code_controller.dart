import 'package:flutter/material.dart';
import 'package:qr_gif/widgets/qr_code/qr_code_model.dart';

class QrCodeController extends ChangeNotifier {
  bool _isLoading = false;
  QrCode? _qrCode;

  bool get isLoading => _isLoading;
  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  QrCode? get qrCode => _qrCode;
  set qrCode(QrCode? value) {
    _qrCode = value;
    notifyListeners();
  }
}
