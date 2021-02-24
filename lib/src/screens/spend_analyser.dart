import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:login_app/src/screens/main_drawer.dart';
import 'classes.dart';
import 'globals.dart' as globals;
import 'package:charts_flutter/flutter.dart' as charts;
import 'globals.dart';
import 'home.dart';

class SpendAnalyser extends StatelessWidget {

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    String user = auth.currentUser.uid;

    List<Payments> data = new List<Payments>();
    firestore.collection(user).get().then((value)  {
      value.docs.forEach((element) {
        data.add(new Payments(amount_: element.data()['Amount'], category_: element.data()['Category'], date_: element.data()['Day'], month_: element.data()['Month'], year_: element.data()['Year']));
      });

    });


    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text("SpendAnalyser"),
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
      body: SingleChildScrollView(
        child: Column(children: [
          PaymentsChart(data: data),
        ]),
      ),
    );
  }
}

class PaymentsChart extends StatefulWidget {
  final List<Payments> data;
  PaymentsChart({@required this.data});



  _PaymentsChart createState() => _PaymentsChart();
}

class DrawLine extends CustomPainter {
  final Color color;
  final Offset from;
  final Offset to;
  DrawLine(this.color, this.from, this.to);

  @override
  void paint(Canvas canvas, Size size) {
    final _paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(from, to, _paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class Label extends StatelessWidget {
  final String _label;
  final Color _color;
  Label(this._label, this._color);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        SizedBox(width: 10),
        Text(_label, style: TextStyle(fontSize: 13)),
        Container(
          width: 50,
          height: 10,
          child: CustomPaint(
            size: Size(50, 50),
            painter: DrawLine(
              _color,
              Offset(10, 0),
              Offset(50, 0),
            ),
          ),
          padding: EdgeInsets.all(0),
        ),
      ],
    );
  }
}



class _PaymentsChart extends State<PaymentsChart> {
  List<int> months = [0, 31, 59, 90, 120, 151, 181, 211, 241, 272, 302, 323];


  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;

  Future<void> setMonthData(Data) async{
    String user = auth.currentUser.uid;
    await firestore.collection('Users').doc(user).update({'Monthly Limit': Data});
  }
  Future<void> setYearData(Data) async{
    String user = auth.currentUser.uid;
    await firestore.collection('Users').doc(user).update({'Yearly Limit': Data});
  }
  limits l = new limits(m_limit: mlimit, y_limit: ylimit);
  int payed = 0;
  int limit_rem = 0;
  int limit_rem_month = 0;

  var curr = DateTime.now();

  @override
  Widget build(BuildContext context) {
    payed = 0;
    List<recentPayments> yearly = new List<recentPayments>();
    List<recentPayments> monthly = new List<recentPayments>();
    List<catPayments> catmonth = new List<catPayments>();
    List<catPayments> catyear = new List<catPayments>();
    List<recentPayments> prevmonth = new List<recentPayments>();

    widget.data.forEach((element) {
      if (element.year_ == curr.year) {
        payed = payed + element.amount_;
        yearly.add(new recentPayments(
            amount_: payed, day_: element.date_ + months[element.month_ - 1]));
      }
    });
    limit_rem = l.y_limit - payed;
    payed = 0;

    widget.data.forEach((element) {
      if ((element.year_ == curr.year) && (element.month_ == curr.month)) {
        payed = payed + element.amount_;
        monthly.add(new recentPayments(amount_: payed, day_: element.date_));
      }
    });
    limit_rem_month = l.m_limit - payed;
    payed = 0;

    widget.data.forEach((element) {
      if ((((element.year_ == curr.year) &&
              (element.month_ == curr.month - 1) &&
              curr.month != 1) ||
          (curr.month == 1 &&
              element.month_ == 12 &&
              element.year_ == curr.year - 1))) {
        payed = payed + element.amount_;
        prevmonth.add(new recentPayments(amount_: payed, day_: element.date_));
      }
    });
    payed = 0;

    widget.data.forEach((element) {
      if (element.year_ == curr.year && element.category_ == "Food") {
        payed = payed + element.amount_;
      }
    });
    if (payed != 0) {
      catyear.add(new catPayments(amount_: payed, category_: "Food"));
    }
    payed = 0;

    widget.data.forEach((element) {
      if (element.year_ == curr.year && element.category_ == "Others") {
        payed = payed + element.amount_;
      }
    });
    if (payed != 0) {
      catyear.add(new catPayments(amount_: payed, category_: "Others"));
    }
    payed = 0;

    widget.data.forEach((element) {
      if (element.year_ == curr.year && element.category_ == "Bills") {
        payed = payed + element.amount_;
      }
    });
    if (payed != 0) {
      catyear.add(new catPayments(amount_: payed, category_: "Bills"));
    }
    payed = 0;

    widget.data.forEach((element) {
      if (element.year_ == curr.year && element.category_ == "Online") {
        payed = payed + element.amount_;
      }
    });
    if (payed != 0) {
      catyear.add(new catPayments(amount_: payed, category_: "Online"));
    }
    payed = 0;

    widget.data.forEach((element) {
      if (element.year_ == curr.year &&
          element.category_ == "Food" &&
          (element.month_ == curr.month)) {
        payed = payed + element.amount_;
      }
    });
    if (payed != 0) {
      catmonth.add(new catPayments(amount_: payed, category_: "Food"));
    }
    payed = 0;

    widget.data.forEach((element) {
      if (element.year_ == curr.year &&
          element.category_ == "Others" &&
          (element.month_ == curr.month)) {
        payed = payed + element.amount_;
      }
    });
    if (payed != 0) {
      catmonth.add(new catPayments(amount_: payed, category_: "Others"));
    }
    payed = 0;

    widget.data.forEach((element) {
      if (element.year_ == curr.year &&
          element.category_ == "Bills" &&
          (element.month_ == curr.month)) {
        payed = payed + element.amount_;
      }
    });
    if (payed != 0) {
      catmonth.add(new catPayments(amount_: payed, category_: "Bills"));
    }
    payed = 0;

    widget.data.forEach((element) {
      if (element.year_ == curr.year &&
          element.category_ == "Online" &&
          (element.month_ == curr.month)) {
        payed = payed + element.amount_;
      }
    });
    if (payed != 0) {
      catmonth.add(new catPayments(amount_: payed, category_: "Online"));
    }
    payed = 0;

    List<charts.Series<recentPayments, int>> series = [
      charts.Series(
          id: "Yearly Bill",
          data: yearly,
          domainFn: (recentPayments series, _) => series.day_,
          measureFn: (recentPayments series, _) => series.amount_,
          labelAccessorFn: (recentPayments series, _) => "Current Month"),
      charts.Series(
          id: "Yearly Bill",
          data: [
            new recentPayments(amount_: l.y_limit, day_: 0),
            new recentPayments(amount_: l.y_limit, day_: 365)
          ],
          domainFn: (recentPayments series, _) => series.day_,
          measureFn: (recentPayments series, _) => series.amount_),
    ];
    List<charts.Series<recentPayments, int>> series1 = [
      charts.Series(
          id: "Monthly Bill",
          data: monthly,
          domainFn: (recentPayments series, _) => series.day_,
          measureFn: (recentPayments series, _) => series.amount_),
      charts.Series(
          id: "Monthly Bill",
          data: [
            new recentPayments(amount_: l.m_limit, day_: 0),
            new recentPayments(amount_: l.m_limit, day_: 31)
          ],
          domainFn: (recentPayments series, _) => series.day_,
          measureFn: (recentPayments series, _) => series.amount_),
      charts.Series(
          id: "Monthly Bill",
          data: prevmonth,
          domainFn: (recentPayments series, _) => series.day_,
          measureFn: (recentPayments series, _) => series.amount_)
    ];
    List<charts.Series<catPayments, String>> serieslist = [
      charts.Series(
          id: "Yearly Bill",
          data: catyear,
          domainFn: (catPayments series, _) => series.category_,
          measureFn: (catPayments series, _) => series.amount_),
    ];
    List<charts.Series<catPayments, String>> serieslist1 = [
      charts.Series(
          id: "Monthly Bill",
          data: catmonth,
          domainFn: (catPayments series, _) => series.category_,
          measureFn: (catPayments series, _) => series.amount_),
    ];

    final myController = TextEditingController();

    @override
    void dispose() {
      // Clean up the controller when the widget is removed from the
      // widget tree.
      myController.dispose();
      super.dispose();
    }

    return Container(
      height: 715,
      padding: EdgeInsets.all(0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              Text(
                globals.choice ? "Yearly View" : "Monthly View",
                style: Theme.of(context).textTheme.body2,
              ),
              TextField(
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Enter the Limit you want to set here'),
                controller: myController,
              ),
              Row(children: [
                SizedBox(width: 4),
                RaisedButton(
                  child: Text("Set Limit"),
                  onPressed: () {
                      if (globals.choice == false) {
                        l.m_limit = int.parse(myController.text);
                        setMonthData(l.m_limit);

                      }

                      if (globals.choice == true) {
                        l.y_limit = int.parse(myController.text);
                        setYearData(l.y_limit);
                      }
                  },
                ),
                SizedBox(width: 8),
                RaisedButton(
                  child: Text("Generate"),
                  onPressed: () {
                    setState(() => globals.isgenerate = true);
                  },
                ),
                SizedBox(width: 8),
                RaisedButton(
                  child: Text("Month"),
                  onPressed: () {
                    setState(() {
                      globals.choice = false;
                    });
                  },
                ),
                SizedBox(width: 8),
                RaisedButton(
                  child: Text("Year"),
                  onPressed: () {
                    setState(() => globals.choice = true);
                  },
                ),
              ]),
              Row(children: [
                globals.choice
                    ? Label("Current Year", Colors.blue)
                    : Label("Current Month", Colors.blue),
                globals.choice
                    ? Container(
                        width: 0,
                        height: 0,
                      )
                    : Label("Previous Month", Colors.yellow)
              ]),
              Expanded(
                child: globals.isgenerate ? charts.LineChart(globals.choice ? series : series1,
                    animate: true):Container(),
              ),
              //  Expanded(
              //    child: ,
              //  ),
              Expanded(
                child: globals.isgenerate ? charts.PieChart(
                    globals.choice ? serieslist : serieslist1,
                    animate: true,
                    defaultRenderer: new charts.ArcRendererConfig(
                        arcWidth: 60,
                        arcRendererDecorators: [
                          new charts.ArcLabelDecorator(
                              labelPosition: charts.ArcLabelPosition.inside,
                              insideLabelStyleSpec: new charts.TextStyleSpec(
                                  fontSize: 16,
                                  color: charts.Color.fromHex(code: "#FFFFFF")))
                        ])):Container(),
              ),
              Row(children: [
                globals.choice
                    ? Text("                   Limit Remaining: " +
                        (limit_rem > 0
                            ? limit_rem.toString()
                            : "Limit Crossed       "))
                    : Text("                   Limit Remaining: " +
                        (limit_rem_month > 0
                            ? limit_rem_month.toString()
                            : "Limit Crossed      ")),
                globals.choice
                    ? Text("   Limit set: " + l.y_limit.toString())
                    : Text("   Limit Set: " + l.m_limit.toString())
              ]),
            ],
          ),
        ),
      ),
    );
  }
}
