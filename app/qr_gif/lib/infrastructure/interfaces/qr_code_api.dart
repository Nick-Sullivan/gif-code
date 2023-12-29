import 'package:qr_gif/widgets/qr_code/qr_code_model.dart';

abstract class IQrCodeApiInteractor {
  Future<QrCode> create(String giphyId, String text);
}
