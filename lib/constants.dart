const kLOG_TAG = "[IDance]";
const kLOG_ENABLE = true;

printLog(dynamic data) {
  if (kLOG_ENABLE) {
    print("$kLOG_TAG${data.toString()}");
  }
}
