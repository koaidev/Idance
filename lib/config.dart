class Config {
  //set your api server url here
  static String apiServerUrl              = "http://apppanel.cnagroup.vn/rest-api/";
  //set your api key here
  static String apiKey                    = "8fdd1a1e3a9b82d39eec9811";
  //set your onesignalID here
  // static String oneSignalID               = "xxxxx-xxxx-xxxx-xxxx-xxxxxxx";
  static String oneSignalID = "f7855bc6-b605-4562-b865-037b8fb0f618";

  //set term and conditaions url here
  static String termsPolicyUrl            = "https://cnagroup.vn/chinh-sach-bao-mat/";

  //set api momo payment
  static String momoServerUrl = "https://payment.momo.vn";
  //https://payment.momo.vn/v2/gateway/api/create


  static final bool enableFacebookAuth    = true;
  static final bool enableGoogleAuth      = true;
  static final bool enablePhoneAuth       = false;
  static final bool enableAppleAuthForIOS = false;
  //publicKeyBase64 from play store to implement in app purchase
  static final String publicKeyBase64     ="xxxxxxx/xxx+xxx+xxx+xx+xxxx+xxx+xx+xxxxx+xxx/x56/W+xxx+xx+xx/xx";
  static final int appVersion = 31;
}