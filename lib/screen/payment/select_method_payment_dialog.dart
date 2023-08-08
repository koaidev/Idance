import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:oxoo/network/api_firebase.dart';
import 'package:oxoo/screen/payment/payment_by_card.dart';

import '../../models/video_paid.dart';
import '../../style/theme.dart';
import '../subscription/my_subscription_screen.dart';
import 'api/momo_payment_handle.dart';
import 'models/payment_momo_create.dart';

class SelectMethodPaymentDialog {
  createDialog(context, String reason, int videoId, int numberCanWatch,
      int amount, bool? isDark) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Container(
            child: AlertDialog(
                backgroundColor: isDark! ? CustomTheme.darkGrey : Colors.white,
                content:
                    Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Chọn phương thức thanh toán",
                        style: isDark
                            ? CustomTheme.bodyText2White
                            : CustomTheme.bodyText2,
                      ),
                      InkWell(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Icon(
                            Icons.clear,
                            color: CustomTheme.whiteColor,
                          )),
                    ],
                  ),
                  Divider(
                    color: Colors.grey.shade200,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      children: [
                        Padding(
                          padding:  EdgeInsets.all(4),
                          child: InkWell(
                            onTap: () async {
                              //Navigator.of(context).pop();
                              String partnerCode = "MOMOEZEO20220315";
                              String partnerName = "CÔNG TY TNHH CNA GROUP";
                              String lang = "vi";
                              String requestType = "captureWallet";
                              String redirectUrl =
                                  "http://apppanel.cnagroup.vn/applink/";
                              String requestId = "ID" +
                                  DateTime.now()
                                      .millisecondsSinceEpoch
                                      .toString();
                              String ipnUrl =
                                  "http://apppanel.cnagroup.vn/rest_api/v1/index";
                              String orderId = requestId;
                              String orderInfo =
                                  "video$videoId";
                              String storeId = "MOMOEZEO20220315";
                              Map<String, String> data = {
                                "user_id":
                                    FirebaseAuth.instance.currentUser!.uid,
                                "videoId": videoId.toString(),
                                "reason": reason,
                                "number_can_watch": numberCanWatch.toString()
                              };
                              String extraData =
                                  base64.encode(utf8.encode(json.encode(data)));
                              String accessKey = "y1NdrijpynTsOCHW";
                              String secretKey =
                                  "3FUSB54SlKdbz0R8Z3HHFKF7u8M0EgQU";
                              var signature =
                                  "accessKey=$accessKey&amount=$amount&extraData=$extraData&ipnUrl=$ipnUrl&orderId=$orderId&orderInfo=$orderInfo&partnerCode=$partnerCode&redirectUrl=$redirectUrl&requestId=$requestId&requestType=$requestType";

                              final keyBytes = utf8.encode(secretKey);
                              final dataBytes = utf8.encode(signature);
                              final hmacBytes = new Hmac(sha256, keyBytes);
                              final digest = hmacBytes.convert(dataBytes);
                              signature = "$digest";

                              final response = await MomoPayment.createPayment(
                                  PaymentMomoCreate(
                                      partnerCode: partnerCode,
                                      partnerName: partnerName,
                                      amount: amount,
                                      // amount: 1000,
                                      lang: lang,
                                      requestType: requestType,
                                      redirectUrl: redirectUrl,
                                      requestId: requestId,
                                      ipnUrl: ipnUrl,
                                      orderId: orderId,
                                      orderInfo: orderInfo,
                                      storeId: storeId,
                                      extraData: extraData,
                                      autoCapture: true,
                                      signature: signature));
                              print("ResponsePayment: ${response.resultCode}");
                              MomoPayment.handleResultResponse(
                                  response, context);
                            },
                            child: Container(
                                width: MediaQuery.of(context).size.width,
                                color: isDark
                                    ? CustomTheme.black_window
                                    : Colors.grey.shade300,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "Thanh toán bằng Ví MoMo",
                                    style: isDark
                                        ? CustomTheme.smallTextWhite
                                        : CustomTheme.smallTextGrey,
                                  ),
                                )),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4),
                          child: InkWell(
                            onTap: () {
                              //Navigator.of(context).pop();
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => PaymentByCardScreen(
                                            amount: amount,
                                            reason: reason + "ID video: $videoId",
                                          )));
                            },
                            child: Container(
                                width: MediaQuery.of(context).size.width,
                                color: isDark
                                    ? CustomTheme.black_window
                                    : Colors.grey.shade300,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "Thanh toán bằng chuyển khoản",
                                    style: isDark
                                        ? CustomTheme.smallTextWhite
                                        : CustomTheme.smallTextGrey,
                                  ),
                                )),
                          ),
                        ),
                        SizedBox(height: 16,),
                        Text("Hoặc", style: TextStyle(color: Colors.white)),
                        SizedBox(height: 16,),
                        Padding(
                          padding: const EdgeInsets.all(4),
                          child: InkWell(
                            onTap: () {
                              //Navigator.of(context).pop();
                              Navigator.pop(context);
                              Navigator.pushNamed(context, MySubscriptionScreen.route);
                            },
                            child: Container(
                                width: MediaQuery.of(context).size.width,
                                color: isDark
                                    ? CustomTheme.black_window
                                    : Colors.grey.shade300,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "Nâng cấp tài khoản vip",
                                    style: isDark
                                        ? CustomTheme.smallTextWhite
                                        : CustomTheme.smallTextGrey,
                                  ),
                                )),
                          ),
                        )
                      ],
                    ),
                  ),
                ])),
          );
        });
  }
}
