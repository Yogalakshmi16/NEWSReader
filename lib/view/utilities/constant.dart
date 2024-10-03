import 'package:fluttertoast/fluttertoast.dart';

class RequestConstant {
  static const Map<String, String> headers = {
    'Content-Type': 'application/json'
  };

  static const String anErrorOccurred = 'An Error Occurred';
  static const String netWorkConnectevity = 'Please check your internet connection';
}

class Baseutilities {
  static showToast(String message) =>
      Fluttertoast.showToast(msg: message, timeInSecForIosWeb: 3);
}
