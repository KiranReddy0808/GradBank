import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'globals.dart';
import 'main_drawer.dart';
import 'home.dart';


class TransferMoney extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _TransferMoney();
  }
}
class _TransferMoney extends State<TransferMoney> {

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;

  final amountcont = TextEditingController();
  final catcont = TextEditingController();
  final daycont = TextEditingController();
  final monthcont = TextEditingController();
  final yearcont = TextEditingController();
  final idcont = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    amountcont.dispose();
    catcont.dispose();
    daycont.dispose();
    monthcont.dispose();
    yearcont.dispose();
    idcont.dispose();
    super.dispose();
  }
  var curr = DateTime.now();
  @override
  Widget build(BuildContext context) {
    String user = auth.currentUser.uid;

    firestore.collection(user).get().then((value) => created = value.size+10);


    return Scaffold(
      backgroundColor: Color(0xfff9e0ae),
      drawer: MainDrawer(),
      appBar: AppBar(
        title: Text('Transfer Money'),
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
       body: Container(
          height: 715,
          padding: EdgeInsets.all(0),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[
                  Row(
                    children: [
                      Center(
                        child: RaisedButton(
                          child: Text("New Payment"),
                          onPressed: () {
                            setState(() {
                              ispayment = false;
                            });
                          },
                        ),
                      ),
                      SizedBox(width: 80),
                      Center(
                        child: RaisedButton(
                          child: Text("Add Old Payment"),
                          onPressed: () {
                            setState(() {
                              ispayment = true;
                            });
                          },
                        ),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Text("Amount"),
                      ),
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Amount'),
                          controller: amountcont,
                        ),
                      )
                    ],
                  ),
                  !ispayment ? Row(
                    children: [
                      Expanded(
                        child: Text("To"),
                      ),
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Enter the ID of Payee'),
                          controller: idcont,
                        ),
                      )
                    ],
                  ):Container(),
                  Row(
                    children: [
                      Expanded(
                        child: Text("Category"),
                      ),
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Enter the Category of Payment'),
                          controller: catcont,
                        ),
                      )
                    ],
                  ),
                  ispayment ? Row(

                    children: [
                      Expanded(
                        child: Text("Date"),
                      ),
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Day'),
                          controller: daycont,
                        ),

                      ),
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Month'),
                          controller: monthcont,
                        ),
                      ),
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Year'),
                          controller: yearcont,
                        ),
                      )
                    ],
                  ):Container(),
                  RaisedButton(
                    child: Text("Submit"),
                    onPressed: (){
                      created = created +1;
                      !ispayment ? firestore.collection(user).doc(created.toString()).set({'Amount':int.parse(amountcont.text),'Category':catcont.text,'Day':curr.day,'Month':curr.month,'Year':curr.year}):firestore.collection(user).doc(created.toString()).set({'Amount':int.parse(amountcont.text),'Category':catcont.text,'Day':int.parse(daycont.text),'Month':int.parse(monthcont.text),'Year':int.parse(yearcont.text),});
                      !ispayment ? firestore.collection('Users').doc(user).update({'Balance':balance - int.parse(amountcont.text)}):(6-4);
                      balance = balance - int.parse(amountcont.text);
                      Navigator.push(context,
                          MaterialPageRoute(builder: (_) => HomeScreen()));
                    },
                  )
                ],
              ),
            ),
          ),
        )
    );
  }
}
