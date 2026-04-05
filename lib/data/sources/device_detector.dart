import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:android_id/android_id.dart';
import '../models/hardware_signature.dart';

class DeviceDetector {
  Future<HardwareSignature> detect(String userName) async {
    final deviceInfo = DeviceInfoPlugin();
    final androidInfo = await deviceInfo.androidInfo;
    final androidId = await const AndroidId().getId();

    final idHash = _hashId(androidId ?? "unknown");

    final shortModel = androidInfo.model.split(' ').last.toUpperCase();
    final signature =
        "${userName.substring(0, 3).toUpperCase()}-$shortModel-${androidInfo.version.sdkInt}-${idHash.substring(0, 4)}";

    return HardwareSignature(
      model: androidInfo.model,
      manufacturer: androidInfo.manufacturer,
      androidVersion: androidInfo.version.release,
      sdkInt: androidInfo.version.sdkInt,
      androidIdHash: idHash,
      signature: signature,
    );
  }

  String _hashId(String id) {
    return sha256.convert(utf8.encode(id)).toString();
  }
}
