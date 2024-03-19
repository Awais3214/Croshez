/* 
helper class to explicitly check internet connection before making any API calls.
nd to be sure about internet availability to be sure about connectivity.
*/
import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
//import 'package:connectivity_plus/connectivity_plus.dart';

// abstract class InternetConnectivity {
//   Future<bool> connectivityResult();
// }

class Conn {
  /*
  this method will return true on android if you're connected to a router or hotspot that has no internet access */
  Future<bool> connectivityResult() async {
    bool isConnected = false;
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      isConnected = true;
    }
    return isConnected;
  }
}
