import 'dart:async';
import 'dart:convert';

import 'package:flutter/src/widgets/framework.dart';
import 'package:http/http.dart' as http;
import 'package:oxoo/screen/payment/models/payment_momo_create.dart';
import 'package:oxoo/screen/payment/models/payment_momo_response.dart';
import 'package:toast/toast.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../network/api_configuration.dart';

class MomoPayment {
  static Future<PaymentMomoResponse> createPayment(
      PaymentMomoCreate momoCreate) async {
    final response =
        await http.post(Uri.parse(ConfigApi().getMomoServerUrlCreate()),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(<String, dynamic>{
              "partnerCode": momoCreate.partnerCode,
              "partnerName": momoCreate.partnerName,
              "storeId": momoCreate.storeId,
              "requestType": momoCreate.requestType,
              "ipnUrl": momoCreate.ipnUrl,
              "redirectUrl": momoCreate.redirectUrl,
              "orderId": momoCreate.orderId,
              "amount": momoCreate.amount,
              "lang": momoCreate.lang,
              "orderInfo": momoCreate.orderInfo,
              "requestId": momoCreate.requestId,
              "extraData": momoCreate.extraData,
              "signature": momoCreate.signature
            }));

    if (response.statusCode == 200) {
      // If the server did return a 200 CREATED response,
      // then parse the JSON.
      print("Create payment success!");
      return PaymentMomoResponse.fromMap(jsonDecode(response.body));
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('Failed to create payment. ${response.statusCode}');
    }
  }

  static Future<void> handleResultResponse(PaymentMomoResponse? response, BuildContext context) async {
    if (response != null && response.deeplink != null) {
      _launchURL(response.deeplink!);
    }else{
      ToastContext().init(context);
      Toast.show("Lỗi đã xảy ra. vui lòng thử lại sau!", duration: Toast.lengthShort, gravity:  Toast.bottom);
    }
  }

  static void _launchURL(String _url) async {
    if (!await launch(_url)) throw 'Could not launch $_url';
  }
}
