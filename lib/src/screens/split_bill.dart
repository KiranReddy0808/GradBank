import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:login_app/src/screens/home.dart';
import 'package:login_app/src/screens/main_drawer.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:pin_entry_text_field/pin_entry_text_field.dart';
import 'package:local_auth/local_auth.dart';
import 'home.dart';

import 'split_bill_user.dart';

class SplitBill extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SplitBillState();
  }
}

class _SplitBillState extends State<SplitBill> {
  double totalBill = 0;
  int n = 1; //No. of contributor
  List<String> contributors = [];
  // String barcode = '';
  List<User> users = User.getDummyUsers();
  User currentUser = User('User1', '0000000000', '123456');

  TextEditingController totalBillController = TextEditingController();
  TextEditingController contributorController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    print("Bill Is: " + totalBillController.text);
    return Scaffold(
      appBar: AppBar(
        title: Text("Bill Splitter"),
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
          TextField(
            decoration:
                InputDecoration(labelText: "Enter Total Bill Amount (in Rs)"),
            keyboardType: TextInputType.number,
            controller: totalBillController,
          ),
          RaisedButton(
            color: Colors.black54,
            onPressed: () {
              // print("Changed Bill is: " + totalBillController.text);

              setState(() {
                totalBill = double.parse(totalBillController.text);
                // totalBillController.text = "";
              });
            },
            child: Text(
              "Enter",
              style: TextStyle(color: Colors.white),
            ),
          ),
          Text("Your Contribution: Rs." + (totalBill / n).toString()),
          Column(
            children: contributors
                .map(
                  (element) => Card(
                    child: Text(
                      element + ": Rs." + (totalBill / n).toString(),
                    ),
                  ),
                )
                .toList(),
          ),
          TextField(
            decoration: InputDecoration(
                labelText: "Enter the Phone Number of the contributor"),
            controller: contributorController,
          ),
          Row(
            children: [
              RaisedButton(
                color: Colors.black54,
                onPressed: () {
                  print("Pressed");
                  setState(() {
                    bool ref = false;
                    for (User user in users) {
                      if (user.phoneNum == contributorController.text) {
                        contributors.add(user.name);
                        n = contributors.length + 1;
                        contributorController.text = '';
                        ref = true;
                        Fluttertoast.showToast(
                          msg: 'User found',
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIos: 1,
                        );
                      }
                    }
                    if (ref == false) {
                      Fluttertoast.showToast(
                        msg: 'User not found',
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIos: 1,
                      );
                    }

                    contributorController.text = '';
                  });
                },
                child: Text(
                  "Add",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              RaisedButton(
                color: Colors.black54,
                onPressed: () {
                  print("Pressed");
                  setState(() {
                    contributors = [];
                    n = 1;
                  });
                },
                child: Text(
                  "Reset",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
            mainAxisAlignment: MainAxisAlignment.center,
          ),
          scanResult == '' || scanResult == null
              ? Text('Result will be displayed here')
              : Text(scanResult),
          SizedBox(height: 20),
          RaisedButton(
            color: Colors.black54,
            child: Text(
              'Click To Scan QR Code of Payee',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: scanQRCode,
          ),
          Expanded(
            child: Align(
              child: RaisedButton(
                color: Colors.black54,
                child: Text(
                  'Proceed',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  if (scanResult == '' || scanResult == null) {
                    print("Please scan qr");
                    Fluttertoast.showToast(
                      msg: 'Please Scan QR Code First',
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIos: 1,
                      // backgroundColor: Colors.red,
                      // textColor: Colors.yellow,
                    );
                  } else {
                    print("Success");
                    // Fluttertoast.showToast(
                    //   msg: 'Success',
                    //   toastLength: Toast.LENGTH_SHORT,
                    //   gravity: ToastGravity.BOTTOM,
                    //   timeInSecForIos: 1,
                    // );
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SplitBillAuth(
                            totalBill.toString(),
                            scanResult,
                            currentUser.upiPin),
                      ),
                    );
                  }
                },
              ),
              alignment: FractionalOffset.bottomCenter,
            ),
          )
        ],
      ),
    );
  }

  String scanResult = '';
//function that launches the scanner
  Future scanQRCode() async {
    String cameraScanResult = await scanner.scan();
    setState(() {
      scanResult = cameraScanResult;
    });
  }
}

class SplitBillAuth extends StatefulWidget {
  String totalBill;
  String benificiary;
  String upiPin;

  SplitBillAuth(this.totalBill, this.benificiary, this.upiPin);
  @override
  State<StatefulWidget> createState() =>
      _SplitBillAuthState(totalBill, benificiary, upiPin);
}

class _SplitBillAuthState extends State<SplitBillAuth> {
  String userPin;
  String totalBill;
  String benificiary;

  _SplitBillAuthState(this.totalBill, this.benificiary, this.userPin);

  LocalAuthentication _localAuthentication = LocalAuthentication();

  Future<bool> _isBiometricAvailable() async {
    bool isAvailable = false;
    try {
      isAvailable = await _localAuthentication.canCheckBiometrics;
    } on PlatformException catch (e) {
      print(e);
    }

    if (!mounted) return isAvailable;

    isAvailable
        ? print('Biometric is available!')
        : print('Biometric is unavailable.');

    return isAvailable;
  }

  Future<void> _getListOfBiometricTypes() async {
    List<BiometricType> listOfBiometrics;
    try {
      listOfBiometrics = await _localAuthentication.getAvailableBiometrics();
    } on PlatformException catch (e) {
      print(e);
    }

    if (!mounted) return;

    print(listOfBiometrics);
  }

  Future<void> _authenticateUser() async {
    bool isAuthenticated = false;
    try {
      isAuthenticated = await _localAuthentication.authenticateWithBiometrics(
        localizedReason: "Please authenticate to complete your transaction",
        useErrorDialogs: true,
        stickyAuth: true,
      );
    } on PlatformException catch (e) {
      print(e);
    }
    if (!mounted) return;

    isAuthenticated
        ? print('User is authenticated!')
        : print('User is not authenticated.');

    if (isAuthenticated) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => PaymentSuccess(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Autherize Payment"),
        ),
        body: Container(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Pay Rs $totalBill to $benificiary',
                    style: TextStyle(fontSize: 25), //(color: Colors.black),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Please Enter Your 6 digitUPI Pin',
                    // style: TextStyle(color: Colors.black),
                  ),
                ),
                Container(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: PinEntryTextField(
                      showFieldAsBox: true,
                      fields: 6,
                      onSubmit: (String enteredPin) {
                        if (enteredPin != userPin) {
                          showDialog(
                            context: context,
                            builder: (context) {
                              print("object");
                              return AlertDialog(
                                title: Text("Wrong Pin"),
                                content: Text('Please enter correct pin'),
                              );
                            },
                          );
                        } else {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PaymentSuccess()));
                        } //end showDialog()
                      }, // end onSubmit
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RaisedButton(
                    color: Colors.black54,
                    onPressed: () async {
                      if (await _isBiometricAvailable()) {
                        await _getListOfBiometricTypes();
                        await _authenticateUser();
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Click for Biometric Auth',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    // elevation: 5,
                    // shape: RoundedRectangleBorder(
                    //     borderRadius: BorderRadius.circular(40)),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}

class PaymentSuccess extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Expanded(
              //   child:
              // Align(
              //   child:
              SizedBox(height: 100),
              Padding(
                padding: const EdgeInsets.only(top: 100),
                child: Column(
                  children: [
                    Image.asset(
                      'assets/ok.png',
                      height: 200,
                    ),
                    SizedBox(height: 15),
                    Text(
                      'Your Contribution Paid Successfuly',
                      style: TextStyle(fontSize: 18, color: Colors.black),
                    ),
                    SizedBox(height: 15),
                    Text(
                      'Other contributors will be notified on their apps.',
                      style: TextStyle(fontSize: 18, color: Colors.red),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),
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
              // alignment: FractionalOffset.center,
              // ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
