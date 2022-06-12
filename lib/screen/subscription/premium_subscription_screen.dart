import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:oxoo/screen/payment/payment_screen.dart';

import '../../models/user_model.dart';
import '../../service/authentication_service.dart';
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
  AuthUser? authUser = AuthService().getUser();
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

// Card _buildProductList() {
//   if (_loading) {
//     return Card(
//         child: (ListTile(
//             leading: CircularProgressIndicator(),
//             title: Text(AppContent.fetchingProducts))));
//   }
//   if (!_isAvailable) {
//     return Card();
//   }
//   List<ListTile> productList = <ListTile>[];
//   if (_notFoundIds.isNotEmpty) {
//     productList.add(ListTile(
//         title: Text('[${_notFoundIds.join(", ")}] not found',
//             style: TextStyle(color: ThemeData.light().errorColor)),
//         subtitle: Text(AppContent.appNeedsConfiguration)));
//   }
//
//   // This loading previous purchases code is just a demo. Please do not use this as it is.
//   // In your app you should always verify the purchase data using the `verificationData` inside the [PurchaseDetails] object before trusting it.
//   // We recommend that you use your own server to verify the purchase data.
//
//   return Card(child: Column(children: <Widget>[] + productList));
// }
}
