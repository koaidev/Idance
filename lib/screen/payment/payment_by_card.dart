import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:oxoo/utils/price_converter.dart';
import 'package:toast/toast.dart';

class PaymentByCardScreen extends StatefulWidget {
  final int amount;
  final String reason;

  const PaymentByCardScreen(
      {Key? key, required this.reason, required this.amount})
      : super(key: key);

  @override
  _PaymentByCardScreenState createState() => _PaymentByCardScreenState();
}

class _PaymentByCardScreenState extends State<PaymentByCardScreen> {
  Function? action1;
  late String comboLearn;
  late int amountNumber;

  void handleAction() {
    comboLearn = widget.reason;
    amountNumber = widget.amount;
    action1 = () {
      Clipboard.setData(ClipboardData(
          text: "$comboLearn - ${FirebaseAuth.instance.currentUser!.uid}"));
      Toast.show(
          "Đã sao chép: $comboLearn - ${FirebaseAuth.instance.currentUser!.uid}",
          duration: Toast.lengthShort,
          backgroundColor: Colors.red,
          textStyle: TextStyle(color: Colors.white, fontSize: 16.0),
          gravity: Toast.bottom);
    };
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    handleAction();
    ToastContext().init(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          "CHUYỂN KHOẢN NGÂN HÀNG",
          style: TextStyle(
              fontFamily: 'Montserrat',
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 16),
        ),
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            )),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: _buildContent(),
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Container(
      decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
                color: Color(0xffA22447).withOpacity(.05),
                offset: Offset(0, 0),
                blurRadius: 20,
                spreadRadius: 3)
          ]),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      child: Column(
        children: [
          RichText(
              textAlign: TextAlign.center,
              text: TextSpan(children: [
                TextSpan(
                    text: "\n${PriceConverter.convertPrice(amountNumber)} VNĐ",
                    style: const TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.white)),
                TextSpan(
                  text: "\n\nĐể thanh toán gói học này, bạn hãy ",
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    color: Colors.white,
                  ),
                ),
                TextSpan(
                  text: "copy nội dung chuyển khoản",
                  style: TextStyle(
                      fontFamily: 'Montserrat',
                      color: Colors.white,
                      decoration: TextDecoration.underline),
                ),
                TextSpan(
                  text: " và chuyển khoản vào ",
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    color: Colors.white,
                  ),
                ),
                TextSpan(
                  text: "số tài khoản",
                  style: TextStyle(
                      fontFamily: 'Montserrat',
                      color: Colors.white,
                      decoration: TextDecoration.underline),
                ),
                TextSpan(
                  text: " bên dưới\n",
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    color: Colors.white,
                  ),
                ),
              ])),
          SizedBox(
            height: 15,
          ),
          Divider(
            height: 1,
            color: Colors.white,
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            children: [
              Expanded(
                  child: Column(
                children: [
                  RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(children: [
                        TextSpan(
                            text: "\nNỘI DUNG\nCHUYỂN KHOẢN\n\n",
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Montserrat',
                            )),
                        TextSpan(
                            text:
                                "$comboLearn - ${FirebaseAuth.instance.currentUser!.uid}\n\n",
                            style: const TextStyle(
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                      ])),
                  _buildActionCopy('COPY NỘI DUNG CHUYỂN KHOẢN',
                      action: action1)
                ],
              )),
              SizedBox(
                width: 20,
              ),
              Expanded(
                  child: Column(
                children: [
                  RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(children: [
                        TextSpan(
                            text: "\nSỐ TÀI KHOẢN\n\n\n",
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Montserrat',
                            )),
                        TextSpan(
                            text: "Ngân hàng ACB\nCNA Group\n 1327.888888\n\n",
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.bold))
                      ])),
                  _buildActionCopy('COPY SỐ\nTÀI KHOẢN', action: () {
                    Clipboard.setData(ClipboardData(text: "1327888888"));
                    Toast.show("Đã sao chép: 1327888888",
                        duration: Toast.lengthShort,
                        backgroundColor: Colors.red,
                        textStyle:
                            TextStyle(color: Colors.white, fontSize: 16.0),
                        gravity: Toast.bottom);
                  })
                ],
              )),
            ],
          ),
          SizedBox(
            height: 32,
          ),
          Divider(
            height: 1,
            color: Colors.white,
          ),
          SizedBox(
            height: 32,
          ),
          Container(
            width: 160,
            decoration: BoxDecoration(
                color: Colors.redAccent,
                borderRadius: BorderRadius.all(Radius.circular(16))),
            child: Padding(padding: EdgeInsets.all(6),child: Text(
              "HOTLINE:\n0888.430.620",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Montserrat',
              ),
            ),)
          )
        ],
      ),
    );
  }

  Widget _buildActionCopy(String title, {Function? action}) {
    return GestureDetector(
      onTap: () {
        action?.call();
      },
      child: Container(
        width: 160,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(6)),
            color: Colors.red),
        child: Padding(
          padding: EdgeInsets.fromLTRB(0, 6, 0, 6),
          child: Text(
            title,
            style: TextStyle(
                color: Colors.white,
                fontFamily: 'Montserrat',
                decorationColor: Colors.white,
                decoration: TextDecoration.underline),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
