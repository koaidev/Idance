import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:oxoo/network/api_firebase.dart';
import 'package:oxoo/utils/validators.dart';
import 'package:toast/toast.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../constants.dart';
import '../../screen/auth/auth_screen.dart';
import '../../screen/profile/my_profile_screen.dart';
import '../../screen/search/search_result_screen.dart';
import '../../screen/settings_screen.dart';
import '../../screen/subscription/my_subscription_screen.dart';
import '../app.dart';
import '../config.dart';
import '../models/drawer_model.dart';
import '../models/payment_object.dart';
import '../models/user.dart';
import '../screen/favourite_screen.dart';
import '../screen/genre_screen.dart';
import '../strings.dart';
import '../style/theme.dart';
import '../utils/button_widget.dart';
import '../utils/search_text_field.dart';
import 'all_country_screen.dart';
import 'home_screen.dart';
import 'movie/movie_details_screen.dart';
import 'movie_screen.dart';
import 'tv_series/tv_series_details_screen.dart';
import 'tv_series_screen.dart';

class LandingScreen extends StatefulWidget {
  static final String route = "LandingScreen";

  @override
  _LandingScreenState createState() => _LandingScreenState();
}

int selectedIndex = -1;
int savedIndex = 0;

class _LandingScreenState extends State<LandingScreen>
    with SingleTickerProviderStateMixin {
  late TabController _controller;
  int _selectedIndex = 0;
  FocusNode? myFocusNode;
  static bool isDark = false;
  bool activeSearch = false;
  var appModeBox = Hive.box('appModeBox');
  String? userID;
  StreamSubscription? _conectionSubscription;

  int amount = 0;
  String learnCombo = "";
  int timeCanUse = 0;
  int timeExp = 0;

  @override
  void dispose() {
    myFocusNode!.dispose();
    _controller.dispose();
    if (_conectionSubscription != null) {
      _conectionSubscription!.cancel();
      _conectionSubscription = null;
    }
    super.dispose();
  }

  @override
  void initState() {
    if (Platform.isIOS) {
      asyncInitState();
    }
    _conectionSubscription =
        FlutterInappPurchase.connectionUpdated.listen((connected) {
      print('connected: $connected');
    });

    _controller = new TabController(vsync: this, length: 5, initialIndex: 1);
    super.initState();
    myFocusNode = FocusNode();
    KeyboardVisibilityController().onChange.listen((bool visible) {
      print('Keyboard visibility update. Is visible: $visible');
      if (visible == false) activeSearch = false;
    });
    isDark = appModeBox.get('isDark') ?? false;

    SchedulerBinding.instance
        .addPostFrameCallback((_) => configOneSignal(context));
    if (FirebaseAuth.instance.currentUser != null) {
      checkPaymentUser();
    }
  }

  checkPaymentUser() async {
    if (FirebaseAuth.instance.currentUser != null) {
      final uid = FirebaseAuth.instance.currentUser!.uid;
      final response = await http
          .get(Uri.parse("http://apppanel.cnagroup.vn/rest_api/v1/id/$uid"));
      if (response.statusCode == 200) {
        print("IPN body: " + response.body);
        // If the server did return a 200 OK response,
        // then parse the JSON.
        var paymentObject = PaymentObject.fromJson(jsonDecode(response.body));
        if (paymentObject.data != null) {
          Data data = paymentObject.data![0];
          UserIDance currentUser = await ApiFirebase()
              .getUser()
              .get()
              .then((value) => value.data() as UserIDance);
          if (data.userId != null &&
              currentUser.lastPlanDate! <
                  int.parse(data.requestId!.substring(2))) {
            int timePaid = int.parse(data.requestId!.substring(2));
            int amount = int.parse(data.amount!);
            if (amount == 50000 || amount == 45000) {
              int timeNow = DateTime.now().millisecondsSinceEpoch;
              int timeUseService = timeNow - timePaid;
              if (timeUseService > 2678400000) {
                final userIDance = {
                  "currentPlan": "free",
                };
                await ApiFirebase().updatePlan(userIDance);
              } else {
                final userIDance = {
                  "currentPlan": "vip1",
                  "lastPlanDate": timePaid
                };
                final response = await ApiFirebase().updatePlan(userIDance);
                if (response) {
                  Toast.show("Bạn đã đăng ký thành công gói cước 1 tháng.",
                      duration: Toast.lengthLong, gravity: Toast.bottom);
                  Navigator.popAndPushNamed(
                      context, MySubscriptionScreen.route);
                }
              }
            }
            if (amount == 120000 || amount == 99000) {
              int timeNow = DateTime.now().millisecondsSinceEpoch;
              int timeUseService = timeNow - timePaid;

              if (timeUseService > 8035200000) {
                final userIDance = {
                  "currentPlan": "free",
                };
                await ApiFirebase().updatePlan(userIDance);
              } else {
                final userIDance = {
                  "currentPlan": "vip2",
                  "lastPlanDate": timePaid
                };
                final response = await ApiFirebase().updatePlan(userIDance);
                if (response) {
                  Toast.show("Bạn đã đăng ký thành công gói cước 3 tháng.",
                      duration: Toast.lengthLong, gravity: Toast.bottom);
                  Navigator.popAndPushNamed(
                      context, MySubscriptionScreen.route);
                }
              }
            }
            if (amount == 150000 || amount == 149000) {
              int timeNow = DateTime.now().millisecondsSinceEpoch;
              int timeUseService = timeNow - timePaid;
              if (timeUseService > 16070400000) {
                final userIDance = {
                  "currentPlan": "free",
                };
                await ApiFirebase().updatePlan(userIDance);
              } else {
                final userIDance = {
                  "currentPlan": "vip3",
                  "lastPlanDate": timePaid
                };
                final response = await ApiFirebase().updatePlan(userIDance);
                if (response) {
                  Toast.show("Bạn đã đăng ký thành công gói cước 6 tháng.",
                      duration: Toast.lengthLong, gravity: Toast.bottom);
                  Navigator.popAndPushNamed(
                      context, MySubscriptionScreen.route);
                }
              }
            }
          }
        }
      } else {
        print("IPN Error: " + response.body);
      }

      UserIDance currentUser = await ApiFirebase()
          .getUser()
          .get()
          .then((value) => value.data() as UserIDance);
      if ((DateTime.now().millisecondsSinceEpoch - currentUser.lastPlanDate!) >
              2678400000 &&
          currentUser.currentPlan == "vip1") {
        final userIDance = {
          "currentPlan": "free",
        };
        await ApiFirebase().updatePlan(userIDance);
      }
      if ((DateTime.now().millisecondsSinceEpoch - currentUser.lastPlanDate!) >
              8035200000 &&
          currentUser.currentPlan == "vip2") {
        final userIDance = {
          "currentPlan": "free",
        };
        await ApiFirebase().updatePlan(userIDance);
      }
      if ((DateTime.now().millisecondsSinceEpoch - currentUser.lastPlanDate!) >
              16070400000 &&
          currentUser.currentPlan == "vip3") {
        final userIDance = {
          "currentPlan": "free",
        };
        await ApiFirebase().updatePlan(userIDance);
      }
    }
  }

  void asyncInitState() async {
    await FlutterInappPurchase.instance.initialize();
    UserIDance currentUser = await ApiFirebase()
        .getUser()
        .get()
        .then((value) => value.data() as UserIDance);
    if (currentUser.currentPlan == "free") {
      showShortToast("Đăng nhập AppleID để kiểm tra trạng thái Tài khoản ngay.", context);
      final purchases =
          await FlutterInappPurchase.instance.getPurchaseHistory();
      final List<PurchasedItem> listIDancePurchases = [];
      purchases?.forEach((element) {
        if (element.productId?.contains("com.idance.hocnhayonline") == true) {
          listIDancePurchases.add(element);
        }
      });
      listIDancePurchases.sort((a, b) => a
          .originalTransactionDateIOS!.millisecondsSinceEpoch
          .compareTo(b.originalTransactionDateIOS!.millisecondsSinceEpoch));
      final element = listIDancePurchases.last;
      final datePaid =
          element.originalTransactionDateIOS?.millisecondsSinceEpoch ?? 0;

      if (element.productId == "com.idance.hocnhayonline.goihoc1thang" &&
          (DateTime.now().millisecondsSinceEpoch - datePaid) <= 2678400000) {
        final userIDance = {"currentPlan": "vip1", "lastPlanDate": datePaid};
        final response = await ApiFirebase().updatePlan(userIDance);
        if (response) {
          Toast.show("Bạn đã đăng ký thành công gói cước 1 tháng.",
              duration: Toast.lengthLong, gravity: Toast.bottom);
          Navigator.popAndPushNamed(context, MySubscriptionScreen.route);
        }
      }
      if (element.productId == "com.idance.hocnhayonline.goihoc3thang" &&
          (DateTime.now().millisecondsSinceEpoch - datePaid) <= 8035200000) {
        final userIDance = {"currentPlan": "vip2", "lastPlanDate": datePaid};
        final response = await ApiFirebase().updatePlan(userIDance);
        if (response) {
          Toast.show("Bạn đã đăng ký thành công gói cước 3 tháng.",
              duration: Toast.lengthLong, gravity: Toast.bottom);
          Navigator.popAndPushNamed(context, MySubscriptionScreen.route);
        }
      }

      if (element.productId == "com.idance.hocnhayonline.goihoc6thang" &&
          (DateTime.now().millisecondsSinceEpoch - datePaid) <= 16070400000) {
        final userIDance = {"currentPlan": "vip3", "lastPlanDate": datePaid};
        final response = await ApiFirebase().updatePlan(userIDance);
        if (response) {
          Toast.show("Bạn đã đăng ký thành công gói cước 6 tháng.",
              duration: Toast.lengthLong, gravity: Toast.bottom);
          Navigator.popAndPushNamed(context, MySubscriptionScreen.route);
        }
      }

      if ((DateTime.now().millisecondsSinceEpoch - currentUser.lastPlanDate!) >
              2678400000 &&
          currentUser.currentPlan == "vip1") {
        final userIDance = {
          "currentPlan": "free",
        };
        await ApiFirebase().updatePlan(userIDance);
      }
      if ((DateTime.now().millisecondsSinceEpoch - currentUser.lastPlanDate!) >
              8035200000 &&
          currentUser.currentPlan == "vip2") {
        final userIDance = {
          "currentPlan": "free",
        };
        await ApiFirebase().updatePlan(userIDance);
      }
      if ((DateTime.now().millisecondsSinceEpoch - currentUser.lastPlanDate!) >
              16070400000 &&
          currentUser.currentPlan == "vip3") {
        final userIDance = {
          "currentPlan": "free",
        };
        await ApiFirebase().updatePlan(userIDance);
      }
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  List<String> _widgetTitle = ["IDance", "Bài học", "Khóa học", "Yêu thích"];

  List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    MoviesScreen(),
    TvSeriesScreen(),
    FavouriteScreen()
  ];

  void _handleSubmitted(String value) {
    printLog("trying_to_submit$value");
    if (value.length > 0) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  SearchResultScreen(queryText: value, isDark: isDark)));
    }
  }

  Future<void> configOneSignal(BuildContext context) async {
    await OneSignal.shared.setAppId(Config.oneSignalID);
    OneSignal.shared.setNotificationOpenedHandler((notification) {
      String? id = notification.notification.additionalData!["id"];
      String? type = notification.notification.additionalData!["vtype"];
      printLog("---------ID and Type: {$id $type}");

      switch (type) {
        case "movie":
          Navigator.pushNamed(context, MovieDetailScreen.route,
              arguments: {"movieID": id});
          break;
        case "tvseries":
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => TvSerisDetailsScreen(
                      seriesID: id,
                      isPaid: '',
                    )),
          );
          break;
        case "webview":
          _launchURL(id!);
          break;
        default:
          print("type_is_not_movie_event_radio_tv !");
          break;
      }
    });
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    printLog("_LandingScreenState");

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: _renderAppBar() as PreferredSizeWidget?,
      drawer: Drawer(
        child: Container(
          color: isDark
              ? CustomTheme.primaryColorDark
              : CustomTheme.primaryColorRed,
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                child: Align(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset('assets/logo.png', scale: 6),
                      HelpMe().space(10.0),
                      Text(
                        AppContent.oxooLiveTV,
                        style: CustomTheme.bodyText1White,
                      ),
                    ],
                  ),
                ),
                decoration: BoxDecoration(
                    color: isDark
                        ? Colors.grey.shade900
                        : CustomTheme.primaryColorRed),
              ),
              Container(
                color: isDark ? Colors.transparent : Colors.white,
                height: MediaQuery.of(context).size.height,
                child: ApiFirebase().isLogin()
                    ? drawerContent(drawerListItemFirst)
                    : drawerContentWithoutLogin(drawerListItemWithoutLogin),
              )
            ],
          ),
        ),
      ),
      body: Center(child: _widgetOptions.elementAt(_selectedIndex)),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            activeIcon: Image.asset(
              'assets/bottom_nav/icon_home.png',
              color: CustomTheme.primaryColorRed,
              scale: 3,
            ),
            icon: Image.asset(
              'assets/bottom_nav/icon_home.png',
              color: CustomTheme.grey_transparent2,
              scale: 3,
            ),
            label: AppContent.home,
          ),
          BottomNavigationBarItem(
            activeIcon: Image.asset(
              'assets/bottom_nav/icon_movie.png',
              color: CustomTheme.primaryColorRed,
              scale: 3,
            ),
            icon: Image.asset(
              'assets/bottom_nav/icon_movie.png',
              color: CustomTheme.grey_transparent2,
              scale: 3,
            ),
            label: AppContent.movies,
          ),
          BottomNavigationBarItem(
            activeIcon: Image.asset(
              'assets/bottom_nav/icon_tv_series.png',
              color: CustomTheme.primaryColorRed,
              scale: 3,
            ),
            icon: Image.asset(
              'assets/bottom_nav/icon_tv_series.png',
              color: CustomTheme.grey_transparent2,
              scale: 3,
            ),
            label: AppContent.series,
          ),
          BottomNavigationBarItem(
            activeIcon: Image.asset(
              'assets/bottom_nav/icon_favourite.png',
              color: CustomTheme.primaryColorRed,
              scale: 3,
            ),
            icon: Image.asset(
              'assets/bottom_nav/icon_favourite.png',
              color: CustomTheme.grey_transparent2,
              scale: 3,
            ),
            label: AppContent.favourite,
          ),
        ],
        backgroundColor:
            isDark ? CustomTheme.primaryColorDark : CustomTheme.whiteColor,
        currentIndex: _selectedIndex,
        selectedItemColor: CustomTheme.primaryColorRed,
        onTap: _onItemTapped,
        unselectedItemColor: CustomTheme.grey_transparent2,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }

  //renderAppBar
  Widget _renderAppBar() {
    return AppBar(
      backgroundColor:
          isDark ? CustomTheme.colorAccentDark : CustomTheme.primaryColor,
      title: activeSearch
          ? appBarSearchWidget()
          : Text(
              _widgetTitle.elementAt(_selectedIndex),
              style: TextStyle(
                fontFamily: _selectedIndex == 0 ? 'Horizon' : 'Montserrat',
              ),
            ),
    );
  }

  //appBarSearchWidget
  appBarSearchWidget() {
    return Container(
        height: 30,
        child: SearchTextField().getCustomEditTextField(
            style: CustomTheme.bodyText3White,
            focusNode: myFocusNode,
            hintValue: " ",
            onFieldSubmitted: _handleSubmitted));
  }

  //drawerContent
  Widget drawerContent(drawerListItem) {
    return ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        itemCount: drawerListItem.length,
        itemBuilder: (BuildContext context, int index) {
          if (index == 10)
            return ListTile(
              leading: SvgPicture.asset(
                'assets/drawer_icon/${drawerListItem.elementAt(index).navItemIcon}',
                color: CustomTheme.grey_60,
              ),
              title: Container(
                  color: drawerListItem.elementAt(index).isSelected
                      ? Colors.red
                      : Colors.transparent,
                  child: Text(drawerListItem.elementAt(10).navItemName,
                      style: TextStyle(color: CustomTheme.grey_60))),
              trailing: Switch(
                value: isDark,
                activeColor: CustomTheme.primaryColor,
                onChanged: (bool value) {
                  appModeBox.put('isDark', value);
                  setState(() {
                    isDark = value;
                  });
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      LandingScreen.route, (Route<dynamic> route) => false);
                },
              ),
            );
          return InkWell(
            child: ListTile(
              tileColor: drawerListItem.elementAt(index).isSelected
                  ? isDark
                      ? Colors.grey.shade900
                      : Colors.grey.shade200
                  : Colors.transparent,
              leading: SvgPicture.asset(
                'assets/drawer_icon/${drawerListItem.elementAt(index).navItemIcon}',
                color: CustomTheme.grey_60,
              ),
              title: Text(
                drawerListItem.elementAt(index).navItemName,
                style: TextStyle(
                    fontFamily: 'Montserrat',
                    color: drawerListItem.elementAt(index).isSelected
                        ? Colors.red
                        : CustomTheme.grey_60),
              ),
            ),
            onTap: () {
              printLog("index$index");
              setState(() {
                if (savedIndex != -1) {
                  drawerListItem.elementAt(savedIndex).isSelected = false;
                }
                drawerListItem[index].isSelected = true;
                savedIndex = index;
              });
              switch (index) {
                case 0:
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => LandingScreen()),
                      (Route<dynamic> route) => false);
                  break;
                case 1:
                  Navigator.pop(context);
                  Navigator.pushNamed(context, MoviesScreen.route,
                      arguments: true);
                  break;
                case 2:
                  Navigator.pop(context);
                  Navigator.pushNamed(context, TvSeriesScreen.route,
                      arguments: true);
                  break;
                // case 3:
                //   Navigator.pop(context);
                //   Navigator.pushNamed(context, LiveTvScreen.route, arguments: true);
                //   break;
                case 3:
                  Navigator.pop(context);
                  Navigator.pushNamed(context, GenreScreen.route,
                      arguments: true);

                  break;
                case 4:
                  Navigator.pop(context);
                  Navigator.pushNamed(context, AllCountryScreen.route,
                      arguments: true);
                  break;
                case 5:
                  Navigator.pop(context);
                  Navigator.pushNamed(context, MyProfileScreen.route);
                  break;
                case 6:
                  Navigator.pop(context);
                  Navigator.pushNamed(context, FavouriteScreen.route,
                      arguments: true);
                  break;
                case 7:
                  Navigator.pop(context);
                  Navigator.pushNamed(context, MySubscriptionScreen.route);
                  break;
                case 8:
                  Navigator.pop(context);
                  Navigator.pushNamed(context, SettingScreen.route);
                  break;
                case 9:
                  // Navigator.pop(context);
                  showDialog(
                      context: context,
                      builder: (dialogContext) {
                        return AlertDialog(
                          content: Text(AppContent.areYouSureLogout,
                              style: isDark
                                  ? CustomTheme.bodyText2White
                                  : CustomTheme.bodyText2),
                          backgroundColor:
                              isDark ? CustomTheme.darkGrey : Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(15)),
                          actionsPadding: EdgeInsets.only(right: 15.0),
                          actions: <Widget>[
                            GestureDetector(
                                onTap: () async {
                                  await FirebaseAuth.instance.signOut();
                                  Navigator.of(dialogContext)
                                      .pushAndRemoveUntil(
                                          MaterialPageRoute(
                                              builder: (dialogContext) =>
                                                  RenderFirstScreen()),
                                          (Route<dynamic> route) => false);
                                },
                                child: HelpMe().accountDeactivate(
                                    60, AppContent.yesText,
                                    height: 30.0)),
                            SizedBox(width: 8.0),
                            GestureDetector(
                                onTap: () {
                                  Navigator.of(context).pop();
                                },
                                child: HelpMe().submitButton(
                                    60, AppContent.noText,
                                    height: 30.0)),
                          ],
                        );
                      });
                  break;

                // case 11:
                //   Navigator.pop(context);
                //   Navigator.pushNamed(context, DownloadScreen.route);
                //   break;
              }
            },
          );
        });
  }

  //drawerContent
  Widget drawerContentWithoutLogin(drawerListItem) {
    return ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        itemCount: drawerListItem.length,
        itemBuilder: (BuildContext context, int index) {
          if (index == 7)
            return ListTile(
              leading: SvgPicture.asset(
                'assets/drawer_icon/${drawerListItem.elementAt(index).navItemIcon}',
                color: CustomTheme.grey_60,
              ),
              title: Container(
                  color: drawerListItem.elementAt(index).isSelected
                      ? Colors.red
                      : Colors.transparent,
                  child: Text(drawerListItem.elementAt(8).navItemName,
                      style: TextStyle(color: CustomTheme.grey_60))),
              trailing: Switch(
                value: isDark,
                activeColor: CustomTheme.primaryColor,
                onChanged: (bool value) {
                  appModeBox.put('isDark', value);
                  setState(() {
                    isDark = value;
                  });
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      LandingScreen.route, (Route<dynamic> route) => false);
                },
              ),
            );
          return InkWell(
            child: ListTile(
              tileColor: drawerListItem.elementAt(index).isSelected
                  ? isDark
                      ? Colors.grey.shade900
                      : Colors.grey.shade200
                  : Colors.transparent,
              leading: SvgPicture.asset(
                'assets/drawer_icon/${drawerListItem.elementAt(index).navItemIcon}',
                color: CustomTheme.grey_60,
              ),
              title: Text(
                drawerListItem.elementAt(index).navItemName,
                style: TextStyle(
                    color: drawerListItem.elementAt(index).isSelected
                        ? Colors.red
                        : CustomTheme.grey_60),
              ),
            ),
            onTap: () {
              printLog("index $index");
              setState(() {
                if (savedIndex != -1) {
                  drawerListItem.elementAt(savedIndex).isSelected = false;
                }
                drawerListItem[index].isSelected = true;
                savedIndex = index;
              });
              switch (index) {
                case 0:
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => LandingScreen()),
                      (Route<dynamic> route) => false);
                  break;
                case 1:
                  Navigator.pop(context);
                  Navigator.pushNamed(context, MoviesScreen.route,
                      arguments: true);
                  break;
                case 2:
                  Navigator.pop(context);
                  Navigator.pushNamed(context, TvSeriesScreen.route,
                      arguments: true);
                  break;
                // case 3:
                //   Navigator.pop(context);
                //   Navigator.pushNamed(context, LiveTvScreen.route, arguments: true);
                //   break;
                case 3:
                  Navigator.pop(context);
                  Navigator.pushNamed(context, GenreScreen.route,
                      arguments: true);
                  break;
                case 4:
                  Navigator.pop(context);
                  Navigator.pushNamed(context, AllCountryScreen.route,
                      arguments: true);
                  break;

                case 5:
                  Navigator.pop(context);
                  Navigator.pushNamed(context, FavouriteScreen.route,
                      arguments: true);
                  break;
                case 6:
                  Navigator.pop(context);
                  Navigator.pushNamed(context, SettingScreen.route);
                  break;
                case 7:
                  Navigator.pop(context);
                  Navigator.pushNamed(context, AuthScreen.route);
                  break;
                // case 9:
                //   Navigator.pop(context);
                //   Navigator.pushNamed(context, DownloadScreen.route,
                //       arguments: {'isDark': isDark});
                //   break;
              }
            },
          );
        });
  }
}
