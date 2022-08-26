import 'dart:async';
import 'dart:convert';

import 'package:app_links/app_links.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:oxoo/bloc/bloc.dart';
import 'package:oxoo/models/payment_object.dart';
import 'package:oxoo/network/api_configuration.dart';
import 'package:oxoo/screen/subscription/my_subscription_screen.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';

import '../../bloc/auth/registration_bloc.dart';
import '../../service/authentication_service.dart';
import 'bloc/auth/firebase_auth/firebase_auth_bloc.dart';
import 'bloc/auth/login_bloc.dart';
import 'bloc/auth/phone_auth/phone_auth_bloc.dart';
import 'constants.dart';
import 'models/configuration.dart';
import 'screen/auth/auth_screen.dart';
import 'screen/landing_screen.dart';
import 'server/phone_auth_repository.dart';
import 'server/repository.dart';
import 'service/get_config_service.dart';
import 'utils/route.dart';
import 'package:http/http.dart' as http;

class MyApp extends StatefulWidget {
  static final String route = "/MyApp";
  static GlobalKey<NavigatorState> navigationKey = GlobalKey<NavigatorState>();

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var appModeBox = Hive.box('appModeBox');
  static bool? isDark = true;
  static final _navigatorKey = GlobalKey<NavigatorState>();
  late AppLinks _appLinks;
  StreamSubscription<Uri>? _linkSubscription;

  late StreamSubscription? _conectionSubscription;
  late StreamSubscription _purchaseUpdatedSubscription;
  late StreamSubscription _purchaseErrorSubscription;
  List<PurchasedItem> _purchases = [];

  int amount = 0;
  String learnCombo = "";
  int timeCanUse = 0;
  int timeExp = 0;


  Future<http.Response> setVipUser(
    String amount,
  ) {
    String timePay = "ID" + DateTime.now().millisecondsSinceEpoch.toString();
    String userId = FirebaseAuth.instance.currentUser!.uid;
    Map<String, String> data = {
      "user_id":
      FirebaseAuth.instance.currentUser!.uid
    };
    String extraData =
    base64.encode(utf8.encode(json.encode(data)));
    return http.post(
        Uri.parse('https://apppanel.cnagroup.vn/rest_api/v1/new_vip_user'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'orderId': timePay,
          'requestId': timePay,
          'amount': amount,
          'extraData': extraData,
          'message': 'abcde',
          'orderInfo': 'Pay via apple $amount',
          'signature': 'Apple not signature'
        }));
  }

  Future<void> initPlatformState() async {
    // prepare
    var result = await FlutterInappPurchase.instance.initialize();
    print('result: $result');
    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;


    // refresh items for android
    try {
      String msg = await FlutterInappPurchase.instance.consumeAll();
      print('consumeAllItems: $msg');
    } catch (err) {
      print('consumeAllItems error: $err');
    }

    _conectionSubscription =
        FlutterInappPurchase.connectionUpdated.listen((connected) {
      print('connected: $connected');
    });
    _purchaseUpdatedSubscription =
        FlutterInappPurchase.purchaseUpdated.listen((productItem) async {
      print('purchase-updated: $productItem');

      ///start calculate time paid
      String id = productItem!.productId!;

      if (id == "com.idance.hocnhayonline.goihoc1thang") {
        int timePaid = productItem.transactionDate!.millisecondsSinceEpoch;
        appModeBox.put("amount", 45000);
        appModeBox.put("timePaid", timePaid);
        appModeBox.put("isUserValidSubscriber", true);
        await setVipUser('45000');
        Toast.show(
            "Đăng ký gói học 1 tháng thành công. Nếu bạn không xem được bài học, hãy thoát khởi động lại ứng dụng.");

        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => MySubscriptionScreen()),
            (Route<dynamic> route) => false);
      }

      if (id == "com.idance.hocnhayonline.goihoc3thang") {
        int timePaid = productItem.transactionDate!.millisecondsSinceEpoch;
        appModeBox.put("amount", 99000);
        appModeBox.put("timePaid", timePaid);
        appModeBox.put("isUserValidSubscriber", true);
        await setVipUser('99000');
        Toast.show(
            "Đăng ký gói học 3 tháng thành công. Nếu bạn không xem được bài học, hãy thoát khởi động lại ứng dụng.");

        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => MySubscriptionScreen()),
            (Route<dynamic> route) => false);
      }

      if (id == "com.idance.hocnhayonline.goihoc6thang") {
        int timePaid = productItem.transactionDate!.millisecondsSinceEpoch;
        appModeBox.put("amount", 149000);
        appModeBox.put("timePaid", timePaid);
        appModeBox.put("isUserValidSubscriber", true);
        await setVipUser('149000');

        Toast.show(
            "Đăng ký gói học 6 tháng thành công. Nếu bạn không xem được bài học, hãy thoát khởi động lại ứng dụng.");

        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => MySubscriptionScreen()),
            (Route<dynamic> route) => false);
      }

      ///end calculate time paid
    });

    _purchaseErrorSubscription =
        FlutterInappPurchase.purchaseError.listen((purchaseError) {
      print('purchase-error: $purchaseError');
      Toast.show("Lỗi thanh toán: $purchaseError");
    });
  }

  @override
  void initState() {
    super.initState();
    initPlatformState();
    // _getPurchaseHistory();
    isDark = appModeBox.get('isDark');
    if (isDark == null) {
      appModeBox.put('isDark', true);
    }
    initDeepLinks();
  }

  @override
  void dispose() {
    _linkSubscription?.cancel();

    if (_conectionSubscription != null) {
      _conectionSubscription!.cancel();
      _conectionSubscription = null;
    }
    super.dispose();
  }

  void openAppLink(Uri uri) {
    _navigatorKey.currentState?.pushNamed(uri.fragment);
  }

  Future<void> initDeepLinks() async {
    _appLinks = AppLinks();

    // Check initial link if app was in cold state (terminated)
    final appLink = await _appLinks.getInitialAppLink();
    if (appLink != null) {
      print('getInitialAppLink: $appLink');
      openAppLink(appLink);
    }

    // Handle link when app is in warm state (front or background)
    _linkSubscription = _appLinks.uriLinkStream.listen((uri) {
      print('onAppLink: $uri');
      openAppLink(uri);
      checkPaymentUser();
    });
  }

  checkPaymentUser() async {
    if (FirebaseAuth.instance.currentUser != null) {
      final response = await http.get(Uri.parse(ConfigApi().getPaymentStatusUrl(
          FirebaseAuth.instance.currentUser!.uid.toString())));
      if (response.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.
        var paymentObject = PaymentObject.fromJson(jsonDecode(response.body));
        if (paymentObject.data != null) {
          Data data = paymentObject.data![paymentObject.data!.length - 1];
          if (data.userId != null) {
            int timePaid = int.parse(data.requestId!.substring(2));
            int amount = int.parse(data.amount!);
            appModeBox.put("amount", amount);
            appModeBox.put("timePaid", timePaid);

            if (amount == 50000 || amount == 45000) {
              int timeNow = DateTime.now().millisecondsSinceEpoch;
              int timeUseService = timeNow - timePaid;
              if (timeUseService > 2678400000) {
                appModeBox.put("isUserValidSubscriber", false);
              } else {
                appModeBox.put("isUserValidSubscriber", true);
              }
              Toast.show("Bạn đã đăng ký thành công gói cước 1 tháng.",
                  duration: Toast.lengthLong, gravity: Toast.bottom);
              Navigator.popAndPushNamed(context, MySubscriptionScreen.route);
            }
            if (amount == 120000 || amount == 99000) {
              int timeNow = DateTime.now().millisecondsSinceEpoch;
              int timeUseService = timeNow - timePaid;
              if (timeUseService > 8035200000) {
                appModeBox.put("isUserValidSubscriber", false);
              } else {
                appModeBox.put("isUserValidSubscriber", true);
              }
              Toast.show("Bạn đã đăng ký thành công gói cước 3 tháng.",
                  duration: Toast.lengthLong, gravity: Toast.bottom);

              Navigator.popAndPushNamed(context, MySubscriptionScreen.route);
            }
            if (amount == 150000 || amount == 149000) {
              int timeNow = DateTime.now().millisecondsSinceEpoch;
              int timeUseService = timeNow - timePaid;
              if (timeUseService > 16070400000) {
                appModeBox.put("isUserValidSubscriber", false);
              } else {
                appModeBox.put("isUserValidSubscriber", true);
              }
              Toast.show("Bạn đã đăng ký thành công gói cước 6 tháng.",
                  duration: Toast.lengthLong, gravity: Toast.bottom);

              Navigator.popAndPushNamed(context, MySubscriptionScreen.route);
            }
          }
        }
      } else {
        throw Exception('Failed to load album');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return FutureBuilder(
      future: Init.instance.initialize(),
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const MaterialApp(
              debugShowCheckedModeBanner: false, home: Splash());
        } else {
          return startActivity(context);
        }
      },
    );
  }
}

class Splash extends StatelessWidget {
  const Splash({Key? key}) : super(key: key);
  static bool? isDark = true;
  static bool? isUserValidSubscriber = false;

  get appModeBox => Hive.box("appModeBox");

  @override
  Widget build(BuildContext context) {
    isDark = appModeBox.get('isDark');
    if (isDark == null) {
      appModeBox.put('isDark', true);
    }

    // bool lightMode =
    //     MediaQuery.of(context).platformBrightness == Brightness.light;
    return Scaffold(
      backgroundColor:
          isDark! ? const Color(0xffe1f5fe) : const Color(0xff042a49),
      body: Center(
          child: isDark!
              ? Image.asset(
                  'assets/dark_splash_screen.gif',
                  fit: BoxFit.fill,
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  alignment: Alignment.center,
                )
              : Image.asset(
                  'assets/light_splash_screen.gif',
                  fit: BoxFit.cover,
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  alignment: Alignment.center,
                )),
    );
  }
}

class Init {
  Init._();

  static final instance = Init._();

  Future initialize() async {
    await Future.delayed(const Duration(seconds: 3));
  }
}

Widget startActivity(BuildContext context) {
  return AfterSplash();
}

class AfterSplash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthService>(
          create: (context) => AuthService(),
        ),
        Provider<GetConfigService>(
          create: (context) => GetConfigService(),
        ),
      ],
      child: MultiBlocProvider(
          providers: [
            BlocProvider<HomeContentBloc>(
                create: (context) => HomeContentBloc(repository: Repository())),
            // BlocProvider<LoginBloc>(
            //   create: (context) => LoginBloc(Repository()),
            // ),
            BlocProvider<PhoneAuthBloc>(
                create: (context) =>
                    PhoneAuthBloc(userRepository: UserRepository())),
            // BlocProvider<RegistrationBloc>(
            //   create: (context) => RegistrationBloc(Repository()),
            // ),
            BlocProvider<FirebaseAuthBloc>(
              create: (context) => FirebaseAuthBloc(Repository()),
            ),
          ],
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            routes: Routes.getRoute(),
            home: RenderFirstScreen(),
          )),
    );
  }
}

// ignore: must_be_immutable
class RenderFirstScreen extends StatelessWidget {
  static final String route = "/RenderFirstScreen";
  bool? isMandatoryLogin = false;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Hive.box<ConfigurationModel>('configBox').listenable(),
      builder: (context, dynamic box, widget) {
        isMandatoryLogin = box.get(0).appConfig.mandatoryLogin;
        printLog("isMandatoryLogin " + "$isMandatoryLogin");
        return renderFirstScreen(isMandatoryLogin!);
      },
    );
  }

  Widget renderFirstScreen(bool isMandatoryLogin) {
    print(isMandatoryLogin);
    if (isMandatoryLogin) {
      return AuthScreen();
    } else {
      return LandingScreen();
    }
  }
}
