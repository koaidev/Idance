import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../style/theme.dart';
import 'custom_button.dart';

class UpdateScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/update.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Spacer(flex: 2,),
            Text(
              "Cập Nhật",
              style: CustomTheme.bodyText3White.copyWith(
                  fontSize: MediaQuery.of(context).size.height * 0.03,
                  color: Theme.of(context).primaryColor),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.01),
            Text(
              "Đã có phiên bản mới trên store, vui lòng cập nhật ứng dụng để trải nghiệm những dịch vụ tốt nhất.",
              style: CustomTheme.bodyText1.copyWith(
                  fontSize: MediaQuery.of(context).size.height * 0.0175,
                  color: Colors.white),
              textAlign: TextAlign.center,
            ),
            Spacer(flex: 1,),
            CustomButton(
                buttonText: "Đồng ý",
                onPressed: () async {
                  String _appUrl = 'https://google.com';
                  if (GetPlatform.isAndroid) {
                    _appUrl =
                        "https://play.google.com/store/apps/details?id=com.idance.hocnhayonline";
                  } else if (GetPlatform.isIOS) {
                    _appUrl =
                        "https://apps.apple.com/us/app/idance-h%E1%BB%8Dc-nh%E1%BA%A3y-online/id1611028904";
                  // https://apps.apple.com/us/app/idance-h%E1%BB%8Dc-nh%E1%BA%A3y-online/id1611028904
                  }
                  if (await canLaunchUrlString(_appUrl)) {
                    launchUrlString(_appUrl,
                        mode: LaunchMode.externalApplication);
                  }
                }),
            Spacer(flex: 1,),
          ]),
        ),
      ),
    ));
  }
}
