import 'package:address_manager/helpers/auth_helper.dart';
import 'package:flutter/material.dart';
import 'package:address_manager/components/side_menu.dart';
import 'package:address_manager/tools/colors.dart';
import 'package:address_manager/helpers/ui_helper.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {

  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmNewPasswordController = TextEditingController();

  // Error Message
  String errorMessage = '';
  Container errorBox = Container();


  @override
  void dispose() {
    super.dispose();
    oldPasswordController.dispose();
    newPasswordController.dispose();
    confirmNewPasswordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings', style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.black,
          fontSize: 25,
        ),),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: Colors.grey),
      ),
      drawer: SideMenu(),

      body: Padding(
        padding: EdgeInsets.all(MediaQuery.of(context).size.width*0.1),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Password', style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20
            ),),
            Divider(color: Colors.black),

            SizedBox(height: 30,),

            Padding(
              padding: EdgeInsets.only(left: 40,right: 40),
              child: Column(
                children: <Widget>[

                  errorBox,
                  SizedBox(height: 10,),
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
                        hintText: 'old password',
                        hintStyle:
                        TextStyle(color: Colors.black)),
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                    controller: oldPasswordController,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextField(
                    cursorColor: Colors.black,
                    obscureText: true,
                    decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.lock_open,
                          color: Colors.black,
                        ),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.black)),
                        alignLabelWithHint: true,
                        hintText: 'new password',
                        hintStyle:
                        TextStyle(color: Colors.black)),
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                    controller: newPasswordController,
                  ),
                  SizedBox(height: 20,),
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
                        hintText: 'confirm new password',
                        hintStyle:
                        TextStyle(color: Colors.black)),
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                    controller: confirmNewPasswordController,
                  ),
                  SizedBox(height: 20,),
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
                        if(oldPasswordController.text.isEmpty || newPasswordController.text.isEmpty || confirmNewPasswordController.text.isEmpty){
                          errorMessage = 'Please fill all fields...';
                          setState(() {
                            errorBox = UIHelper.errorMessageWidget(errorMessage, updateErrorMessage);
                          });
                        }else {
                          if(newPasswordController.text != confirmNewPasswordController.text){
                            errorMessage = 'New passwords are differents...';
                            setState(() {
                              errorBox = UIHelper.errorMessageWidget(errorMessage, updateErrorMessage);
                            });
                          }else{

                            if(AuthHelper.passwordRule(newPasswordController.text)){


                            }else{
                              errorMessage = 'Password length should be greater than 6...';
                              setState(() {
                                errorBox = UIHelper.errorMessageWidget(errorMessage, updateErrorMessage);
                              });
                            }

                          }
                        }
                      },
                      child: Container(
                        width: 120,
                        child: Row(
                          mainAxisAlignment:
                          MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              'update',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Icon(Icons.autorenew)
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
                ],
              ),
            ),

            SizedBox(height: 30,),

            Text('Default Team', style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20
            ),),
            Divider(color: Colors.black),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.group, color: Colors.brown,size: 20,),

              ],
            )

          ],
        ),
      ),
    );
  }

  updateErrorMessage(){
    setState(() {
      errorBox = Container();
    });
  }
}
