import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:qr_gif/infrastructure/interfaces/qr_code_api.dart';
import 'package:qr_gif/infrastructure/interfaces/qr_code_store.dart';
import 'package:qr_gif/widgets/qr_code/qr_code_model.dart';

class QrCodeController extends ChangeNotifier {
  final qrApi = GetIt.instance<IQrCodeApiInteractor>();
  final imageStore = GetIt.instance<IQrCodeStore>();

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  bool _hasLoaded = false;
  bool get hasLoaded => _hasLoaded;
  QrCode? _qrCode;
  QrCode? get qrCode => _qrCode;
  String? _notificationMessage;
  String? get notificationMessage => _notificationMessage;

  Future<void> createGif(String gifId, String text) async {
    _isLoading = true;
    notifyListeners();
    _qrCode = await qrApi.create(gifId, text);
    _isLoading = false;
    _hasLoaded = true;
    notifyListeners();
  }

  Future<void> createRandom(String text) async {
    _isLoading = true;
    notifyListeners();
    _qrCode = await qrApi.createRandom(text);
    _isLoading = false;
    _hasLoaded = true;
    notifyListeners();
  }

  Future<void> save(QrCode qr) async {
    await imageStore.save(qr);
    _notificationMessage = "Image saved";
    notifyListeners();
  }

  void clearNotification() async {
    _notificationMessage = null;
  }

  void setQrCode(QrCode? qrCode) {
    _qrCode = qrCode;
    _hasLoaded = true;
    notifyListeners();
  }
}
