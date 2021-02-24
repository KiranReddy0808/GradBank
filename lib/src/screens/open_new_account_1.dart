import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:login_app/src/screens/main_drawer.dart';
import 'package:login_app/src/screens/open_new_account_2.dart';
import 'home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:login_app/main.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'globals.dart';

class OpenNewAccount extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _OpenNewAccountState();
  }
}

class _OpenNewAccountState extends State<OpenNewAccount> {

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;

  final name_controller = TextEditingController();
  final id_controller = TextEditingController();
  final dob_controller = TextEditingController();
  final address_controller = TextEditingController();
  final email_controller = TextEditingController();
  final zip_controller = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    name_controller.dispose();
    id_controller.dispose();
    dob_controller.dispose();
    address_controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    firestore.collection('New Customer').get().then((value) => total_created = value.size);
    return Scaffold(
      appBar: AppBar(
          title: Text('Account Opening',
              style: TextStyle(fontWeight: FontWeight.bold)
          ),
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
      drawer: MainDrawer(),
      body: ListView(
        children: <Widget>[
          Container(
            margin: EdgeInsets.all(15),
            child: Text(
              'Step 1: Personal Information',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                // color: Colors.red,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.all(15),
            child: TextField(
              decoration: InputDecoration(
                  border: new OutlineInputBorder(borderSide: new BorderSide()),
                  labelText: 'Full Name',
                  hintText: 'Enter your Full Name: FirstName LastName'),
              controller: name_controller,
            ),
          ),
          Container(
            margin: EdgeInsets.all(15),
            child: TextField(
              decoration: InputDecoration(
                  border: new OutlineInputBorder(borderSide: new BorderSide()),
                  labelText: 'ID number',
                  hintText: 'Enter your ID number'),
              controller: id_controller,
            ),
          ),
          Container(
            margin: EdgeInsets.all(15),
            child: TextField(
              keyboardType: TextInputType.datetime,
              decoration: InputDecoration(
                  border: new OutlineInputBorder(borderSide: new BorderSide()),
                  labelText: 'Date of Birth',
                  hintText: 'Enter your Date of Birth: MM-DD-YYYY'),
              controller: dob_controller,
            ),
          ),
          Container(
            margin: EdgeInsets.all(15),
            child: TextField(
              decoration: InputDecoration(
                  border: new OutlineInputBorder(borderSide: new BorderSide()),
                  labelText: 'Email ID',
                  hintText: 'Enter your Email address'),
              controller: email_controller,
            ),
          ),
          Container(
            margin: EdgeInsets.all(15),
            child: TextField(
              minLines: 3,
              maxLines: 5,
              decoration: InputDecoration(
                  border: new OutlineInputBorder(borderSide: new BorderSide()),
                  labelText: 'Permanent Address',
                  hintText: 'Enter your Permanent Address'),
              controller: address_controller,
            ),
          ),
          Container(
            margin: EdgeInsets.all(15),
            child: TextField(
              decoration: InputDecoration(
                  border: new OutlineInputBorder(borderSide: new BorderSide()),
                  labelText: 'Zip code',
                  hintText: 'Enter your zip code'),
              controller: zip_controller,
            ),
          ),
          Container(
            margin: EdgeInsets.all(15),
            child: MaterialButton(
              elevation: 0,
              height: 50,
              onPressed: () {
                if(name_controller.text.toString().isEmpty || id_controller.text.toString().isEmpty || address_controller.text.toString().isEmpty || zip_controller.text.toString().isEmpty || email_controller.text.toString().isEmpty){
                  _scaffoldKey.currentState.showSnackBar(
                    SnackBar(
                      content: Text("Please fill all the fields to proceed",
                      style: TextStyle(fontSize: 18),),
                      duration: Duration(seconds: 10),));
                }
                else{
                  total_created = total_created + 1;
                  firestore.collection('New Customer').doc('Total').update({'created':total_created-1});
                  firestore.collection('New Customer').doc("Customer"+(total_created-1).toString()).set({'Full Name': name_controller.text,'ID': id_controller.text,'Address': address_controller.text,'PinCode':zip_controller.text,'Email Id':email_controller.text,'User ID':auth.currentUser.uid});
                  Navigator.push(context,
                    MaterialPageRoute(builder: (_) => OpenNewAccount2()));}
                
              },
              color: Colors.black54,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('Next Step ',
                      style: TextStyle(color: Colors.white, fontSize: 20)),
                  Icon(Icons.arrow_forward_ios)
                ],
              ),
              textColor: Colors.white,
            ),
          )
        ],
      ),
    );
  }
}
