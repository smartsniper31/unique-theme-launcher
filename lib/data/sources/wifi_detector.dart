import 'package:network_info_plus/network_info_plus.dart';

class WifiDetector {
  final NetworkInfo _networkInfo = NetworkInfo();

  Future<String?> getSsid() async {
    try {
      return await _networkInfo.getWifiName();
    } catch (_) {
      return "Offline";
    }
  }
}
