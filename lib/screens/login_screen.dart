import 'package:address_manager/helpers/auth_helper.dart';
import 'package:address_manager/helpers/ui_helper.dart';
import 'package:flutter/material.dart';

import '../components/loader.dart';
import '../controller/user_controller.dart';
import '../routes/routes.dart';
import '../screens/home_screen.dart';
import '../tools/colors.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  UserController _userController = UserController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  Container errorBox = Container();
  String errorMessage = '';

  bool alreadySignedToggle = false;
  bool alreadySigned = false;
  bool firstLaunch = true;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    if (!alreadySignedToggle) {
      Future.delayed(Duration(seconds: 2), () async {
        _userController.checkSignIn().then((res) {
          alreadySignedToggle = true;
          setState(() {
            alreadySigned = res;
            firstLaunch = false;
          });
        });
      });
    }
  }

  updateErrorMessage() {
    setState(() {
      errorBox = Container();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: alreadySignedToggle
          ? (alreadySigned
          ? Home()
          : Center(
        child: Padding(
          padding: EdgeInsets.only(top: 30.0),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Text(
                  'Welcome,',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'sign in to continue',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey),
                ),
                Padding(
                  padding: const EdgeInsets.all(40.0),
                  child: Container(
                    child: Column(
                      children: <Widget>[
                        errorBox,
                        TextField(
                          decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.person,
                                color: Colors.black,
                              ),
                              focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.black)),
                              alignLabelWithHint: true,
                              hintText: 'email',
                              hintStyle:
                              TextStyle(color: Colors.black)),
                          cursorColor: Colors.black,
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                          keyboardType: TextInputType.emailAddress,
                          controller: emailController,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextField(
                          cursorColor: Colors.black,
                          obscureText: true,
                          decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.lock,
                                color: Colors.black,
                              ),
                              focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.black)),
                              alignLabelWithHint: true,
                              hintText: 'password',
                              hintStyle:
                              TextStyle(color: Colors.black)),
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                          controller: passwordController,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        FlatButton(
                          onPressed: () {},
                          child: Text(
                            'I forgot password ?',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: Colors.grey),
                          ),
                          color: Colors.transparent,
                        ),
                        Material(
                          elevation: 6,
                          color: Colors.transparent,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20),
                                  bottomLeft: Radius.circular(20),
                                  bottomRight: Radius.circular(20))),
                          child: FlatButton(
                            onPressed: () async {
                              if (emailController.text.isEmpty ||
                                  passwordController.text.isEmpty) {
                                setState(() {
                                  errorMessage =
                                  'Please enter email and password...';
                                  errorBox = UIHelper.errorMessageWidget(
                                      errorMessage, updateErrorMessage);
                                });
                              } else {
                                if (!AuthHelper.isEmail(emailController.text)) {
                                  setState(() {
                                    errorMessage =
                                    'Please enter valid email...';
                                    errorBox = UIHelper.errorMessageWidget(
                                        errorMessage, updateErrorMessage);
                                  });
                                }else{
                                  bool res = await _loginRequest(
                                      emailController.text,
                                      passwordController.text);
                                  if (res){
                                    print('valid credentials...');
                                    Navigator.pushReplacementNamed(
                                        context, HOME_ROUTE);
                                  }
                                  else {
                                    setState(() {
                                      errorMessage = 'Invalid email or password...';
                                      errorBox = UIHelper.errorMessageWidget(
                                          errorMessage, updateErrorMessage);
                                    });
                                  }
                                }
                              }

                            },
                            child: Container(
                              width: 200,
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    'login',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Icon(Icons.chevron_right)
                                ],
                              ),
                            ),
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.circular(30)),
                            color: green_custom_color,
                            textColor: Colors.white,
                          ),
                        ),
                        SizedBox(
                          height: 50,
                        ),
                        Container(
                          child: Row(
                            mainAxisAlignment:
                            MainAxisAlignment.center,
                            children: <Widget>[
                              Text('Don\'t have an account?'),
                              FlatButton(
                                  onPressed: () {
                                    Navigator.of(context)
                                        .pushNamed(SIGN_UP_ROUTE);
                                  },
                                  child: Text(
                                    'Signup',
                                    style: TextStyle(
                                        color: green_custom_color,
                                        fontWeight: FontWeight.bold),
                                  ))
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ))
          : ColorLoader(),
    );
  }

  _loginRequest(String email, String password) async {
    return await _userController.login(email, password);
  }
}
