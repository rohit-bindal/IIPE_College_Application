import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easy_dialog/easy_dialog.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class WithSemester extends StatefulWidget {
  @override
  _WithSemesterState createState() => _WithSemesterState();
}

int itemCount = 1;
List<double> grades = [
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0
];
List<double> credits = [
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0
];
String credit;

class _WithSemesterState extends State<WithSemester> {
  @override
  void initState() {
    // TODO: implement initState
    final fbm = FirebaseMessaging();
    fbm.requestNotificationPermissions();
    fbm.configure(onMessage: (msg) {
      EasyDialog(
              title: Text(msg['notification']['title']),
              description: Text(msg['notification']['body']))
          .show(context);
      return;
    }, onLaunch: (msg) {
      return;
    }, onResume: (msg) {
      return;
    });
    fbm.subscribeToTopic('messages');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            resizeToAvoidBottomPadding: false,
            body: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                          child: Container(
                        padding: EdgeInsets.all(5.0),
                        child: Text(
                          'Semester',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        decoration: BoxDecoration(
                            border: Border(
                                top: BorderSide(
                                    color: Colors.blueAccent, width: 1),
                                bottom: BorderSide(
                                    color: Colors.blueAccent, width: 1))),
                      )),
                      Expanded(
                          child: Container(
                        padding: EdgeInsets.all(5.0),
                        child: Text(
                          'Credit',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        decoration: BoxDecoration(
                            border: Border(
                                top: BorderSide(
                                    color: Colors.blueAccent, width: 1),
                                bottom: BorderSide(
                                    color: Colors.blueAccent, width: 1))),
                      )),
                      Expanded(
                          child: Container(
                        padding: EdgeInsets.all(5.0),
                        child: Text(
                          'SGPA',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        decoration: BoxDecoration(
                            border: Border(
                                top: BorderSide(
                                    color: Colors.blueAccent, width: 1),
                                bottom: BorderSide(
                                    color: Colors.blueAccent, width: 1))),
                      ))
                    ],
                  ),
                ),
                Expanded(
                    child: ListView.builder(
                  itemBuilder: (context, index) {
                    return myList(index);
                  },
                  itemCount: itemCount,
                )),
                Padding(
                  padding: EdgeInsets.only(right: 8.0, left: 8.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: RaisedButton(
                          onPressed: () {
                            setState(() {
                              itemCount = 1;
                              for (var i = 0; i < credits.length; i++) {
                                credits[i] = 0;
                                grades[i] = 0;
                              }
                            });
                          },
                          child: Text(
                            'Reset',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          color: Colors.blueAccent,
                        ),
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      Expanded(
                        child: RaisedButton(
                          onPressed: () {
                            setState(() {
                              itemCount++;
                            });
                          },
                          child: Text(
                            'Add Semester',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          color: Colors.blueAccent,
                        ),
                      )
                    ],
                  ),
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                        child: RaisedButton(
                      padding: EdgeInsets.all(10.0),
                      color: Colors.blueAccent,
                      onPressed: () {
                        double sum = 0.0;
                        double creditSum = 0.0;
                        double SGPA = 0.0;
                        for (var i = 0; i < itemCount; i++) {
                          if (credits[i] != 0 && grades[i] != 0)
                            sum += credits[i] * grades[i];
                        }
                        for (var i = 0; i < itemCount; i++) {
                          if (credits[i] != 0) creditSum += credits[i];
                        }
                        SGPA =
                            double.parse((sum / creditSum).toStringAsFixed(2));
                        EasyDialog(
                            cornerRadius: 15.0,
                            title: Text(
                              '$SGPA',
                              style: TextStyle(
                                fontSize: 50.0,
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            height: 350.0,
                            fogOpacity: 0.5,
                            contentPadding: EdgeInsets.all(10.0),
                            contentList: [
                              SizedBox(
                                height: 30.0,
                              ),
                              Text(
                                "Calculation Details:",
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(
                                height: 5.0,
                              ),
                              Padding(
                                padding: EdgeInsets.all(5.0),
                                child: Text(
                                  'Total Course: $itemCount',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(5.0),
                                child: Text(
                                  'Total Credit: $creditSum',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(5.0),
                                child: Text(
                                  'Total Point: $sum',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            ]).show(context);
                      },
                      child: Text(
                        'Caluclate',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 25.0,
                        ),
                      ),
                    ))
                  ],
                ),
              ],
            )));
  }
}

class myList extends StatefulWidget {
  myList(this.index);
  int index;

  @override
  _myListState createState() => _myListState();
}

class _myListState extends State<myList> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: <Widget>[
          Expanded(
              child: Container(
            padding: EdgeInsets.all(5.0),
            child: Text(
              'Semester ${widget.index + 1}',
              style: TextStyle(
                color: Colors.black54,
              ),
            ),
            decoration: BoxDecoration(
                border: Border(
                    top: BorderSide(color: Colors.blueAccent, width: 0.5),
                    bottom: BorderSide(color: Colors.blueAccent, width: 0.5))),
          )),
          Expanded(
              child: Container(
            padding: EdgeInsets.all(5.0),
            child: Container(
              height: 18.0,
              child: TextFormField(
                  onChanged: (value) {
                    credits[widget.index] = double.parse(value);
                  },
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(bottom: 11.0),
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      counterText: "",
                      hintText: 'Credit',
                      hintStyle: TextStyle(
                        color: Colors.black87,
                      ))),
            ),
            decoration: BoxDecoration(
                border: Border(
                    top: BorderSide(color: Colors.blueAccent, width: 0.5),
                    bottom: BorderSide(color: Colors.blueAccent, width: 0.5))),
          )),
          Expanded(
              child: Container(
            padding: EdgeInsets.all(5.0),
            child: Container(
              height: 18.0,
              child: TextFormField(
                  onChanged: (value) {
                    grades[widget.index] = double.parse(value);
                  },
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(bottom: 11.0),
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      counterText: "",
                      hintText: 'SGPA',
                      hintStyle: TextStyle(
                        color: Colors.black87,
                      ))),
            ),
            decoration: BoxDecoration(
                border: Border(
                    top: BorderSide(color: Colors.blueAccent, width: 0.5),
                    bottom: BorderSide(color: Colors.blueAccent, width: 0.5))),
          )),
        ],
      ),
    );
  }
}
