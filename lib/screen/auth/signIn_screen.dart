import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

import '../../bloc/auth/firebase_auth/firebase_auth_bloc.dart';
import '../../bloc/auth/firebase_auth/firebase_auth_event.dart';
import '../../bloc/auth/firebase_auth/firebase_auth_state.dart';
import '../../constants.dart';
import '../../models/user_model.dart';
import '../../screen/auth/sign_up_screen.dart';
import '../../screen/landing_screen.dart';
import '../../service/authentication_service.dart';
import '../../strings.dart';
import '../../style/theme.dart';
import '../../utils/button_widget.dart';
import '../../utils/edit_text_utils.dart';
import '../../utils/loadingIndicator.dart';
import '../../utils/validators.dart';
import '../pass_reset_screen.dart';

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

  // late Bloc bloc;
  late Bloc firebaseAuthBloc;

  bool isLoading = false;
  bool _isLogged = false, isDark = false;
  var appModeBox = Hive.box('appModeBox');

  @override
  void initState() {
    super.initState();
    // bloc = BlocProvider.of<LoginBloc>(context);
    firebaseAuthBloc = BlocProvider.of<FirebaseAuthBloc>(context);
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
    final authService = Provider.of<AuthService>(context);
    _isLogged = authService.getUser() != null ? true : false;
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
                child: _renderLoginWidget(authService)))
        : LandingScreen();
  }

  Widget _renderLoginWidget(AuthService authService) {
    return BlocListener<FirebaseAuthBloc, FirebaseAuthState>(
        listener: (context, state) {
      if (state is FirebaseAuthStateCompleted) {
        AuthUser? user = state.getUser;
        if (user == null) {
          firebaseAuthBloc.add(FirebaseAuthFailed);
        } else {
          // print(user.toJson().toString());
          authService.updateUser(user);
          isLoading = false;
          if (authService.getUser() != null) {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => LandingScreen()),
                (Route<dynamic> route) => false);
          }
        }
      } else if (state is FirebaseAuthFailedState) {
        firebaseAuthBloc.add(FirebaseAuthNotStarted());
      }
    }, child: BlocBuilder<FirebaseAuthBloc, FirebaseAuthState>(
            builder: (context, state) {
      return SingleChildScrollView(
          child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Stack(
            children: <Widget>[
              //app logo bg
              // Container(
              //   height: MediaQuery.of(context).size.height / 2.2,
              //   decoration: BoxDecoration(
              //     color: isDark
              //         ? CustomTheme.darkGrey
              //         : CustomTheme.primaryColor,
              //   ),
              // ),
              Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 10.0),
                    child: Image.asset('assets/logo.png', scale: 5),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 20.0),
                    child: Container(
                      margin: EdgeInsets.only(
                          bottom: 30.0, left: 10.0, right: 10.0),
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
                                    firebaseAuthBloc.add(FirebaseAuthStarted());
                                    await signInWithEmailAndPassword(
                                            loginEmailController.text
                                                    .replaceAll(" ", "") +
                                                "@gmail.com",
                                            loginPasswordController.text)
                                        .then((value) => {
                                              firebaseAuthBloc
                                                  .add(FirebaseAuthCompleting(
                                                uid: value!.uid,
                                                email: value.email,
                                                phone: value.phoneNumber,
                                              ))
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
                          SizedBox(
                            height: 8.0,
                          ),
                          InkWell(
                              onTap: () {
                                Navigator.pushNamed(
                                    context, ResetPassword.route);
                              },
                              child: Text(
                                AppContent.forgetPassword,
                                style: isDark
                                    ? CustomTheme.subTextBoldWhite
                                    : CustomTheme.subTextBold,
                              ))
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
    }));
  }

  Future<User?> signInWithEmailAndPassword(
      String emailAddress, String password) async {
    try {
      final userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: emailAddress, password: password);
      final User? user = userCredential.user;

      if (user != null) {
        // if (user.email != null && user.email != "") {
        //   assert(user.email != null);
        // }
        // assert(user.displayName != null);
        // assert(!user.isAnonymous);

        final User currentUser = FirebaseAuth.instance.currentUser!;
        assert(user.uid == currentUser.uid);

        // Once signed in, return the UserCredential
        return user;
      } else {
        return null;
      }
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
