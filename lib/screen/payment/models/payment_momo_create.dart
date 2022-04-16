import 'package:oxoo/config.dart';

class PaymentMomoCreate {
  String partnerCode = "MOMOEZEO20220315"; //Mã đối tác
  String partnerName = "CÔNG TY TNHH CNA GROUP"; //Tên đối tác
  String accessKey = "q2ACnLximNzIH50O";
  String secretKey = "guoqhgzu7orgVcISgpDalcgcoW3NcoJl";
  String storeId = "CNA-GROUP"; //Mã cửa hàng
  String requestType = "captureWallet";
  String ipnUrl = Config.momoServerUrl;
  String redirectUrl = Config.momoServerUrl; //
  String orderId; //Mã đơn hàng của đối tác
  int amount = 50000; //Số tiền cần thanh toán
  String lang = "vi"; //Ngôn ngữ
  String orderInfo = ""; //Thông tin đơn hàng
  String requestId = ""; //Mã định danh cho đơn hàng
  String extraData = "";
  String signature;
  bool autoCapture;

  PaymentMomoCreate(
      {required this.partnerCode,
      required this.partnerName,
      required this.storeId,
      required this.requestType,
      required this.ipnUrl,
      required this.redirectUrl,
      required this.orderId,
      required this.amount,
      required this.lang,
      required this.orderInfo,
      required this.requestId,
      required this.extraData,
      required this.autoCapture,
      required this.signature});

  // factory PaymentMomoCreate.fromJson(Map<String, dynamic> json) {
  //   return PaymentMomoCreate(
  //       partnerCode: json["partnerCode"],
  //       partnerName: json["partnerName"],
  //       storeId: json["storeId"],
  //       requestType: "captureWallet",
  //       ipnUrl: Config.momoServerUrl,
  //       redirectUrl: Config.momoServerUrl,
  //       orderId: json["orderId"],
  //       amount: json["amount"],
  //       lang: "vi",
  //       orderInfo: json["orderInfo"],
  //       requestId: json["requestId"],
  //       extraData: json["extraData"],
  //       signature: json["signature"]);
  // }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['partnerCode'] = this.partnerCode;
    data['partnerName'] = this.partnerName;
    data['storeId'] = this.storeId;
    data['requestType'] = this.requestType;
    data['ipnUrl'] = this.ipnUrl;
    data['redirectUrl'] = this.redirectUrl;
    data['orderId'] = this.orderId;
    data['amount'] = this.amount;
    data["lang"] = this.lang;
    data["orderInfo"] = this.orderInfo;
    data["requestId"] = this.requestId;
    data["extraData"] = this.extraData;
    data["signature"] = this.signature;
    data["autoCapture"] = this.autoCapture;
    return data;
  }
}
