import 'package:flutter/material.dart';
import 'package:iipe/with_course.dart';
import 'package:iipe/with_semester.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:easy_dialog/easy_dialog.dart';

class CGPA extends StatefulWidget {
  @override
  _CGPAState createState() => _CGPAState();
}

class _CGPAState extends State<CGPA> {
  String value;

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
        home: SafeArea(
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(
              tabs: <Widget>[
                Tab(
                  text: 'WITH COURSE',
                ),
                Tab(
                  text: 'WITH SEMESTER',
                )
              ],
            ),
            backgroundColor: Colors.blueAccent,
            title: Text(
              'CGPA Calculator',
            ),
            leading: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(
                Icons.arrow_back,
              ),
            ),
          ),
          body: TabBarView(
            children: <Widget>[
              new WithCourse(),
              new WithSemester(),
            ],
          ),
        ),
      ),
    ));
  }
}
