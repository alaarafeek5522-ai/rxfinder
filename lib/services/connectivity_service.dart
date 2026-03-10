import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  static Future<bool> isConnected() async {
    final results = await Connectivity().checkConnectivity();
    return results.isNotEmpty && results.first != ConnectivityResult.none;
  }
}
