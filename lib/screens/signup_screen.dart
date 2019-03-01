import 'package:flutter/material.dart';

import '../controller/user_controller.dart';
import '../routes/routes.dart';
import '../tools/colors.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  UserController _userController = UserController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(top: 30.0),
        child: Container(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: MediaQuery.of(context).size.height - 550,
                ),
                Center(
                    child: Text(
                  'Welcome,',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                )),
                Center(
                    child: Text(
                  'register to continue',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.grey),
                )),
                Padding(
                  padding: const EdgeInsets.all(40.0),
                  child: Container(
                    child: Column(
                      children: <Widget>[
                        TextField(
                          controller: emailController,
                          decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.person,
                                color: Colors.black,
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.black),
                              ),
                              alignLabelWithHint: true,
                              hintText: 'email',
                              hintStyle: TextStyle(color: Colors.black)),
                          cursorColor: Colors.black,
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                          keyboardType: TextInputType.emailAddress,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextField(
                          controller: passwordController,
                          cursorColor: Colors.black,
                          obscureText: true,
                          decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.lock_open,
                                color: Colors.black,
                              ),
                              alignLabelWithHint: true,
                              focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black)),
                              hintText: 'password',
                              hintStyle: TextStyle(color: Colors.black)),
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextField(
                          controller: confirmPasswordController,
                          cursorColor: Colors.black,
                          obscureText: true,
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.lock,
                              color: Colors.black,
                            ),
                            alignLabelWithHint: true,
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.black)),
                            hintText: 'confirm password',
                            hintStyle: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 20,
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
                            onPressed: () {
                              String email = emailController.text;
                              String password = passwordController.text;
                              String confirmedPassword = confirmPasswordController.text;


                              if(email.isEmpty || password.isEmpty || confirmedPassword.isEmpty) return false;
                              if(password!=confirmedPassword) return false;

                              print(email);
                              print(password);
                              print(confirmedPassword);
                              _registerRequest(email, password);
                              return true;
                            },
                            child: Container(
                              width: 200,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    'signup',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Icon(Icons.chevron_right)
                                ],
                              ),
                            ),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30)),
                            color: green_custom_color,
                            textColor: Colors.white,
                          ),
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text('Already have an account?'),
                              FlatButton(
                                  onPressed: () {
                                    Navigator.of(context)
                                        .pushNamed(LOGIN_ROUTE);
                                  },
                                  child: Text(
                                    'Signin',
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
      ),
    );
  }

  void _registerRequest(String s, String t) {
//    Navigator.of(context).pushNamed(HOME_ROUTE);
    _userController.register(s, t);
  }
}
