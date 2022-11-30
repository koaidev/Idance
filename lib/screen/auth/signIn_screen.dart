import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';

import '../../constants.dart';
import '../../models/user.dart';
import '../../network/api_firebase.dart';
import '../../screen/auth/sign_up_screen.dart';
import '../../screen/landing_screen.dart';
import '../../strings.dart';
import '../../style/theme.dart';
import '../../utils/button_widget.dart';
import '../../utils/edit_text_utils.dart';
import '../../utils/loadingIndicator.dart';
import '../../utils/validators.dart';

class LoginPage extends StatefulWidget {
  static final String route = '/LoginScreen';

  LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  final resetPassFormKey = GlobalKey<FormState>();
  TextEditingController loginEmailController = new TextEditingController();
  TextEditingController loginPasswordController = new TextEditingController();
  TextEditingController resetPassEmailController = new TextEditingController();

  bool isLoading = false;
  bool _isLogged = false, isDark = false;
  var appModeBox = Hive.box('appModeBox');

  @override
  void initState() {
    super.initState();
    isDark = appModeBox.get('isDark') ?? false;
    isDark = false;
    _isLogged = false;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    printLog("_LoginPageState");
    _isLogged = ApiFirebase().isLogin();
    return !_isLogged
        ? new Scaffold(
            key: _scaffoldKey,
            appBar: AppBar(
              elevation: 1.0,
              backgroundColor:
                  isDark ? CustomTheme.darkGrey : CustomTheme.primaryColor,
              title: Text(AppContent.goBack),
            ),
            body: Container(
                height: MediaQuery.of(context).size.height,
                // color: isDark
                //     ? CustomTheme.primaryColorDark
                //     : CustomTheme.whiteColor,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/images/background.png"),
                        fit: BoxFit.cover)),
                child: _renderLoginWidget()))
        : LandingScreen();
  }

  Widget _renderLoginWidget() {
    return SingleChildScrollView(
        child: Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 10.0),
                  child: Image.asset('assets/logo.png', scale: 5),
                ),
                Container(
                  padding: EdgeInsets.only(top: 20.0),
                  child: Container(
                    margin:
                        EdgeInsets.only(bottom: 30.0, left: 10.0, right: 10.0),
                    decoration: new BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      boxShadow: CustomTheme.boxShadow,
                      color:
                          isDark ? CustomTheme.colorAccentDark : Colors.white,
                    ),
                    height: 310,
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: 10.0),
                        Text(
                          AppContent.signIn,
                          style: CustomTheme.authTitle,
                        ),
                        SizedBox(height: 10.0),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20.0,
                          ),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              children: <Widget>[
                                EditTextUtils().getCustomEditTextField(
                                  hintValue: AppContent.emailAddress,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                        RegExp("[a-z A-Z 0-9]"))
                                  ],
                                  keyboardType: TextInputType.name,
                                  controller: loginEmailController,
                                  style: isDark
                                      ? CustomTheme.authTitleGrey
                                      : CustomTheme.authTitle,
                                  underLineInputBorderColor: isDark
                                      ? CustomTheme.grey_transparent2
                                      : CustomTheme.primaryColor,
                                  // validator: (value) {
                                  //   return validateEmail(value);
                                  // }
                                ),
                                SizedBox(height: 10),
                                EditTextUtils().getCustomEditTextField(
                                    hintValue: AppContent.password,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(
                                          RegExp("[a-zA-Z0-9]"))
                                    ],
                                    keyboardType: TextInputType.text,
                                    controller: loginPasswordController,
                                    underLineInputBorderColor: isDark
                                        ? CustomTheme.grey_transparent2
                                        : CustomTheme.primaryColor,
                                    style: isDark
                                        ? CustomTheme.authTitleGrey
                                        : CustomTheme.authTitle,
                                    obscureValue: true,
                                    validator: (value) {
                                      return validateMinLength(value);
                                    }),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 10.0),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20.0,
                          ),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: CustomTheme.primaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                            ),
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                setState(() async {
                                  isLoading = true;
                                  await signInWithEmailAndPassword(
                                          loginEmailController.text
                                                  .replaceAll(" ", "") +
                                              "@gmail.com",
                                          loginPasswordController.text)
                                      .then((value) async {
                                    if (value?.user != null) {
                                      if (!await ApiFirebase()
                                          .checkUserIsExits()) {
                                        final user = value!.user!;
                                        final userIDance = UserIDance(
                                            name: user.displayName,
                                            phone: user.phoneNumber,
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
                                      showShortToast(
                                          "Lỗi đã xảy ra. Vui lòng thử cách khác.",
                                          context);
                                      setState(() {
                                        isLoading = false;
                                      });
                                    }
                                  });
                                });
                              }
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 15.0, horizontal: 20.0),
                                child: Center(
                                    child: Text(
                                  AppContent.signIn,
                                  style: TextStyle(color: Colors.white),
                                )),
                              ),
                            ),
                          ),
                        ),
                        HelpMe().space(10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              AppContent.newUser,
                              style: CustomTheme.bodyTextgray2,
                            ),
                            InkWell(
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, SignUpScreen.route);
                                },
                                child: Text(
                                  AppContent.signup,
                                  style: CustomTheme.coloredBodyText2,
                                ))
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        if (isLoading) Center(child: spinkit),
      ],
    ));
  }

  Future<UserCredential?> signInWithEmailAndPassword(
      String emailAddress, String password) async {
    try {
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: emailAddress, password: password);
      return credential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
      return null;
    }
  }
}
