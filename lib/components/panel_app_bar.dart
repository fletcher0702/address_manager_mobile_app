import 'package:flutter/material.dart';

class PanelAppBar extends StatefulWidget {

  String _title;
  IconData _icon;
  Function _actionButton;

  PanelAppBar(this._title, this._icon, this._actionButton);

  @override
  PanelAppBarState createState() => PanelAppBarState(_title,_icon,_actionButton);

}

class PanelAppBarState extends State<PanelAppBar> {

  String _title;
  IconData _icon;
  Function _actionButton;


  PanelAppBarState(this._title, this._icon, this._actionButton);

  @override
  Widget build(BuildContext context) {

    return AppBar(
      title: Text(
        _title,
        style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25,
            color: Colors.black
        ),
      ),
      centerTitle: true,
      elevation: 0,
      backgroundColor: Colors.transparent,
      iconTheme: IconThemeData(color: Colors.grey),
      actions: <Widget>[
        IconButton(icon: Icon(_icon, color: Color.fromRGBO(46, 204, 113, 1),size: 30,), onPressed: _actionButton)
      ],

    );
  }

}