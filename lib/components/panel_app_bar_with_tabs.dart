import 'package:flutter/material.dart';

class PanelAppBarWithTabs extends StatefulWidget {

  String _title;
  IconData _icon;
  Function _actionButton;
  Function _refreshAction;
  List<Widget> _tabs;

  PanelAppBarWithTabs(this._title, this._icon, this._actionButton,this._tabs,this._refreshAction);

  @override
  PanelAppBarWithTabsState createState() => PanelAppBarWithTabsState();

}

class PanelAppBarWithTabsState extends State<PanelAppBarWithTabs> {

  @override
  Widget build(BuildContext context) {

    return AppBar(
      bottom: TabBar(tabs: widget._tabs,
      indicatorColor: Colors.grey,
        indicatorPadding: EdgeInsets.only(left: 10,right: 10),
      ),
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
        IconButton(icon: Icon(Icons.refresh, color: Colors.orangeAccent,size: 30,), onPressed: widget._refreshAction),
        IconButton(icon: Icon(widget._icon, color: Color.fromRGBO(46, 204, 113, 1),size: 30,), onPressed: widget._actionButton),
      ],

    );
  }

}