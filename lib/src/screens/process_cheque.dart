import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:login_app/src/screens/home.dart';
import 'package:login_app/src/screens/main_drawer.dart';
import 'home.dart';

class ProcessCheque extends StatefulWidget {
  ProcessCheque({Key key, this.title}) : super(key: key);

  List<String> data = new List<String>();
  final String title;
  Map<String, String> info = new Map<String, String>();

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<ProcessCheque> {
  File pickedImage;

  bool isImageLoaded = false;
  bool isDataProcessed = false;
  bool isCorrect = false;
  bool isPay = false;
  bool isAmount = false;
  bool isAC = false;
  bool isSign = false;
  bool isDate = false;
  bool isCheque = false;
  int count = 0;
  bool _hasBeenPressed1 = false;
  bool _hasBeenPressed2 = false;
  bool _hasBeenPressed3 = false;

  Future pickImage() async {
    var tempStore = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      pickedImage = tempStore;
      isImageLoaded = true;
    });
  }

  Future savetext() async {
    FirebaseVisionImage ourImage = FirebaseVisionImage.fromFile(pickedImage);
    TextRecognizer recognizeText = FirebaseVision.instance.textRecognizer();
    VisionText readText = await recognizeText.processImage(ourImage);
    widget.data.clear();

    for (TextBlock block in readText.blocks) {
      for (TextLine line in block.lines) {
        for (TextElement word in line.elements) {
          //print("first "+word.text );
          widget.data.add(word.text);
        }
      }
    }
    widget.info.clear();
    String firstval;
    isCorrect = false;
    widget.data.forEach((element) {
      if (isCorrect == true) {
        isCorrect = false;
        widget.info[firstval] = element;
      }
      if (element == "Pay" ||
          element == "AC" ||
          element == "Amount" ||
          element == "ChequeNumber" ||
          element == "Sign" ||
          element == "Date") {
        isCorrect = true;
        firstval = element;
      }
    });
    //widget.info.forEach((key, value) {print(key +"   "+ value);});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text("Process Cheque"),
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
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
              isImageLoaded
                  ? Center(
                      child: Container(
                          height: 200.0,
                          width: 200.0,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: FileImage(pickedImage),
                                  fit: BoxFit.cover))),
                    )
                  : Container(),
              SizedBox(height: 20),
              Text(
                "Please click the 'Pick Image' button to scan your cheque.",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 20),
              RaisedButton(
                child: Text('Pick Image'),
                color: _hasBeenPressed1 ? Colors.red : Colors.black54,
                textColor: Colors.white,
                onPressed: () => {
                  pickImage(),
                  setState(() {
                    _hasBeenPressed1 = true;
                  })
                },
              ),
              SizedBox(height: 20),
              Text(
                "Please click the 'Parse Data' button to parse the cheque data.",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 20),
              RaisedButton(
                child: Text('Parse Data'),
                color: _hasBeenPressed2 ? Colors.red : Colors.black54,
                textColor: Colors.white,
                onPressed: () => {
                  savetext(),
                  setState(() {
                    _hasBeenPressed2 = true;
                    Fluttertoast.showToast(
                      msg: 'Data Parsed Successfully',
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIos: 1,
                    );
                  })
                },
              ),
              SizedBox(height: 20),
              Text(
                "Please click the 'Get Data' button to see the digitised data.",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 10),
              RaisedButton(
                child: Text('Get Data'),
                color: _hasBeenPressed3 ? Colors.red : Colors.black54,
                textColor: Colors.white,
                onPressed: () {
                  setState(() {
                    _hasBeenPressed3 = true;
                    count = 0;
                    isDataProcessed = true;
                    if (widget.info['Date'] != null) {
                      isDate = true;
                      count++;
                    } else {
                      isDate = false;
                    }
                    if (widget.info['Pay'] != null) {
                      isPay = true;
                      count++;
                    } else {
                      isPay = false;
                    }
                    if (widget.info['Amount'] != null) {
                      isAmount = true;
                      count++;
                    } else {
                      isAmount = false;
                    }
                    if (widget.info['AC'] != null) {
                      isAC = true;
                      count++;
                    } else {
                      isAC = false;
                    }
                    if (widget.info['Sign'] != null) {
                      isSign = true;
                      count++;
                    } else {
                      isSign = false;
                    }
                    if (widget.info['ChequeNumber'] != null) {
                      isCheque = true;
                      count++;
                    } else {
                      isCheque = false;
                    }
                  });
                },
              ),
              SizedBox(height: 20),
              Column(
                children: [
                  isDataProcessed
                      ? Container(
                          height: 400,
                          padding: EdgeInsets.all(20),
                          child: Column(
                            children: [
                              isDate
                                  ? Text("Date: " + widget.info['Date'])
                                  : Text("Date: Not Mentioned on Cheque"),
                              isPay
                                  ? Text("To: " + widget.info['Pay'])
                                  : Text("To: Not Mentioned on Cheque"),
                              isSign
                                  ? Text("From: " + widget.info['Sign'])
                                  : Text("From: Not Mentioned on Cheque"),
                              isAmount
                                  ? Text("Amount: " + widget.info['Amount'])
                                  : Text("Amount: Not Mentioned on Cheque"),
                              isAC
                                  ? Text("Account Number: " + widget.info['AC'])
                                  : Text("AC: Not Mentioned on Cheque"),
                              isCheque
                                  ? Text("Cheque No: " +
                                      widget.info['ChequeNumber'])
                                  : Text("Cheque No: Not Mentioned on Cheque"),
                              (count == 6)
                                  ? RaisedButton(
                                      child: Text('Submit'),
                                      color: Colors.black54,
                                      textColor: Colors.white,
                                      onPressed: () {
                                        Navigator.of(context).pushReplacement(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ProcessCheque1()));
                                      },
                                    )
                                  : Text(count.toString() +
                                      " Fields are only present All 6 are required"),
                            ],
                          ))
                      : Container()
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ProcessCheque1 extends StatelessWidget {
  const ProcessCheque1({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: MainDrawer(),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Cheque will be processed in sometime.',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.black,
                ),
              ),
              Text(
                'Money will be transferred into your account after verification is successful. You will be informed via text and email once done.',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.redAccent,
                ),
              ),
              Container(
                margin: EdgeInsets.all(15),
                child: RaisedButton(
                  elevation: 0,
                  //height: 50,
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
