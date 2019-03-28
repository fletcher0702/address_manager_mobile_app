
import 'package:flutter/material.dart';
class UIHelper{

  static errorMessageWidget(errorMessage,action){

    Container c = Container(
      decoration: BoxDecoration(
        color: Colors.red,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(20),

      ),
      height: 30,
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[

            SizedBox(width: 10,),
            Row(
              children: <Widget>[
                Text(errorMessage,style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,

                ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                IconButton(icon: Icon(Icons.clear, color: Colors.white,size: 15,), onPressed: action),
              ],
            )
          ],
        ),
      ),
    );

    return c;
  }
}