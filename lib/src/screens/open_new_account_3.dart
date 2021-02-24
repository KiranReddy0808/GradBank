import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:login_app/src/app.dart';
import 'package:login_app/src/screens/home.dart';
import 'package:login_app/src/screens/main_drawer.dart';
// import 'login.dart';
import 'home.dart';

class OpenNewAccount3 extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _OpenNewAccountState3();
  }
}

class _OpenNewAccountState3 extends State<OpenNewAccount3> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: MainDrawer(),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Application Submitted Successfully',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.black,
                ),
              ),
              Text(
                'Further verification details will be mailed',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.redAccent,
                ),
              ),
              Container(
                margin: EdgeInsets.all(15),
                child: MaterialButton(
                  elevation: 0,
                  height: 50,
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => HomeScreen()));
                  },
                  color: Colors.black54,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text('Go Home',
                          style: TextStyle(color: Colors.white, fontSize: 20)),
                    ],
                  ),
                  textColor: Colors.white,
                ),
              )
            ],
          ),
        ));
  }
}
