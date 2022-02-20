import 'package:flutter/material.dart';
import 'package:oxoo/screen/payment/payment_detail_screen.dart';

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
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Danh sách các gói học',
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
        ),
      ),
      body: Container(
        child: Column(
          children: [
            _buildSubTitle('1 tháng', "50.000 VND", 1),
            _buildSubTitle('3 tháng', "120. 000 VND", 2),
            _buildSubTitle('6 tháng', "", 3),
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
                builder: (context) => PaymentDetailScreen(),
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
                    '200.000 VNĐ'.toUpperCase(),
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        decoration: TextDecoration.lineThrough,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '- 150.000 VNĐ'.toUpperCase(),
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  )
                ],
                mainAxisAlignment: MainAxisAlignment.center ,
              ),
            if (index != 3)
              Text(
                subTitle.toUpperCase(),
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              )
          ],
        ),
      ),
    );
  }
}
