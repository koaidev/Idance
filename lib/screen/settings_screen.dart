import 'package:app_review/app_review.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../../screen/terms_polices.dart';
import '../../strings.dart';
import '../../style/theme.dart';
import '../../utils/button_widget.dart';
import '../constants.dart';

class SettingScreen extends StatefulWidget {
  static final String route = "/SettingScreen";

  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  String? output = "";
  String appId = "";
  String? buildNumber = "";
  String? version = "";

  static bool? isDark;
  var appModeBox = Hive.box('appModeBox');
  bool _switchValue = true;

  @override
  initState() {
    super.initState();
    AppReview.getAppID.then(log);
    AppReview.getPackageInfo().then((value) {
      setState(() {
        buildNumber = value?.buildNumber;
        version = value?.version;
      });
    });
    isDark = appModeBox.get('isDark') ?? false;
  }

  void log(String? message) {
    if (message != null) {
      setState(() {
        appId = message;
      });
      print(message);
    }
  }

  @override
  Widget build(BuildContext context) {
    printLog("_SettingScreenState");
    return Scaffold(
      appBar: AppBar(
        title: Text(AppContent.settings),
        backgroundColor:
            isDark! ? CustomTheme.colorAccentDark : CustomTheme.primaryColor,
      ),
      body: Container(
        color: isDark! ? CustomTheme.primaryColorDark : CustomTheme.whiteColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
              child: Text(
                AppContent.notification,
                style: CustomTheme.coloredBodyText1,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppContent.pushNotification,
                    style: isDark!
                        ? CustomTheme.bodyText2White
                        : CustomTheme.bodyText2Bold,
                  ),
                  Switch(
                    activeColor: CustomTheme.primaryColor,
                    inactiveThumbColor: Colors.grey.shade100,
                    inactiveTrackColor: Colors.grey,
                    value: _switchValue,
                    onChanged: (value) {
                      setState(() {
                        _switchValue = value;
                      });
                    },
                  ),
                ],
              ),
            ),
            _divider(isDark),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
              child: Text(
                AppContent.others,
                style: CustomTheme.coloredBodyText1,
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(AppContent.contactUs,
                      style: isDark!
                          ? CustomTheme.bodyText2BoldWhite
                          : CustomTheme.bodyText2Bold),
                  Text(
                    AppContent.infoAddress,
                    style: isDark!
                        ? CustomTheme.bodyText3White
                        : CustomTheme.bodyText3,
                  ),
                ],
              ),
            ),
            _divider(isDark),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(AppContent.copyright,
                      style: isDark!
                          ? CustomTheme.bodyText2BoldWhite
                          : CustomTheme.bodyText2Bold),
                  HelpMe().space(8.0),
                  Text(
                    AppContent.copyrightText,
                    style: isDark!
                        ? CustomTheme.bodyText3White
                        : CustomTheme.bodyText3,
                  ),
                  HelpMe().space(8.0),
                  Text(
                    AppContent.allRightReserved,
                    style: isDark!
                        ? CustomTheme.bodyText3White
                        : CustomTheme.bodyText3,
                  ),
                ],
              ),
            ),
            _divider(isDark),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(AppContent.version,
                      style: isDark!
                          ? CustomTheme.bodyText2BoldWhite
                          : CustomTheme.bodyText2Bold),
                  Text(
                    "$version($buildNumber)",
                    style: isDark!
                        ? CustomTheme.bodyText3White
                        : CustomTheme.bodyText3,
                  ),
                ],
              ),
            ),
            _divider(isDark),
            InkWell(
              onTap: () {
                Navigator.pushNamed(context, TermsPolices.route);
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: 10.0),
                child: Text(AppContent.termsPolices,
                    style: isDark!
                        ? CustomTheme.bodyText2BoldWhite
                        : CustomTheme.bodyText2Bold),
              ),
            ),
            _divider(isDark),
            InkWell(
              onTap: () {
                AppReview.storeListing.then((onValue) {
                  setState(() {
                    output = onValue;
                  });
                  print(onValue);
                });
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: 10.0),
                child: Text(AppContent.shareThisApp,
                    style: isDark!
                        ? CustomTheme.bodyText2BoldWhite
                        : CustomTheme.bodyText2Bold),
              ),
            ),
            _divider(isDark),
          ],
        ),
      ),
    );
  }

  _divider(bool? isDark) {
    return Divider(color: CustomTheme.grey_60);
  }
}
