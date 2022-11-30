import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:oxoo/models/user.dart';
import 'package:oxoo/network/api_firebase.dart';

import '../../constants.dart';
import '../../screen/landing_screen.dart';
import '../../strings.dart';
import '../../style/theme.dart';
import '../../utils/edit_text_utils.dart';
import '../../utils/validators.dart';

class SignUpScreen extends StatefulWidget {
  static final String route = '/SignUpScreen';

  SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() {
    // TODO: implement createState
    return _SignUpScreenState();
  }
}

class _SignUpScreenState extends State<SignUpScreen>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _signUpFormkey = GlobalKey<FormState>();
  TextEditingController loginNameController = new TextEditingController();
  TextEditingController loginEmailController = new TextEditingController();
  TextEditingController loginPasswordController = new TextEditingController();
  late bool _isRegistered;
  bool isMandatoryLogin = false;
  bool isLoading = false;
  late bool isDark;
  var appModeBox = Hive.box('appModeBox');

  @override
  void initState() {
    super.initState();
    isDark = appModeBox.get('isDark') ?? false;
    isDark = false;
    _isRegistered = false;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    printLog("_SignUpScreenState");

    ///read user data from phone(flutter hive box)
    _isRegistered = ApiFirebase().isLogin();
    return new Scaffold(
        key: _scaffoldKey,
        body: _isRegistered ? LandingScreen() : _renderRegisterWidget());
  }

  Widget _renderRegisterWidget() {
    return Scaffold(
      appBar: AppBar(
        elevation: 1.0,
        backgroundColor:
            isDark ? CustomTheme.darkGrey : CustomTheme.primaryColor,
        title: Text(AppContent.backToLogin),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/background.png"),
                fit: BoxFit.cover)),
        child: SingleChildScrollView(
            child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Stack(
              children: <Widget>[
                Container(
                  // height: MediaQuery.of(context).size.height / 2.2,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage("assets/images/background.png"),
                          fit: BoxFit.cover)),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 40.0),
                      child: Image.asset('assets/logo.png', scale: 5),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 23.0),
                      child: Column(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(
                                bottom: 10.0, left: 10.0, right: 10.0),
                            decoration: new BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                              boxShadow: CustomTheme.boxShadow,
                              color: isDark
                                  ? CustomTheme.colorAccentDark
                                  : Colors.white,
                            ),
                            height: 340.0,
                            child: Column(
                              children: <Widget>[
                                SizedBox(height: 10.0),
                                Text(
                                  AppContent.signup,
                                  style: CustomTheme.authTitle,
                                ),
                                SizedBox(height: 10),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0,
                                  ),
                                  child: Form(
                                    key: _signUpFormkey,
                                    child: Column(
                                      children: <Widget>[
                                        EditTextUtils().getCustomEditTextField(
                                            hintValue: AppContent.fullName,
                                            keyboardType: TextInputType.text,
                                            controller: loginNameController,
                                            style: isDark
                                                ? CustomTheme.authTitleGrey
                                                : CustomTheme.authTitle,
                                            underLineInputBorderColor: isDark
                                                ? CustomTheme.grey_transparent2
                                                : CustomTheme.primaryColor,
                                            validator: (value) {
                                              return validateNotEmpty(value);
                                            }),
                                        SizedBox(height: 10),
                                        EditTextUtils().getCustomEditTextField(
                                          hintValue: AppContent.emailAddress,
                                          keyboardType: TextInputType.name,
                                          style: isDark
                                              ? CustomTheme.authTitleGrey
                                              : CustomTheme.authTitle,
                                          underLineInputBorderColor: isDark
                                              ? CustomTheme.grey_transparent2
                                              : CustomTheme.primaryColor,
                                          inputFormatters: [
                                            FilteringTextInputFormatter.allow(
                                                RegExp("[a-z A-Z 0-9]"))
                                          ],
                                          controller: loginEmailController,
                                        ),
                                        SizedBox(height: 10),
                                        EditTextUtils().getCustomEditTextField(
                                            hintValue: AppContent.password,
                                            keyboardType: TextInputType.text,
                                            style: isDark
                                                ? CustomTheme.authTitleGrey
                                                : CustomTheme.authTitle,
                                            underLineInputBorderColor: isDark
                                                ? CustomTheme.grey_transparent2
                                                : CustomTheme.primaryColor,
                                            controller: loginPasswordController,
                                            obscureValue: true,
                                            inputFormatters: [
                                              FilteringTextInputFormatter.allow(
                                                  RegExp("[a-zA-Z0-9]"))
                                            ],
                                            validator: (value) {
                                              return validateMinLength(value);
                                            }),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(height: 20.0),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0,
                                  ),
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      primary: CustomTheme.primaryColor,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                      ),
                                    ),
                                    onPressed: () {
                                      if (_signUpFormkey.currentState!
                                          .validate()) {
                                        setState(() async {
                                          isLoading = true;
                                          await register(
                                                  loginEmailController.text
                                                          .replaceAll(" ", "") +
                                                      "@gmail.com",
                                                  loginPasswordController.text)
                                              .then((value) async {
                                            final user = value?.user;
                                            if (user != null) {
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
                                              final response =
                                                  await ApiFirebase()
                                                      .register(userIDance);
                                              if (response) {
                                                Navigator.of(context)
                                                    .pushAndRemoveUntil(
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                LandingScreen()),
                                                        (Route<dynamic>
                                                                route) =>
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
                                          horizontal: 20.0,
                                          vertical: 15.0,
                                        ),
                                        child: Center(
                                          child: Text(
                                            AppContent.register,
                                            style: CustomTheme.authTitleWhite,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 10.0),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            if (isLoading)
              Center(
                child: CircularProgressIndicator(),
              ),
          ],
        )),
      ),
    );
  }

  Future<UserCredential?> register(String email, String password) async {
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
    return null;
  }
}
