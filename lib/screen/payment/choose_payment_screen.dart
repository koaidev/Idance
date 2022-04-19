import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:oxoo/screen/payment/api/momo_payment_handle.dart';
import 'package:oxoo/screen/payment/models/payment_momo_create.dart';
import 'package:oxoo/screen/payment/models/payment_momo_response.dart';
import 'package:oxoo/screen/payment/payment_by_card.dart';

class ChoosePaymentScreen extends StatefulWidget {
  final int index;

  const ChoosePaymentScreen({Key? key, required this.index}) : super(key: key);

  @override
  ChoosePaymentScreenState createState() {
    return ChoosePaymentScreenState(index: index);
  }
}

class ChoosePaymentScreenState extends State<StatefulWidget> {
  // ignore: non_constant_identifier_names
  late String _paymentStatus;
  final int index;
  late String title;
  late String comboLearn;
  late String amount;
  late int amountNumber;
  final nameController = TextEditingController();
  final phoneController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    nameController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  void initPaymentValue() {
    if (index == 1) {
      comboLearn = "Gói học 1 tháng";
      title = "THANH TOÁN GÓI HỌC 1 THÁNG";
      amount = "50.000";
      amountNumber = 50000;
    } else if (index == 2) {
      comboLearn = "Gói học 3 tháng";
      title = "THANH TOÁN GÓI HỌC 3 THÁNG";
      amount = "120.000";
      amountNumber = 120000;
    } else if (index == 3) {
      comboLearn = "Gói học 6 tháng";
      title = "THANH TOÁN GÓI HỌC 6 THÁNG";
      amount = "150.000";
      amountNumber = 150000;
    }
  }

  ChoosePaymentScreenState({Key? key, required this.index}) : super();

  @override
  void initState() {
    super.initState();
    _paymentStatus = "";
    initPlatformState();
    initPaymentValue();
  }

  Future<void> initPlatformState() async {
    if (!mounted) return;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
          title: Text(title),
          leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: Icon(
                Icons.arrow_back_ios,
              )),
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Center(
            child: Column(
              children: <Widget>[
                Divider(),
                Text("Chi tiết giao dịch",
                    style: TextStyle(
                        color: Colors.red,
                        fontSize: 20,
                        fontWeight: FontWeight.bold)),
                SingleChildScrollView(
                  // constraints: const BoxConstraints(minWidth: double.infinity),
                  // margin: const EdgeInsets.fromLTRB(15, 5, 15, 15),
                  padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
                  child: Column(
                    children: [
                      Divider(color: Colors.grey, thickness: 1),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Expanded(
                            child: Text(
                              "Nhà cung cấp",
                              style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold),
                            ), // <-- Wrapped in Expanded.
                          ),
                          Expanded(
                              child: Text(
                            "CNA GROUP",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 14),
                          ))
                        ],
                      ),
                      SizedBox(height: 5),
                      Row(mainAxisSize: MainAxisSize.min, children: [
                        Expanded(
                            child: Text(
                          "Liên hệ",
                          style: TextStyle(
                              color: Colors.red,
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                        )),
                        Expanded(
                            child: Text(
                          "0888.430.620",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                        ))
                      ]),
                      SizedBox(height: 5),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Expanded(
                              child: Text(
                            "Dịch vụ",
                            style: TextStyle(
                                color: Colors.red,
                                fontSize: 14,
                                fontWeight: FontWeight.bold),
                          )),
                          Expanded(
                              child: Text(
                            comboLearn,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.bold),
                          ))
                        ],
                      ),
                      SizedBox(height: 5),
                      Row(mainAxisSize: MainAxisSize.min, children: [
                        Expanded(
                            child: Text(
                          "Số tiền",
                          style: TextStyle(
                              color: Colors.red,
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                        )),
                        Expanded(
                            child: Text(
                          amount,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                        ))
                      ]),
                      Divider(
                        color: Colors.grey,
                        thickness: 1,
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Expanded(
                              child: Text(
                            "Thông tin khách hàng",
                            style: TextStyle(
                                color: Colors.red,
                                fontSize: 14,
                                fontWeight: FontWeight.bold),
                          )),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Expanded(
                              child: TextField(
                            keyboardType: TextInputType.name,
                            controller: nameController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    width: 3, color: Colors.blue),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              labelText: 'Nhập tên của bạn',
                            ),
                            style: TextStyle(
                                color: Colors.red,
                                fontSize: 14,
                                fontWeight: FontWeight.bold),
                          ))
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Expanded(
                              child: TextField(
                            keyboardType: TextInputType.phone,
                            controller: phoneController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    width: 3, color: Colors.blue),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              labelText: 'Nhập SĐT liên hệ của bạn',
                            ),
                            style: TextStyle(
                                color: Colors.red,
                                fontSize: 14,
                                fontWeight: FontWeight.bold),
                          ))
                        ],
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      ButtonTheme(
                        minWidth: 300,
                        buttonColor: Colors.red,
                        child: ElevatedButton(
                          child: Text(
                            'Thanh toán ví MOMO',
                          ),
                          onPressed: () async {
                            if (nameController.text.isEmpty |
                                phoneController.text.isEmpty) {
                              if (nameController.text.isEmpty) {
                                Fluttertoast.showToast(
                                    msg:
                                        "Bạn cần nhập tên để có thể kích hoạt đúng tài khoản.");
                              } else if (phoneController.text.isEmpty) {
                                Fluttertoast.showToast(
                                    msg:
                                        "Bạn cần nhập SĐT để có thể kích hoạt đúng tài khoản.");
                              } else {
                                Fluttertoast.showToast(
                                    msg:
                                        "Bạn cần nhập thông tin để có thể kích hoạt tài khoản.");
                              }
                            } else {
                              String partnerCode = "MOMOEZEO20220315";
                              String partnerName = "CÔNG TY TNHH CNA GROUP";
                              int amount = amountNumber;
                              String lang = "vi";
                              String requestType = "captureWallet";
                              String redirectUrl =
                                  "https://play.google.com/store/apps/details?id=com.idance.hocnhayonline&hl=vi&gl=VN";
                              String requestId = "ID" +
                                  DateTime.now()
                                      .millisecondsSinceEpoch
                                      .toString();
                              String ipnUrl = "http://54.255.160.47/api/ipn";
                              String orderId = requestId;
                              String orderInfo =
                                  "${nameController.text} - ${phoneController.text} - $comboLearn";
                              String storeId = "MOMOEZEO20220315";
                              Map<String, String> data = {
                                "user_id":
                                    FirebaseAuth.instance.currentUser!.uid
                              };
                              String extraData =
                                  base64.encode(utf8.encode(json.encode(data)));
                              String accessKey = "q2ACnLximNzIH50O";
                              String secretKey =
                                  "guoqhgzu7orgVcISgpDalcgcoW3NcoJl";
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
                                      amount: amountNumber,
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

                              MomoPayment.handleResultResponse(response);
                            }
                          },
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Text("Hoặc", style: TextStyle(color: Colors.grey)),
                      SizedBox(
                        height: 15,
                      ),
                      ButtonTheme(
                        minWidth: 300,
                        buttonColor: Colors.red,
                        child: ElevatedButton(
                          child: Text(
                            'Chuyển Khoản Ngân Hàng',
                          ),
                          onPressed: () async {
                            //todo
                            if (nameController.text.isEmpty |
                                phoneController.text.isEmpty) {
                              if (nameController.text.isEmpty) {
                                Fluttertoast.showToast(
                                    msg:
                                        "Bạn cần nhập tên để có thể kích hoạt đúng tài khoản.");
                              } else if (phoneController.text.isEmpty) {
                                Fluttertoast.showToast(
                                    msg:
                                        "Bạn cần nhập SĐT để có thể kích hoạt đúng tài khoản.");
                              } else {
                                Fluttertoast.showToast(
                                    msg:
                                        "Bạn cần nhập thông tin để có thể kích hoạt tài khoản.");
                              }
                            } else {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => PaymentByCardScreen(
                                            index: index,
                                            name: nameController.text,
                                            phoneNumber: phoneController.text,
                                          ),
                                      settings:
                                          RouteSettings(arguments: index)));
                            }
                          },
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Container(
                        child: Text(
                          "Chú ý:",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                          textAlign: TextAlign.left,
                        ),
                        width: MediaQuery.of(context).size.width,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Tài khoản của bạn sẽ được kích hoạt trong tối đa 15 phút đối với hình thức thành toán Momo và chuyển khoản nhanh 24/7\nTài khoản của bạn sẽ được kích hoạt trong tối đa 1-3 ngày đối với hình thức chuyển khoản thông thường.\nHotline: 0888.430.620",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      )
                    ],
                  ),
                ),
                // Text(
                //     _paymentStatus.isEmpty ? "CHƯA THANH TOÁN" : _paymentStatus)
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _setState() {
    _paymentStatus = 'ĐÃ THANH TOÁN';
  }

  void _handlePaymentSuccess(PaymentMomoResponse response) {
    setState(() {
      _setState();
    });
    Fluttertoast.showToast(
        msg: "Đã thanh toán thành công: " + response.orderId,
        toastLength: Toast.LENGTH_SHORT);
  }

  void _handlePaymentError(PaymentMomoResponse response) {
    setState(() {
      _setState();
    });
    Fluttertoast.showToast(
        msg: "Thanh toán không thành công: " + response.message.toString(),
        toastLength: Toast.LENGTH_SHORT);
  }
}
