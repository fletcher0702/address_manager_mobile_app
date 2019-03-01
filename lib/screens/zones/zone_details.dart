import 'package:flutter/material.dart';

class ZoneDetailScreen extends StatelessWidget {
  final dynamic zone;

  ZoneDetailScreen(this.zone);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 30),
        child: Column(
          children: <Widget>[
            Text('${zone['name']}'),
          ],
        ),
      ),
    );
  }
}
