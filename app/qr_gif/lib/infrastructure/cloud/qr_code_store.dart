import 'package:flutter/widgets.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:qr_gif/infrastructure/interfaces/qr_code_store.dart';
import 'package:qr_gif/widgets/qr_code/qr_code_model.dart';

class QrCodeStore implements IQrCodeStore {
  Directory? _dir;
  final Map<String, QrCode> _qrCodesById = <String, QrCode>{};
  final List<String> _qrIds = <String>[];

  @override
  Future<void> save(QrCode qrCode) async {
    final dir = await getDirectory();
    if (!dir.existsSync()) {
      dir.create();
    }
    final file = File("${dir.path}/${qrCode.id}.gif");

    await file.writeAsBytes(qrCode.imageBytes);
    _qrCodesById[qrCode.id] = qrCode;
    if (!_qrIds.contains(qrCode.id)) {
      _qrIds.add(qrCode.id);
    }
  }

  @override
  Future<List<String>> loadSavedQrCodeIds() async {
    final dir = await getDirectory();
    if (!dir.existsSync()) {
      return <String>[];
    }
    final files = await dir.list().toList();
    _qrIds.clear();
    for (final file in files) {
      _qrIds.add(getIdFromPath(file.path));
    }
    return _qrIds;
  }

  @override
  List<String> listSavedQrCodeIds() {
    return _qrIds;
  }

  @override
  Future<QrCode> loadQrCode(String qrCodeId) async {
    final dir = await getDirectory();
    final file = File("${dir.path}/$qrCodeId.gif");
    final imageBytes = await file.readAsBytes();
    final qrCode = QrCode(
        id: qrCodeId,
        image: Image.memory(imageBytes, key: const Key("qrCodeImage")),
        imageBytes: imageBytes,
        text: "i dont know");
    _qrCodesById[qrCodeId] = qrCode;
    return qrCode;
  }

  @override
  QrCode getQrCode(String qrCodeId) {
    return _qrCodesById[qrCodeId]!;
  }

  @override
  bool hasLoadedQrCode(String qrCodeId) {
    return _qrCodesById.containsKey(qrCodeId);
  }

  @override
  Future<void> deleteQrCode(String qrCodeId) async {
    final dir = await getDirectory();
    final file = File("${dir.path}/$qrCodeId.gif");
    await file.delete();
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
}
