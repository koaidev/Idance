class PaymentMomoResponse {
  String partnerCode;
  String requestId;
  String orderId;
  int amount;
  int responseTime;
  String message;
  int resultCode;
  String payUrl;
  String? deeplink;

  PaymentMomoResponse(
      this.partnerCode,
      this.requestId,
      this.orderId,
      this.amount,
      this.responseTime,
      this.message,
      this.resultCode,
      this.payUrl,
      this.deeplink,
     );

  static PaymentMomoResponse fromMap(Map<String?, dynamic> map) {
    String partnerCode = map["partnerCode"];
    String requestId = map["requestId"];
    String orderId = map["orderId"];
    int amount = map["amount"];
    int responseTime = map["responseTime"];
    String message = map["message"];
    int resultCode = map["resultCode"];
    String payUrl = map["payUrl"];
    String deeplink = map["deeplink"];
    // String qrCodeUrl = map["qrCodeUrl"];
    return PaymentMomoResponse(partnerCode, requestId, orderId, amount,
        responseTime, message, resultCode, payUrl, deeplink);
  }
}
