import 'dart:async';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hive/hive.dart';
import 'package:oxoo/network/api_firebase.dart';
import 'package:toast/toast.dart';

import '../../constants.dart';
import '../../models/user.dart';
import '../../screen/landing_screen.dart';
import '../../strings.dart';
import '../../style/theme.dart';
import '../../utils/button_widget.dart';
import '../../utils/validators.dart';
import 'signIn_screen.dart';

class AuthScreen extends StatefulWidget {
  static final String route = '/AuthScreen';
  final bool? fromPaidScreen;

  const AuthScreen({Key? key, this.fromPaidScreen}) : super(key: key);

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool isLoading = false;
  var appModeBox = Hive.box('appModeBox');
  late bool fromPaidScreen;
  late bool _isLogged;
  late bool isDark;

  @override
  void initState() {
    fromPaidScreen = widget.fromPaidScreen ?? false;
    isDark = appModeBox.get('isDark') ?? false;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    printLog("_AuthScreenState");
    ToastContext().init(context);
    _isLogged = ApiFirebase().isLogin();

    if (_isLogged) {
      return LandingScreen();
    } else {
      return Scaffold(
        appBar: fromPaidScreen
            ? AppBar(
                backgroundColor:
                    isDark ? CustomTheme.darkGrey : CustomTheme.primaryColor,
                title: Text(AppContent.goBack))
            : PreferredSize(
                preferredSize: Size.fromHeight(0.0),
                child: Container(
                  width: 0.0,
                  height: 0.0,
                )),
        backgroundColor: isDark ? CustomTheme.primaryColorDark : Colors.black,
        body: SingleChildScrollView(
          child: Stack(
            alignment: Alignment.center,
            children: [
              Stack(
                alignment: Alignment.bottomLeft,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    decoration: isDark
                        ? BoxDecoration(
                            image: DecorationImage(
                                image:
                                    AssetImage('assets/dark_splash_screen.gif'),
                                fit: BoxFit.cover))
                        : BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage(
                                    'assets/light_splash_screen.gif'),
                                fit: BoxFit.cover)),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // socialAuthWidget(
                      //     color: CustomTheme.royalBlue,
                      //     title: AppContent.loginWithFacebook,
                      //     imagePath: "ic_button_facebook",
                      //     function: signInWithFacebook),
                      socialAuthWidget(
                        color: CustomTheme.dodgerBlue,
                        title: AppContent.loginWithGoogle,
                        imagePath: "ic_button_google",
                        function: signInWithGoogle,
                      ),
                      InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginPage()));
                          },
                          child: mailAuthWidget(
                              color: CustomTheme.salmonColor,
                              title: AppContent.loginWithEmail,
                              imagePath: "logo")),
                      if (Platform.isIOS)
                        socialAuthWidget(
                            color: Colors.white,
                            title: AppContent.loginWithApple,
                            imagePath: "ic_button_apple",
                            function: signInWithApple,
                            isApple: true),
                      HelpMe().space(90.0),
                    ],
                  ),
                ],
              ),
              isLoading ? CircularProgressIndicator() : Text(""),
            ],
          ),
        ),
      );
    }
  }

  Widget socialAuthWidget(
      {Color? color,
      String? title,
      String? imagePath,
      Function? function,
      bool isApple = false,
      Color? titleColor}) {
    return InkWell(
      onTap: () async {
        setState(() {
          isLoading = true;
        });
        UserCredential fbUser = await function!();
        if (fbUser.user != null) {

          if (!await ApiFirebase()
              .checkUserIsExits()) {
            final user = fbUser.user!;
            final userIDance = UserIDance(
                name: user.displayName,
                phone: user.phoneNumber?.replaceAll("+84", "0"),
                uid: user.uid,
                currentPlan: "free",
                dateCreate: DateTime.now()
                    .millisecondsSinceEpoch,
                email: user.email,
                fcmToken: user.refreshToken,
                image: user.photoURL,
                lastPlanDate: DateTime.now()
                    .millisecondsSinceEpoch);
            final response = await ApiFirebase()
                .register(userIDance);
            if (response) {
              Navigator.of(context)
                  .pushAndRemoveUntil(
                  MaterialPageRoute(
                      builder:
                          (context) =>
                          LandingScreen()),
                      (Route<dynamic> route) =>
                  false);
            } else {
              showShortToast(
                  "Lỗi đã xảy ra. Vui lòng thử cách khác.",
                  context);
              setState(() {
                isLoading = false;
              });
            }
          } else {
            Navigator.of(context)
                .pushAndRemoveUntil(
                MaterialPageRoute(
                    builder:
                        (context) =>
                        LandingScreen()),
                    (Route<dynamic> route) =>
                false);
          }
        } else {
          showShortToast("Lỗi đã xảy ra. Vui lòng thử cách khác.", context);
          setState(() {
            isLoading = false;
          });
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
        child: Container(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 10.0,
                ),
                Image.asset(
                  'assets/images/$imagePath.png',
                  width: 20.0,
                  height: 20.0,
                ),
                Spacer(flex: 1),
                Text(title!,
                    style: isApple
                        ? CustomTheme.authBtnTitleBlack
                        : CustomTheme.authBtnTitle),
                Spacer(flex: 1),
                SizedBox(
                  width: 10.0,
                ),
              ],
            ),
          ),
          decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.all(Radius.circular(4.0))),
        ),
      ),
    );
  }

  Widget mailAuthWidget(
      {Color? color, required String title, String? imagePath}) {
    return InkWell(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
        child: Container(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 10,
                ),
                Image.asset(
                  'assets/images/$imagePath.png',
                  width: 20.0,
                  height: 20.0,
                ),
                Spacer(
                  flex: 1,
                ),
                Text(
                  title,
                  style: CustomTheme.authBtnTitle,
                ),
                Spacer(
                  flex: 1,
                ),
                SizedBox(
                  width: 10.0,
                ),
              ],
            ),
          ),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.all(Radius.circular(4.0)),
          ),
        ),
      ),
    );
  }

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  Future<UserCredential> signInWithFacebook() async {
    // Trigger the sign-in flow
    final LoginResult loginResult = await FacebookAuth.instance.login();
    print("LoginFB: ${loginResult.accessToken}");
    // Create a credential from the access token
    final OAuthCredential facebookAuthCredential =
        FacebookAuthProvider.credential(loginResult.accessToken!.token);

    // Once signed in, return the UserCredential
    return FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
  }

  Future<UserCredential> signInWithApple() async {
    final appleProvider = AppleAuthProvider();
    return FirebaseAuth.instance.signInWithProvider(appleProvider);
  }
}
