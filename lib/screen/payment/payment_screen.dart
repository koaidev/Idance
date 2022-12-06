import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';
import 'package:oxoo/screen/landing_screen.dart';
import 'package:oxoo/screen/payment/choose_payment_screen.dart';
import 'package:oxoo/utils/validators.dart';

import '../../network/api_firebase.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({Key? key}) : super(key: key);

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final List<String> _productLists = [
    'com.idance.hocnhayonline.goihoc1thang',
    'com.idance.hocnhayonline.goihoc3thang',
    'com.idance.hocnhayonline.goihoc6thang'
  ];
  List<IAPItem> _items = [];
  IAPItem? item45;
  IAPItem? item99;
  IAPItem? item149;
  late StreamSubscription _purchaseUpdatedSubscription;
  late StreamSubscription _purchaseErrorSubscription;

  Future _getProduct() async {
    List<IAPItem> items =
        await FlutterInappPurchase.instance.getProducts(_productLists);
    for (var item in items) {
      print('${item.toString()}');
      this._items.add(item);
      if (item.productId == _productLists[0]) {
        this.item45 = item;
      }
      if (item.productId == _productLists[1]) {
        this.item99 = item;
      }
      if (item.productId == _productLists[2]) {
        this.item149 = item;
      }
    }

    setState(() {
      this._items = items;
    });
  }

  @override
  void initState() {
    if (Platform.isIOS) _getProduct();
    super.initState();
    _purchaseUpdatedSubscription =
        FlutterInappPurchase.purchaseUpdated.listen((productItem) async {
      print('purchase-updated: $productItem');
      if (productItem?.transactionStateIOS == TransactionState.purchased) {
        if (productItem?.productId == item45?.productId) {
          final userIDance = {
            "currentPlan": "vip1",
            "lastPlanDate":
                productItem?.originalTransactionDateIOS?.millisecondsSinceEpoch
          };
          final response = await ApiFirebase().updatePlan(userIDance);
          if(response){
            showShortToast("Bạn đã đăng ký thành công Gói học 1 tháng", context);
          }else{
            showShortToast("Lỗi đã xảy ra. Vui lòng liên hệ Admin để xử lý thanh toán.", context);
          }
        }
        if (productItem?.productId == item99?.productId) {
          final userIDance = {
            "currentPlan": "vip2",
            "lastPlanDate":
            productItem?.originalTransactionDateIOS?.millisecondsSinceEpoch
          };
          final response = await ApiFirebase().updatePlan(userIDance);
          if(response){
            showShortToast("Bạn đã đăng ký thành công Gói học 3 tháng", context);
          }else{
            showShortToast("Lỗi đã xảy ra. Vui lòng liên hệ Admin để xử lý thanh toán.", context);
          }
        }
        if (productItem?.productId == item149?.productId) {
          final userIDance = {
            "currentPlan": "vip3",
            "lastPlanDate":
            productItem?.originalTransactionDateIOS?.millisecondsSinceEpoch
          };
          final response = await ApiFirebase().updatePlan(userIDance);
          if(response){
            showShortToast("Bạn đã đăng ký thành công Gói học 6 tháng", context);
          }else{
            showShortToast("Lỗi đã xảy ra. Vui lòng liên hệ Admin để xử lý thanh toán.", context);
          }
        }
      }
    }, onDone: () {
      _purchaseUpdatedSubscription.cancel();
    }, onError: (Object error) {
      showShortToast("Lỗi đã xảy ra. $error.", context);
    });

    _purchaseErrorSubscription =
        FlutterInappPurchase.purchaseError.listen((purchaseError) {
      print('purchase-error: $purchaseError');
      showShortToast('purchase-error: $purchaseError', context);
    }, onDone: () {
      _purchaseErrorSubscription.cancel();
    }, onError: (Object error) {
      showShortToast("Lỗi đã xảy ra. $error.", context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.only(bottom: 15),
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
              decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                        color: Colors.white,
                        offset: Offset(0, 0),
                        blurRadius: 20,
                        spreadRadius: 3)
                  ],
                  color: Colors.red,
                  borderRadius: BorderRadius.all(Radius.circular(50))),
              child: Text(
                'CHỌN GÓI HỌC',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.white,
                  fontFamily: 'Montserrat',
                ),
                textAlign: TextAlign.center,
              ),
            ),

            // Spacer(
            //   flex: 10,
            // ),
            SizedBox(
              height: 30,
            ),
            if (Platform.isIOS)
              _buildSubTitle(
                  (item45 != null) ? item45!.title! : "Không xác định.",
                  "100.000 VNĐ",
                  (item45 != null) ? item45!.localizedPrice! : "0 VNĐ",
                  1),
            if (Platform.isIOS)
              _buildSubTitle(
                  (item99 != null) ? item99!.title! : "Không xác định.",
                  "250.000 VNĐ",
                  (item99 != null) ? item99!.localizedPrice! : "0 VNĐ",
                  2),
            if (Platform.isIOS)
              _buildSubTitle(
                  (item149 != null) ? item149!.title! : "Không xác định.",
                  "450.000 VNĐ",
                  (item149 != null) ? item149!.localizedPrice! : "0 VNĐ",
                  3),
            if (Platform.isAndroid)
              _buildSubTitle("GÓI HỌC 1 THÁNG", "100.000 VNĐ", "45.000", 1),
            if (Platform.isAndroid)
              _buildSubTitle("GÓI HỌC 3 THÁNG", "250.000 VNĐ", "99.000", 2),
            if (Platform.isAndroid)
              _buildSubTitle("GÓI HỌC 6 THÁNG", "450.000 VNĐ", "149.000", 3),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, LandingScreen.route);
              },
              child: Container(
                width: MediaQuery.of(context).size.width / 2.7,
                margin: const EdgeInsets.only(bottom: 15),
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                          color: Color(0xffA22447).withOpacity(.05),
                          offset: Offset(0, 0),
                          blurRadius: 20,
                          spreadRadius: 3)
                    ],
                    color: Colors.red,
                    borderRadius: BorderRadius.all(Radius.circular(50))),
                child: Row(
                  children: [
                    Expanded(
                        child: Icon(
                      Icons.home_rounded,
                      color: Colors.white,
                    )),
                    Expanded(
                        child: Text(
                      "HOME",
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: "Montserrat",
                          fontWeight: FontWeight.w700),
                    ))
                  ],
                ),
              ),
            ),
            Spacer(
              flex: 1,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.only(bottom: 15),
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
              decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                        color: Colors.white,
                        offset: Offset(0, 0),
                        blurRadius: 20,
                        spreadRadius: 3)
                  ],
                  color: Colors.red,
                  borderRadius: BorderRadius.all(Radius.circular(50))),
              child: Text(
                "Chú ý: \nSau khi thanh toán, thoát hoàn toàn ứng dụng và mở lại để được kích hoạt.",
                style: TextStyle(
                    color: Colors.white,
                    fontFamily: "Montserrat",
                    fontWeight: FontWeight.w700),
                textAlign: TextAlign.center,
              ),
            ),

            SizedBox(
              height: 30,
            ),
          ],
        ),
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
      ),
    );
  }

  Widget _buildSubTitle(
      String title, String cost, String discountCost, int index) {
    return GestureDetector(
      onTap: () {
        if (Platform.isIOS) {
          if (index == 1 && item45 != null) {
            FlutterInappPurchase.instance.requestPurchase(item45!.productId!);
          }
          if (index == 2 && item99 != null) {
            FlutterInappPurchase.instance.requestPurchase(item99!.productId!);
          }
          if (index == 3 && item149 != null) {
            FlutterInappPurchase.instance.requestPurchase(item149!.productId!);
          }
        }
        if (Platform.isAndroid) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ChoosePaymentScreen(index: index),
                  settings: RouteSettings(arguments: index)));
        }
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                  color: Color(0xffA22447).withOpacity(.05),
                  offset: Offset(0, 0),
                  blurRadius: 20,
                  spreadRadius: 3)
            ],
            color: Colors.red,
            borderRadius: BorderRadius.all(Radius.circular(50))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              title.toUpperCase(),
              style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Montserrat',
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              width: 2,
            ),
            Row(
              children: [
                Text(
                  '$cost'.toUpperCase(),
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontFamily: 'Montserrat',
                      decoration: TextDecoration.lineThrough,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  ' $discountCost'.toUpperCase(),
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.bold),
                )
              ],
              mainAxisAlignment: MainAxisAlignment.center,
            ),
          ],
        ),
      ),
    );
  }
}
