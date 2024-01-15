import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:qr_gif/infrastructure/interfaces/qr_code_store.dart';
import 'package:qr_gif/widgets/qr_code/qr_code_model.dart';

class CollectionController extends ChangeNotifier {
  final qrStore = GetIt.instance<IQrCodeStore>();
  bool _isInitialised = false;
  bool get isInitialised => _isInitialised;
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  List<String> get qrIds => qrStore.listSavedQrCodeIds();
  String? _selectedId;
  String? get selectedId => _selectedId;
  QrCode? _selectedQrCode;
  QrCode? get selectedQrCode => _selectedQrCode;

  Future<void> loadCollection() async {
    _isLoading = true;
    _isInitialised = true;
    notifyListeners();
    final qrIds = await qrStore.loadSavedQrCodeIds();
    for (final qrId in qrIds) {
      await qrStore.loadQrCode(qrId);
    }
    _isLoading = false;
    _isInitialised = true;
    notifyListeners();
  }

  Future<void> setSelectedId(String qrId) async {
    _isLoading = true;
    _selectedId = null;
    notifyListeners();

    _selectedId = qrId;
    if (!qrStore.hasLoadedQrCode(qrId)) {
      await qrStore.loadQrCode(qrId);
    }
    _selectedQrCode = qrStore.getQrCode(qrId);
    _isLoading = false;
    notifyListeners();
  }

  Future<void> deleteSelectedQrCode() async {
    _isLoading = true;
    notifyListeners();

    await qrStore.deleteQrCode(_selectedId!);
    _selectedId = null;
    _selectedQrCode = null;
    _isLoading = false;
    notifyListeners();
  }

  QrCode getQrCode(String qrId) {
    return qrStore.getQrCode(qrId);
  }
}
