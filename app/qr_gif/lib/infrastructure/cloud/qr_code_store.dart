import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:qr_gif/infrastructure/interfaces/qr_code_store.dart';
import 'package:qr_gif/widgets/qr_code/qr_code_model.dart';

class QrCodeStore implements IQrCodeStore {
  Directory? _dir;
  final Map<String, QrCode> _qrCodesById = <String, QrCode>{};
  final List<String> _qrIds = <String>[];

  @override
  Future<List<String>> loadSavedQrCodeIds() async {
    final dir = await getDirectory();
    if (!dir.existsSync()) {
      dir.create();
      return <String>[];
    }
    final files = await dir.list().toList();
    _qrIds.clear();
    for (final file in files) {
      final qrId = getIdFromPath(file.path);
      if (!_qrIds.contains(qrId)) {
        _qrIds.add(qrId);
        await loadQrCode(qrId);
      }
    }
    _qrIds.sort((a, b) => _qrCodesById[a]!.compareTo(_qrCodesById[b]!));
    return _qrIds;
  }

  @override
  Future<QrCode> loadQrCode(String qrCodeId) async {
    final fileImage = await getImageFile(qrCodeId);
    final fileMeta = await getMetaFile(qrCodeId);
    final imageBytes = await fileImage.readAsBytes();
    final imageMeta = await fileMeta.readAsBytes();
    final qrCode = QrCode.fromSerialised(imageMeta, imageBytes);
    _qrCodesById[qrCodeId] = qrCode;
    return qrCode;
  }

  @override
  List<String> listSavedQrCodeIds() {
    return _qrIds;
  }

  @override
  QrCode getQrCode(String qrCodeId) {
    return _qrCodesById[qrCodeId]!;
  }

  @override
  Future<void> save(QrCode qrCode) async {
    final fileImage = await getImageFile(qrCode.id);
    final fileMeta = await getMetaFile(qrCode.id);
    await fileImage.writeAsBytes(qrCode.imageBytes);
    await fileMeta.writeAsBytes(qrCode.serialiseMetaData());
    _qrCodesById[qrCode.id] = qrCode;
    if (!_qrIds.contains(qrCode.id)) {
      _qrIds.add(qrCode.id);
    }
  }

  @override
  bool hasLoadedQrCode(String qrCodeId) {
    return _qrCodesById.containsKey(qrCodeId);
  }

  @override
  Future<void> deleteQrCode(String qrCodeId) async {
    final fileImage = await getImageFile(qrCodeId);
    final fileMeta = await getMetaFile(qrCodeId);
    await fileImage.delete();
    await fileMeta.delete();
    _qrIds.removeWhere((id) => id == qrCodeId);
    _qrCodesById.remove(qrCodeId);
  }

  Future<Directory> getDirectory() async {
    if (_dir == null) {
      final dir = await getApplicationDocumentsDirectory();
      _dir = Directory("${dir.path}/qr_codes");
    }
    return _dir!;
  }

  String getIdFromPath(String path) {
    return path.split("/").last.split("\\").last.split(".").first;
  }

  Future<File> getImageFile(String qrId) async {
    final dir = await getDirectory();
    return File("${dir.path}/$qrId.gif");
  }

  Future<File> getMetaFile(String qrId) async {
    final dir = await getDirectory();
    return File("${dir.path}/$qrId.meta");
  }

  @override
  String getQrImagePath(String qrId) {
    return "${_dir!.path}/$qrId.gif";
  }
}
