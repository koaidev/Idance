import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:oxoo/bloc/bloc.dart';
import 'package:provider/provider.dart';

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

class MyApp extends StatefulWidget {
  static final String route = "/MyApp";

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var appModeBox = Hive.box('appModeBox');
  static bool? isDark = true;

  @override
  void initState() {
    super.initState();
    isDark = appModeBox.get('isDark');
    if (isDark == null) {
      appModeBox.put('isDark', true);
    }
  }

  @override
  Widget build(BuildContext context) {

    return FutureBuilder(
      future: Init.instance.initialize(),
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const MaterialApp(home: Splash());
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
    // This is where you can initialize the resources needed by your app while
    // the splash screen is displayed.  Remove the following example because
    // delaying the user experience is a bad design practice!
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
            BlocProvider<LoginBloc>(
              create: (context) => LoginBloc(Repository()),
            ),
            BlocProvider<PhoneAuthBloc>(
                create: (context) =>
                    PhoneAuthBloc(userRepository: UserRepository())),
            BlocProvider<RegistrationBloc>(
              create: (context) => RegistrationBloc(Repository()),
            ),
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
    // return LandingScreen();
  }
}
