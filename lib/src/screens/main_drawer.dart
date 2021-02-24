import 'package:alan_voice/alan_voice.dart';
import 'package:flutter/material.dart';
import 'package:login_app/src/screens/feedback.dart';
import 'package:login_app/src/screens/home.dart';
import 'package:login_app/src/screens/open_new_account_1.dart';
import 'package:login_app/src/screens/process_cheque.dart';
import 'package:login_app/src/screens/spend_analyser.dart';
import 'package:login_app/src/screens/split_bill.dart';
import 'package:login_app/src/screens/transfer_money.dart';

import 'home.dart';

class MainDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          UserAccountsDrawerHeader(
              accountEmail: Text('user@123.com'),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Text("U"),
              ),
              accountName: Text("User")),
          ListTile(
            title: Text('Home'),
            trailing: Icon(Icons.home_outlined),
            onTap: () {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => HomeScreen()));
              setVisuals("Home");
            },
          ),
          ListTile(
            title: Text('Process Cheque'),
            trailing: Icon(Icons.account_balance_wallet_outlined),
            onTap: () {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => ProcessCheque()));
              setVisuals("Process Cheque");
            },
          ),
          ListTile(
            title: Text('Split Bill'),
            trailing: Icon(Icons.vertical_split_outlined),
            onTap: () {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => SplitBill()));
              setVisuals("Split Bill");
            },
          ),
          ListTile(
            title: Text('Spend Analyser'),
            trailing: Icon(Icons.analytics_outlined),
            onTap: () {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => SpendAnalyser()));
              setVisuals("Spend Analyser");
            },
          ),
          ListTile(
            title: Text('Transfer Money'),
            trailing: Icon(Icons.attach_money),
            onTap: () {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => TransferMoney()));
              setVisuals("Transfer Money");
            },
          ),
          ListTile(
            title: Text('Open New Account'),
            trailing: Icon(Icons.account_balance),
            onTap: () {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => OpenNewAccount()));
              setVisuals("Open New Account");
            },
          ),
          ListTile(
            title: Text('Feedback'),
            trailing: Icon(Icons.feedback_outlined),
            onTap: () {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => CustFeedback()));
              setVisuals("Feedback");
            },
          ),
        ],
      ),
    );
  }

  void setVisuals(String screen) {
    var visual = "{\"screen\":\"$screen\"}";
    AlanVoice.setVisualState(visual);
  }
}
