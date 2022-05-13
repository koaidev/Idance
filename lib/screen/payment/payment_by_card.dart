import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:oxoo/screen/landing_screen.dart';

class PaymentByCardScreen extends StatefulWidget {
  final int index;
  final String name;
  final String phoneNumber;

  const PaymentByCardScreen(
      {Key? key,
      required this.index,
      required this.name,
      required this.phoneNumber})
      : super(key: key);

  @override
  _PaymentByCardScreenState createState() => _PaymentByCardScreenState(
      index: index, name: name, phoneNumber: phoneNumber);
}

class _PaymentByCardScreenState extends State<PaymentByCardScreen> {
  Function? action1;
  late String comboLearn;
  late String amount;
  late int amountNumber;
  final String phoneNumber;
  final String name;
  final int index;

  _PaymentByCardScreenState(
      {required this.index, required this.name, required this.phoneNumber});

  void handleAction(int index) {
    if (index == 1) {
      comboLearn = "goi hoc 1 thang";
      amount = "50.000";
      amountNumber = 50000;
    } else if (index == 2) {
      comboLearn = "goi hoc 3 thang";
      amount = "120.000";
      amountNumber = 120000;
    } else {
      comboLearn = "goi hoc 6 thang";
      amount = "150.000";
      amountNumber = 150000;
    }
    action1 = () {
      Clipboard.setData(ClipboardData(
          text:
              "$name - $phoneNumber - $comboLearn - ${FirebaseAuth.instance.currentUser!.uid}"));
      Fluttertoast.showToast(
          msg:
              "Đã sao chép: $name - $phoneNumber - $comboLearn - ${FirebaseAuth.instance.currentUser!.uid}",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    };
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    handleAction(index);
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
                      "Để thanh toán gói học này, bạn hãy chuyển khoản chính xác học phí và nội dung bên dưới:\n\nHọc phí:",
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    color: Colors.white,
                  ),
                ),
                TextSpan(
                    text: "\n$amount",
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
                        "$name - $phoneNumber - $comboLearn - ${FirebaseAuth.instance.currentUser!.uid}\n\n",
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
            height: 5,
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
                  child: _buildActionCopy('Copy cú pháp', action: action1)),
              Expanded(
                  child: _buildActionCopy('Copy số tài khoản', action: () {
                Clipboard.setData(ClipboardData(text: "1327888888"));
                Fluttertoast.showToast(
                    msg: "Đã sao chép: 1327888888",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.blue,
                    textColor: Colors.white,
                    fontSize: 16.0);
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
