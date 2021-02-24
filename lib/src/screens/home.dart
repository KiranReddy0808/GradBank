import 'package:alan_voice/alan_voice.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:login_app/src/screens/classes.dart';
import 'package:login_app/src/screens/feedback.dart';
import 'package:login_app/src/screens/login.dart';
import 'package:login_app/src/screens/main_drawer.dart';
import 'package:login_app/src/screens/open_new_account_1.dart';
import 'package:login_app/src/screens/process_cheque.dart';
import 'package:login_app/src/screens/spend_analyser.dart';
import 'package:login_app/src/screens/split_bill.dart';
import 'package:login_app/src/screens/transfer_money.dart';
import 'globals.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeScreen extends StatefulWidget {

  _HomeScreen createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> {

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;

  Future<void> getData() async{
    String user = auth.currentUser.uid;
    await firestore.collection('Users').doc(user).get().then((value) {
      balance = value.data()['Balance'];});
  }

  Future<void> getMonthData() async{
    String user = auth.currentUser.uid;
    await firestore.collection('Users').doc(user).get().then((value) {
      mlimit = value.data()['Monthly Limit'];});
  }

  Future<void> getYearData() async{
    String user = auth.currentUser.uid;
    await firestore.collection('Users').doc(user).get().then((value) {
      ylimit = value.data()['Yearly Limit'];});
  }


  @override
  Widget build(BuildContext context) {
    getData();
    getMonthData();
    getYearData();
    return Scaffold(
        //backgroundColor: Color(0xfff9e0ae),
        appBar: AppBar(
          title: Text('              GRAD BANK'),
          backgroundColor: Colors.redAccent,
          elevation: 0.0,
          actions: <Widget>[
            FlatButton(
              textColor: Colors.white,
              onPressed: () {
                setState(() {
                  istransfer = true;
                  ischequeprocess = true;
                  isnewacc = true;
                  isspendanalyzer = true;
                  isfeedback = true;
                  issplitbill = true;
                  isbalance = false;
                });
              },
              child: Text("Reset Homepage"),
              shape: CircleBorder(side: BorderSide(color: Colors.transparent)),
            ),
          ],
        ),
        drawer: MainDrawer(),
        body: Column(
          children: <Widget>[
            Row(
              children: [
                SizedBox(width: 80),
                RaisedButton(
                  child: Text('Show Balance'),
                  onPressed: () {
                    setState(() {
                      isbalance = true;
                    });
                  } ,
                ),
                SizedBox(width: 30),
                isbalance ? Text(balance.toString(),style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: Colors.black,
                )):Container(),
              ],
            ),
            Center(
              child: Text(
                "Long press on features to remove",
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: GridView.count(crossAxisCount: 2, children: <Widget>[
                ischequeprocess
                    ? InkWell(
                        onTap: () {
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) => ProcessCheque()));
                          setVisuals("Process Cheque");
                        },
                        onLongPress: () {
                          setState(() {
                            ischequeprocess = false;
                          });
                        },
                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          color: Colors.white,
                          child: Stack(
                            children: <Widget>[
                              Center(
                                child: Image.asset(
                                  'assets/app1.jpg',
                                  height: 100,
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 160, left: 20),
                                child: Text('Process Cheque',
                                    style: TextStyle(
                                        color: Colors.red,
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.bold)),
                              )
                            ],
                          ),
                        ),
                      )
                    : Container(),
                issplitbill
                    ? InkWell(
                        onTap: () {
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) => SplitBill()));
                          setVisuals("Split Bill");
                        },
                        onLongPress: () {
                          setState(() {
                            issplitbill = false;
                          });
                        },
                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          color: Colors.white,
                          child: Stack(
                            children: <Widget>[
                              Center(
                                child: Image.asset(
                                  'assets/app2.png',
                                  height: 50,
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 160, left: 53),
                                child: Text('Split Bill',
                                    style: TextStyle(
                                        color: Colors.red,
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.bold)),
                              )
                            ],
                          ),
                        ),
                      )
                    : InkWell(),
                isspendanalyzer
                    ? InkWell(
                        onTap: () {
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) => SpendAnalyser()));
                          setVisuals("Spend Analyser");
                        },
                        onLongPress: () {
                          setState(() {
                            isspendanalyzer = false;
                          });
                        },
                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          color: Colors.white,
                          child: Stack(
                            children: <Widget>[
                              Center(
                                child: Image.asset(
                                  'assets/app3.png',
                                  height: 50,
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 160, left: 22),
                                child: Text('Spend Analyser',
                                    style: TextStyle(
                                        color: Colors.red,
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.bold)),
                              )
                            ],
                          ),
                        ),
                      )
                    : Container(),
                istransfer
                    ? InkWell(
                        onTap: () {
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) => TransferMoney()));
                          setVisuals("Transfer Money");
                        },
                        onLongPress: () {
                          setState(() {
                            istransfer = false;
                          });
                        },
                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          color: Colors.white,
                          child: Stack(
                            children: <Widget>[
                              Center(
                                child: Image.asset(
                                  'assets/app4.png',
                                  height: 65,
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 160, left: 20),
                                child: Text('Transfer Money',
                                    style: TextStyle(
                                        color: Colors.red,
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.bold)),
                              )
                            ],
                          ),
                        ),
                      )
                    : Container(),
                isnewacc
                    ? InkWell(
                        onTap: () {
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) => OpenNewAccount()));
                          setVisuals("Open New Account");
                        },
                        onLongPress: () {
                          setState(() {
                            isnewacc = false;
                          });
                        },
                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          color: Colors.white,
                          child: Stack(
                            children: <Widget>[
                              Center(
                                child: Image.asset(
                                  'assets/app5.png',
                                  height: 70,
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 160, left: 5),
                                child: Text('Open New Account',
                                    style: TextStyle(
                                        color: Colors.red,
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.bold)),
                              )
                            ],
                          ),
                        ),
                      )
                    : Container(),
                isfeedback
                    ? InkWell(
                        onTap: () {
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) => CustFeedback()));
                          setVisuals("Feedback");
                        },
                        onLongPress: () {
                          setState(() {
                            isfeedback = false;
                          });
                        },
                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          color: Colors.white,
                          child: Stack(
                            children: <Widget>[
                              Center(
                                child: Image.asset(
                                  'assets/app6.png',
                                  height: 70,
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 160, left: 50),
                                child: Text('Feedback',
                                    style: TextStyle(
                                        color: Colors.red,
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.bold)),
                              )
                            ],
                          ),
                        ),
                      ) : Container(),
              ]),
            ),
          ],
        ));
  }

  void setVisuals(String screen) {
    var visual = "{\"screen\":\"$screen\"}";
    AlanVoice.setVisualState(visual);
  }
}
