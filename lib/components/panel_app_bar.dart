import 'package:flutter/material.dart';

class PanelAppBar extends StatefulWidget {

  String _title;
  IconData _icon;
  Function _actionButton;
  Function _reloadAction;

  PanelAppBar(this._title, this._icon, this._actionButton,this._reloadAction);

  @override
  PanelAppBarState createState() => PanelAppBarState();

}

class PanelAppBarState extends State<PanelAppBar> {

  @override
  Widget build(BuildContext context) {

    return AppBar(
      title: Text(
        widget._title,
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
        IconButton(icon: Icon(Icons.refresh, color: Colors.orangeAccent,size: 30,), onPressed: widget._reloadAction),
        IconButton(icon: Icon(widget._icon, color: Color.fromRGBO(46, 204, 113, 1),size: 30,), onPressed: widget._actionButton)
      ],

    );
  }

}