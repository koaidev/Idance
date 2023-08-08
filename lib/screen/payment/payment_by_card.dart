import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:oxoo/screen/landing_screen.dart';
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
                  text:
                      "Để thanh toán gói học này, bạn hãy chuyển khoản chính xác học phí với nội dung bên dưới:\n\nHọc phí:",
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    color: Colors.white,
                  ),
                ),
                TextSpan(
                    text: "\n${PriceConverter.convertPrice(amountNumber)}",
                    style: const TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
                TextSpan(
                    text: "\n\n Nội dung:\n",
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
                TextSpan(
                    text:
                        "\n\n-----------------------------\nTên ngân hàng: ACB\n\n Tên tài khoản: CNA Group\n\n Số tài khoản: 1327.888888\n\n-----------------------------\n\nHotline: 0888.430.620",
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Montserrat',
                    ))
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
                  child: _buildActionCopy('Copy nội dung', action: action1)),
              Expanded(
                  child: _buildActionCopy('Copy số tài khoản', action: () {
                Clipboard.setData(ClipboardData(text: "1327888888"));
                Toast.show("Đã sao chép: 1327888888",
                    duration: Toast.lengthShort,
                    backgroundColor: Colors.red,
                    textStyle: TextStyle(color: Colors.white, fontSize: 16.0),
                    gravity: Toast.bottom);
              })),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(primary: Colors.red),
                onPressed: () {
                  Navigator.pushNamed(context, LandingScreen.route);
                },
                child: Row(
                  children: [
                    Expanded(child: Icon(Icons.home_rounded)),
                    Expanded(
                        child: Text(
                      "HOME",
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                      ),
                    ))
                  ],
                )),
            width: 200,
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
      child: Row(
        children: [
          Icon(
            Icons.copy_sharp,
            color: Colors.white,
          ),
          SizedBox(
            width: 3,
          ),
          Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Montserrat',
            ),
          )
        ],
      ),
    );
  }
}
