import 'dart:core';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';
import '../../models/user_model.dart';
import '../../screen/subscription/premium_subscription_screen.dart';
import '../../service/authentication_service.dart';
import '../../strings.dart';
import '../../style/theme.dart';
import '../../utils/button_widget.dart';

class MySubscriptionScreen extends StatefulWidget {
  static final String route = "/MySubscriptionScreen";

  @override
  _MySubscriptionScreenState createState() => _MySubscriptionScreenState();
}

class _MySubscriptionScreenState extends State<MySubscriptionScreen> {
  late bool isDark;
  var appModeBox = Hive.box('appModeBox');
  bool isUserValidSubscriber = false;
  int amount = 0;
  int timePaid = 0;
  String learnCombo = "";
  int timeCanUse = 0;
  int timeExp = 0;


  @override
  initState() {
    super.initState();
    isDark = appModeBox.get('isDark') ?? false;
    isUserValidSubscriber = appModeBox.get('isUserValidSubscriber') ?? false;
    amount = appModeBox.get("amount") ?? 0;
    timePaid = appModeBox.get("timePaid") ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    printLog("_MySubscriptionScreenState");
    final authService = Provider.of<AuthService>(context);
    AuthUser authUser = authService.getUser()!;
    if (amount == 50000 || amount == 45000) {
      timeExp = 2678400000;
      learnCombo = "Gói học 1 tháng";
    } else if (amount == 120000 || amount == 99000) {
      timeExp = 8035200000;
      learnCombo = "Gói học 3 tháng";
    } else if (amount == 150000 || amount == 149000) {
      timeExp = 16070400000;
      learnCombo = "Gói học 6 tháng";
    }
    int timeNow = DateTime.now().millisecondsSinceEpoch;
    timeCanUse = timePaid + timeExp - timeNow;
    int dayCanUse = timeCanUse ~/ 86400000;
    int hourCanUse = (timeCanUse % 86400000) ~/ 3600000;
    int minCanUse = ((timeCanUse % 86400000) % 3600000) ~/ 60000;

    return Scaffold(
      appBar: AppBar(
        title: Text(AppContent.mySubsCription),
        backgroundColor:
            isDark ? CustomTheme.colorAccentDark : CustomTheme.primaryColor,
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        color: isDark ? CustomTheme.primaryColorDark : Colors.white,
        child: Column(
          children: [
            _space(20),
            Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10.0, vertical: 10.0),
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "${AppContent.userName}${authUser.name}",
                        style: isDark
                            ? CustomTheme.bodyText3White
                            : CustomTheme.bodyText3,
                      ),
                      _space(4),
                      Text(
                        "ID người dùng: ${authUser.email?.split("@")[0]}",
                        style: isDark
                            ? CustomTheme.bodyText3White
                            : CustomTheme.bodyText3,
                      ),
                      _space(4),
                      if (isUserValidSubscriber)
                        Text(
                          "Gói học: " + learnCombo,
                          style: isDark
                              ? CustomTheme.bodyText3White
                              : CustomTheme.bodyText3,
                        ),
                      _space(4),
                      if (isUserValidSubscriber)
                        Text(
                          "Gói học còn: $dayCanUse ngày - $hourCanUse giờ - $minCanUse phút",
                          style: isDark
                              ? CustomTheme.bodyText3White
                              : CustomTheme.bodyText3,
                        ),
                      _space(40),
                      if (!isUserValidSubscriber)
                        InkWell(
                            onTap: () {
                              Navigator.pushNamed(
                                  context, PremiumSubscriptionScreen.route);
                            },
                            child: HelpMe()
                                .submitButton(300, AppContent.upgradePurchase)),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }

  _space(double space) {
    return SizedBox(height: space);
  }
}
