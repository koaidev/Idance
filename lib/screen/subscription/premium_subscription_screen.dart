import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:oxoo/screen/payment/payment_screen.dart';

import '../../style/theme.dart';

//In-app-purchase var

class PremiumSubscriptionScreen extends StatefulWidget {
  static final String route = '/PremiumSubscriptionScreen';
  final bool? fromRadioScreen;
  final bool? fromLiveTvScreen;
  final String? radioId;
  final String? liveTvID;
  final String? isPaid;

  const PremiumSubscriptionScreen(
      {Key? key,
      this.fromRadioScreen,
      this.fromLiveTvScreen,
      this.radioId,
      this.liveTvID,
      this.isPaid})
      : super(key: key);

  @override
  _PremiumSubscriptionScreenState createState() =>
      _PremiumSubscriptionScreenState();
}

class _PremiumSubscriptionScreenState extends State<PremiumSubscriptionScreen> {
  String? widgetplanId;
  String? currentProductPrice;
  String? currentPlanID;
  int popCount = 0;
  double? screenWidth;
  late bool isDark;
  var appModeBox = Hive.box('appModeBox');
  bool isUserValidSubscriber = false;

  //In-app-purchase var
  List<String> _notFoundIds = [];
  bool _isAvailable = false;
  bool _loading = true;

  @override
  void initState() {
    isDark = appModeBox.get('isDark') ?? false;

    initStoreInfo();
    super.initState();
  }

  Future<void> initStoreInfo() async {}

  void showPendingUI() {
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: isDark ? Colors.black : CustomTheme.primaryColor,
          title: Image.asset(
            'assets/logo.png',
            scale: 12.0,
          ),
        ),
        body: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/images/background.png"),
                  fit: BoxFit.cover)),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                SizedBox(
                  height: 20.0,
                ),
                Expanded(child: PaymentScreen())
              ],
            ),
          ),
        ));
  }
}
