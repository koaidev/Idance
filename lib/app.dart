import 'dart:async';
import 'dart:io';

import 'package:app_links/app_links.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:kochava_tracker/kochava_tracker.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:oxoo/bloc/bloc.dart';
import 'package:oxoo/update/update_screen.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';

import 'config.dart';
import 'constants.dart';
import 'models/configuration.dart';
import 'screen/auth/auth_screen.dart';
import 'screen/landing_screen.dart';
import 'server/repository.dart';
import 'service/get_config_service.dart';
import 'utils/route.dart';

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
  StreamSubscription? _conectionSubscription;
  String _deviceId = 'N/A';
  int amount = 0;
  String learnCombo = "";
  int timeCanUse = 0;
  int timeExp = 0;
  var isUpdate = false;

  Future<void> startSdk() async {
    // Start the Kochava SDK.
    KochavaTracker.instance.enableIosAtt();
    KochavaTracker.instance.setIosAttAuthorizationWaitTime(90);
    KochavaTracker.instance.registerAndroidAppGuid("koidance-8amcyxp");
    KochavaTracker.instance.registerIosAppGuid("koidance-cqpt1gi");
    KochavaTracker.instance.setLogLevel(KochavaTrackerLogLevel.Trace);
    KochavaTracker.instance.start();

    // Retrieve the Kochava Device ID.
    String deviceId = await KochavaTracker.instance.getDeviceId();

    if (!mounted) return;

    setState(() {
      _deviceId = deviceId;
    });
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

    FlutterInappPurchase.purchaseError.listen((purchaseError) {
      print('purchase-error: $purchaseError');
      Toast.show("Lỗi thanh toán: $purchaseError");
    });
  }

  @override
  void initState() {
    super.initState();
    // _getPurchaseHistory();
    initPlatformState();
    startSdk();
    isDark = appModeBox.get('isDark');
    if (isDark == null) {
      appModeBox.put('isDark', true);
    }
    initDeepLinks();
    initOneSignal();
    if (Platform.isAndroid) {
      checkUpdateAndroid().then((value) => {
            setState(() {
              isUpdate = value;
            })
          });
    }
    if (Platform.isIOS) {
      checkUpdateIOS().then((value) => {
            setState(() {
              isUpdate = value;
            })
          });
    }
  }

  Future<bool> checkUpdateAndroid() async {
    final response = await FirebaseFirestore.instance
        .collection("config")
        .doc("config")
        .get();
    final int currentVersion = response.get("version_android");
    return currentVersion > Config.appVersion;
  }

  Future<bool> checkUpdateIOS() async {
    final response = await FirebaseFirestore.instance
        .collection("config")
        .doc("config")
        .get();
    final int currentVersion = response.get("version_ios");
    return currentVersion > Config.appVersion;
  }

  Future<void> initOneSignal() async {
    if (!mounted) return;
    OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);
    OneSignal.shared.setRequiresUserPrivacyConsent(true);
    OneSignal.shared.setNotificationOpenedHandler((openedResult) {});
    OneSignal.shared.setAppId(Config.oneSignalID);
    // iOS-only method to open launch URLs in Safari when set to false
    OneSignal.shared.setLaunchURLsInApp(false);
    OneSignal.shared.promptUserForPushNotificationPermission().then((accepted) {
      print("Accepted permission: $accepted");
    });

    OneSignal.shared.setNotificationWillShowInForegroundHandler(
        (OSNotificationReceivedEvent event) {
      // Will be called whenever a notification is received in foreground
      // Display Notification, pass null param for not displaying the notification
      event.complete(event.notification);
    });

    OneSignal.shared
        .setNotificationOpenedHandler((OSNotificationOpenedResult result) {
      // Will be called whenever a notification is opened/button pressed.
    });

    OneSignal.shared.setPermissionObserver((OSPermissionStateChanges changes) {
      // Will be called whenever the permission changes
      // (ie. user taps Allow on the permission prompt in iOS)
    });

    OneSignal.shared
        .setSubscriptionObserver((OSSubscriptionStateChanges changes) {
      // Will be called whenever the subscription changes
      // (ie. user gets registered with OneSignal and gets a user ID)
    });

    OneSignal.shared.setEmailSubscriptionObserver(
        (OSEmailSubscriptionStateChanges emailChanges) {
      // Will be called whenever then user's email subscription changes
      // (ie. OneSignal.setEmail(email) is called and the user gets registered
    });
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
    });
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
          return startActivity(context, isUpdate);
        }
      },
    );
  }
}

class Splash extends StatelessWidget {
  const Splash({Key? key}) : super(key: key);
  static bool? isDark = true;

  get appModeBox => Hive.box("appModeBox");

  @override
  Widget build(BuildContext context) {
    isDark = appModeBox.get('isDark');
    if (isDark == null) {
      appModeBox.put('isDark', true);
    }

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

Widget startActivity(BuildContext context, bool isUpdate) {
  return AfterSplash(
    isUpdate: isUpdate,
  );
}

class AfterSplash extends StatelessWidget {
  final bool isUpdate;

  AfterSplash({required this.isUpdate});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
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
          ],
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            routes: Routes.getRoute(),
            home: RenderFirstScreen(
              isUpdate: isUpdate,
            ),
          )),
    );
  }
}

// ignore: must_be_immutable
class RenderFirstScreen extends StatelessWidget {
  static final String route = "/RenderFirstScreen";
  bool? isMandatoryLogin = false;
  bool isUpdate;

  RenderFirstScreen({Key? key, required this.isUpdate}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Hive.box<ConfigurationModel>('configBox').listenable(),
      builder: (context, dynamic box, widget) {
        isMandatoryLogin = box.get(0).appConfig.mandatoryLogin;
        printLog("isMandatoryLogin " + "$isMandatoryLogin");
        if (isUpdate) {
          return UpdateScreen();
        } else {
          return renderFirstScreen(isMandatoryLogin!);
        }
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
