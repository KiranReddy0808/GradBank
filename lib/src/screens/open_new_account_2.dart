import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:login_app/src/screens/globals.dart';
import 'package:login_app/src/screens/main_drawer.dart';
import 'package:login_app/src/screens/open_new_account_3.dart';
import 'dart:io';
import 'home.dart';
import 'open_new_account_1.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path_provider/path_provider.dart';

class OpenNewAccount2 extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _OpenNewAccountState2();
  }
}

class _OpenNewAccountState2 extends State<OpenNewAccount2> {

  firebase_storage.FirebaseStorage storageplace = firebase_storage.FirebaseStorage.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth fireauth = FirebaseAuth.instance;

  String _POIfilePath = null;
  String _POAfilePath = null;
  String _PhotofilePath = null;
  String _POIabsfilePath = null;
  String _POAabsfilePath = null;
  String _PhotoabsfilePath = null;


  pickPOIFile() async {
    try {
      String filePath = await FilePicker.getFilePath(type: FileType.any);
      if (filePath == '') {
        return;
      }
      print("File path: " + filePath);
      var pos = filePath.lastIndexOf('/');
      String fileName = (pos != -1) ? filePath.substring(pos + 1) : filePath;
      setState(() {
        this._POIfilePath = fileName;
        this._POIabsfilePath = filePath;
      });
    } catch (e) {
      print("Error while picking the file: " + e.toString());
    }
  }

  pickPOAFile() async {
    try {
      String filePath = await FilePicker.getFilePath(type: FileType.any);
      if (filePath == '') {
        return;
      }
      print("File path: " + filePath);
      var pos = filePath.lastIndexOf('/');
      String fileName = (pos != -1) ? filePath.substring(pos + 1) : filePath;
      setState(() {
        this._POAfilePath = fileName;
        this._POAabsfilePath = filePath;
      });
    } catch (e) {
      print("Error while picking the file: " + e.toString());
    }
  }

  pickPhotoFile() async {
    try {
      String filePath = await FilePicker.getFilePath(type: FileType.any);
      if (filePath == '') {
        return;
      }
      print("File path: " + filePath);
      var pos = filePath.lastIndexOf('/');
      String fileName = (pos != -1) ? filePath.substring(pos + 1) : filePath;
      setState(() {
        this._PhotofilePath = fileName;
        this._PhotoabsfilePath = filePath;
      });
    } catch (e) {
      print("Error while picking the file: " + e.toString());
    }
  }

  Future<void> uploadFile(String filePath) async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    File file = File(_POAabsfilePath);
    await firebase_storage.FirebaseStorage.instance
          .ref('Upload/'+(total_created-1).toString()+'POA'+'.jpg')
          .putFile(file);
    File file1 = File(_POIabsfilePath);
    await firebase_storage.FirebaseStorage.instance
        .ref('Upload/'+(total_created-1).toString()+'POI'+'.jpg')
        .putFile(file1);
    File file2 = File(_PhotoabsfilePath);
    await firebase_storage.FirebaseStorage.instance
        .ref('Upload/'+(total_created-1).toString()+'Photo'+'.jpg')
        .putFile(file2);

    await firestore.collection('New Customer').doc('Customer'+(total_created-1).toString()).update({'POI Image': 'gs://secondapp-16bd2.appspot.com/Upload/'+(total_created-1).toString()+'POI.jpg'});
    await firestore.collection('New Customer').doc('Customer'+(total_created-1).toString()).update({'POA Image': 'gs://secondapp-16bd2.appspot.com/Upload/'+(total_created-1).toString()+'POA.jpg'});
    await firestore.collection('New Customer').doc('Customer'+(total_created-1).toString()).update({'Photo': 'gs://secondapp-16bd2.appspot.com/Upload/'+(total_created-1).toString()+'Photo.jpg'});
  }

  @override
  Widget build(BuildContext context) {
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
              'Step 2: Upload Documents',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                // color: Colors.red,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.all(15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Proof of Identity :',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    // color: Colors.red,
                  ),
                ),
                MaterialButton(
                  onPressed: pickPOIFile,
                  color: Colors.black54,
                  child: Text('Select ', style: TextStyle(fontSize: 15)),
                  textColor: Colors.white,
                ),
              ],
            ),
          ),
          _POIfilePath != null
              ? Container(
                  margin: EdgeInsets.all(15),
                  padding: EdgeInsets.symmetric(),
                  child: Text(
                    "POI File :  " + _POIfilePath,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                )
              : Container(),
          Container(
            margin: EdgeInsets.all(15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Proof of Address :',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    // color: Colors.red,
                  ),
                ),
                MaterialButton(
                  onPressed: pickPOAFile,
                  color: Colors.black54,
                  child: Text('Select ', style: TextStyle(fontSize: 15)),
                  textColor: Colors.white,
                ),
              ],
            ),
          ),
          _POAfilePath != null
              ? Container(
                  margin: EdgeInsets.all(15),
                  padding: EdgeInsets.symmetric(),
                  child: Text(
                    "POA File :  " + _POAfilePath,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                )
              : Container(),
          Container(
            margin: EdgeInsets.all(15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Passport size photo :',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    // color: Colors.red,
                  ),
                ),
                MaterialButton(
                  onPressed: pickPhotoFile,
                  color: Colors.black54,
                  child: Text('Select ', style: TextStyle(fontSize: 15)),
                  textColor: Colors.white,
                ),
              ],
            ),
          ),
          _PhotofilePath != null
              ? Container(
                  margin: EdgeInsets.all(15),
                  padding: EdgeInsets.symmetric(),
                  child: Text(
                    "Photo File :  " + _PhotofilePath,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                )
              : Container(),
          Container(
            margin: EdgeInsets.all(15),
            child: MaterialButton(
              elevation: 0,
              height: 50,
              onPressed: () {
                uploadFile(_POAfilePath);
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => OpenNewAccount3()));
              },
              color: Colors.black54,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('Submit ',
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
