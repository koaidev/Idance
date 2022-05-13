import 'package:flutter/material.dart';
import 'package:oxoo/screen/landing_screen.dart';
import 'package:oxoo/screen/payment/choose_payment_screen.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({Key? key}) : super(key: key);

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        child: Column(
          children: [
            Text(
              'CHỌN GÓI HỌC',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.red,
                fontFamily: 'Montserrat',
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 30,
            ),
            _buildSubTitle('1 tháng', "50.000 VND", 1),
            _buildSubTitle('3 tháng', "120. 000 VND", 2),
            _buildSubTitle('6 tháng', "", 3),
            Spacer(
              flex: 1,
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
                      Expanded(child: Text("HOME"))
                    ],
                  )),
              width: 200,
            ),
            SizedBox(
              height: 15,
            )
          ],
        ),
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
      ),
    );
  }

  Widget _buildSubTitle(String title, String subTitle, int index) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ChoosePaymentScreen(index: index),
                settings: RouteSettings(arguments: index)));
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
            if (index == 3)
              Row(
                children: [
                  Text(
                    '450.000 VNĐ'.toUpperCase(),
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontFamily: 'Montserrat',
                        decoration: TextDecoration.lineThrough,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    ' 150.000 VNĐ'.toUpperCase(),
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold),
                  )
                ],
                mainAxisAlignment: MainAxisAlignment.center,
              ),
            if (index == 2)
              Row(
                children: [
                  Text(
                    '250.000 VNĐ'.toUpperCase(),
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontFamily: 'Montserrat',
                        decoration: TextDecoration.lineThrough,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    ' 120.000 VNĐ'.toUpperCase(),
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Montserrat',
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  )
                ],
                mainAxisAlignment: MainAxisAlignment.center,
              ),
            if (index == 1)
              Row(
                children: [
                  Text(
                    '100.000 VNĐ'.toUpperCase(),
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        color: Colors.white,
                        fontSize: 18,
                        decoration: TextDecoration.lineThrough,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    ' 50.000 VNĐ'.toUpperCase(),
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        color: Colors.white,
                        fontSize: 18,
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
