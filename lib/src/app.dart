import 'package:alan_voice/alan_voice.dart';
import 'package:flutter/material.dart';
import 'package:login_app/src/screens/feedback.dart';
import 'package:login_app/src/screens/login.dart';
import 'package:login_app/src/screens/main_drawer.dart';
import 'package:login_app/src/screens/open_new_account_1.dart';
import 'package:login_app/src/screens/process_cheque.dart';
import 'package:login_app/src/screens/spend_analyser.dart';
import 'package:login_app/src/screens/split_bill.dart';
import 'package:login_app/src/screens/transfer_money.dart';

import 'screens/home.dart';
import 'screens/login.dart';

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.red,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  _MyHomePageState() {
    //Init Alan with sample project id
    AlanVoice.addButton(
        "b6807676f83c982c2524bbf49086a8312e956eca572e1d8b807a3e2338fdd0dc/stage",
        buttonAlign: AlanVoice.BUTTON_ALIGN_LEFT);

    //Add listener for command event
    AlanVoice.callbacks.add((command) => _handleCommand(command.data));
  }
  Color primaryColor = Color(0xff18203d);
  Color secondaryColor = Color(0xff232c51);
  Color logoGreen = Color(0xff25bcbb);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            //We take the image from the assets
            Image.asset(
              'assets/IMG.png',
              height: 250,
            ),
            SizedBox(
              height: 20,
            ),
            //Texts and Styling of them
            Text(
              'Welcome to GRAD BANK !',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 28),
            ),
            SizedBox(height: 20),
            Text(
              'Bank of the Future',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            SizedBox(
              height: 30,
            ),
            //Our MaterialButton which when pressed will take us to a new screen named as
            //LoginScreen
            MaterialButton(
              elevation: 0,
              height: 50,
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (_) => LoginScreen()));
                setVisuals("Login Screen");
              },
              color: logoGreen,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('Get Started',
                      style: TextStyle(color: Colors.white, fontSize: 20)),
                  Icon(Icons.arrow_forward_ios)
                ],
              ),
              textColor: Colors.white,
            )
          ],
        ),
      ),
    );
  }

  void _navigateTo(String screen) {
    switch (screen) {
      case "Login Screen":
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
        setVisuals("Login Screen");
        break;
      case "Process Cheque":
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ProcessCheque()),
        );
        setVisuals("Process Cheque");
        break;
      case "Spend Analyser":
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SpendAnalyser()),
        );
        setVisuals("Spend Analyser");
        break;
      case "Open New Account":
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => OpenNewAccount()),
        );
        setVisuals("Open New Account");
        break;
      case "Split Bill":
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SplitBill()),
        );
        setVisuals("Split Bill");
        break;
      case "Transfer Money":
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => TransferMoney()),
        );
        setVisuals("Transfer Money");
        break;
      case "Feedback":
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CustFeedback()),
        );
        setVisuals("Feedback");
        break;
      case "Home":
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
        setVisuals("Home");
        break;
      case "Login Screen":
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
        setVisuals("Login Screen");
        break;
      case "App Drawer":
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MainDrawer()),
        );
        setVisuals("Main Drawer");
        break;
      case "back":
        Navigator.pop(context);
        break;
      default:
        print("Unknown screen: $screen");
    }
  }

  void _handleCommand(Map<String, dynamic> command) {
    switch (command["command"]) {
      case "navigation":
        _navigateTo(command["route"]);
        break;
      default:
        debugPrint("Unknown command: ${command}");
    }
  }

  void setVisuals(String screen) {
    var visual = "{\"screen\":\"$screen\"}";
    AlanVoice.setVisualState(visual);
  }
}
