import 'dart:convert';
import '../config.dart';

class ConfigApi {
  String getApiUrl() {
    return Config.apiServerUrl + "v130";
  }

  Map<String, String> getHeaders() {
    /*authorization*/
    String username = 'nguyennam.3695@gmail.com';
    String password = '123456';
    String basicAuth = 'Basic ' + base64Encode(utf8.encode('$username:$password'));

    /*headers */
    Map<String, String> headers = {'API-KEY': Config.apiKey, 'authorization': basicAuth};
    return headers;
  }
}
