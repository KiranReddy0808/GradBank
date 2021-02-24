import 'package:flutter/material.dart';

import 'main_drawer.dart';
import 'home.dart';

class CustFeedback extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MainDrawer(),
      backgroundColor: Color(0xfff9e0ae),
      appBar: AppBar(
        title: Text('Feedback'),
        backgroundColor: Colors.redAccent,
        elevation: 0.0,
        actions: <Widget>[
          FlatButton(
            textColor: Colors.white,
            onPressed: () {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                      builder: (context) => HomeScreen()));
            },
            child: Text("Home"),
            shape: CircleBorder(side: BorderSide(color: Colors.transparent)),
          ),
        ],
      ),
    );
  }
}
