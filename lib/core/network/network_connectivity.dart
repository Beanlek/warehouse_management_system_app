import 'package:connectivity_plus/connectivity_plus.dart';

class NetworkConnectivity {
  static Future<bool> get status async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult.any((element) => element == ConnectivityResult.wifi || element == ConnectivityResult.mobile)) {
      return true;
    } else {
      return false;
    }
  }
}
