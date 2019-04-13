import 'package:flutter/material.dart';

class Tag extends StatefulWidget {
  final Color _color;
  var content;
  Function _closeAction;


  Tag(this._color, this.content,this._closeAction);

  @override
  _TagState createState() => _TagState();
}

class _TagState extends State<Tag> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 35,
      decoration: BoxDecoration(
        color: widget._color,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(20)
      ),
      child:Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(width: 10,),
          Text(widget.content['name'], style: TextStyle(
              color: Colors.white
          ),),
          IconButton(icon: Icon(Icons.close, color: Colors.white,size: 18,
          ), onPressed: (){
            widget._closeAction(widget);
          }),
        ],
      )
    );
  }
}
