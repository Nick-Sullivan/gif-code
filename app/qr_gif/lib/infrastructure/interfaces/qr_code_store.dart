import 'package:qr_gif/widgets/qr_code/qr_code_model.dart';

abstract class IQrCodeStore {
  Future<void> save(QrCode image);
  Future<List<String>> loadSavedQrCodeIds();
  Future<QrCode> loadQrCode(String qrCodeId);
  Future<void> deleteQrCode(String qrCodeId);
  List<String> listSavedQrCodeIds();
  bool hasLoadedQrCode(String qrCodeId);
  QrCode getQrCode(String qrCodeId);
}
