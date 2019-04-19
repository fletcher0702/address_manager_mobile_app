import 'package:address_manager/controller/team_controller.dart';
import 'package:address_manager/controller/user_controller.dart';
import 'package:address_manager/helpers/auth_helper.dart';
import 'package:address_manager/helpers/team_helper.dart';
import 'package:address_manager/models/dto/user/update_user_password_dto.dart';
import 'package:address_manager/screens/add_transition.dart';
import 'package:flutter/material.dart';
import 'package:address_manager/components/side_menu.dart';
import 'package:address_manager/tools/colors.dart';
import 'package:address_manager/helpers/ui_helper.dart';
import 'package:address_manager/tools/actions.dart';
import 'package:address_manager/tools/messages.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {

  final userController = UserController();
  final teamController = TeamController();
  final teamHelper = TeamHelper();
  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmNewPasswordController = TextEditingController();

  // Teams data
  List<dynamic> teams = [];
  String selectedTeam = '';
  String _selectedTeamUuid = '';
  int _selectedTeamIndex = -1;
  bool teamToggle = false;
  List<DropdownMenuItem<int>> teamsItems;

  // Error Message
  String errorMessage = '';
  Container errorBox = Container();


  @override
  void initState() {
    super.initState();
    loadTeams();
  }

  loadTeams(){
    teamController.findAll().then((res) {
      teams = res;
      teamsItems = teamHelper.buildDropDownSelection(teams);
      setState(() {
        teamToggle = true;
      });
    });
  }

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
        child: SingleChildScrollView(
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

                                Navigator.push(context, MaterialPageRoute(
                                    builder: (context) =>
                                        AddTransition(SUCCESS_UPDATE,ERROR_UPDATE,updatePasswordAction,UPDATE_ACTION,afterPasswordUpdateAction)));

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

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('Default Team', style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20
                  ),),
                  IconButton(icon: Icon(Icons.refresh,color: Colors.orangeAccent,), onPressed: loadTeams)
                ],
              ),
              Divider(color: Colors.black),

              Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(Icons.group, color: Colors.brown,size: 20,),
                      SizedBox(width: 10,),
                      DropdownButtonHideUnderline(
                        child: DropdownButton(
                          items: teamsItems,
                          hint: Text(selectedTeam,
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center),
                          onChanged: (value) {
                            setState(() {
                            selectedTeam = teams[value]['name'];
                            _selectedTeamUuid = teams[value]['uuid'];
                            _selectedTeamIndex= value;
                            });
                          },
                        ),
                      ),

                    ],
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
                        Navigator.push(context, MaterialPageRoute(
                            builder: (context) =>
                                AddTransition(SUCCESS_UPDATE,ERROR_UPDATE,setDefaultTeamAction,UPDATE_ACTION,loadTeams)));
                      },
                      child: Container(
                        width: 120,
                        child: Row(
                          mainAxisAlignment:
                          MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              'update team',
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
                  SizedBox(height: 20,),
                ],
              ),

            ],
          ),
        ),
      ),
    );
  }

  updateErrorMessage(){
    setState(() {
      errorBox = Container();
    });
  }

  updatePasswordAction() async {
    UpdateUserPasswordDto userPasswordDto = UpdateUserPasswordDto(oldPasswordController.text,newPasswordController.text);
    return userController.updatePassword(userPasswordDto);
  }

  afterPasswordUpdateAction(){
    oldPasswordController.text = '';
    newPasswordController.text = '';
    confirmNewPasswordController.text = '';
  }

  setDefaultTeamAction() async {
    return userController.setDefaultTeam(_selectedTeamUuid);
  }
}
