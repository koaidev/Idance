import 'dart:io';

import 'package:app_review/app_review.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';
import '../strings.dart';

class ShareApp extends StatefulWidget {
  final String? title;
  final Color color;

  const ShareApp({Key? key, required this.title, this.color = Colors.orange})
      : super(key: key);
  @override
  _ShareAppState createState() => _ShareAppState();
}

class _ShareAppState extends State<ShareApp> {
  String appID = "";
  String output = "";

  @override
  initState() {
    super.initState();
    _initPackageInfo();
    AppReview.getAppID.then(log);
    if (Platform.isIOS) {
      AppReview.requestReview.then((onValue) {
        print(onValue);
      });
    }
  }

  Future<void> _initPackageInfo() async {

  }

  void log(String? message) {
    if (message != null) {
      setState(() {
        output = message;
      });
      print(message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        String shareText = widget.title! +
            "\n" +
            "${AppContent.shareAppContent}" +
            "\n" +
            "\n" +
            "https://play.google.com/store/apps/details?id=" +
            appID;
        Share.share(shareText);
      },
      child: Icon(Icons.share, color: widget.color),
    );
  }
}
