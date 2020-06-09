import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iipe/new_pending_book.dart';
import 'package:iipe/syllabus_screen.dart';
import 'myDrawer.dart';
import 'package:iipe/pending_books.dart';
import 'package:iipe/add_new_book.dart';
import 'package:iipe/login_screen.dart';
import 'cgpa_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:easy_dialog/easy_dialog.dart';

class UserProfile extends StatefulWidget {
  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  List<BookModel> list;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseUser loggedInUser;
  final FirebaseMessaging message = FirebaseMessaging();
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
    getCurrentUser();
    message.getToken().then((token) {
      print('token = $token done');
    });
  }

  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser();
      if (user != null) {
        loggedInUser = user;
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: SafeArea(
      child: Scaffold(
          appBar: AppBar(
            title: Text("Hello user"),
          ),
          drawer: MyDrawer(),
          body: ListView(
            scrollDirection: Axis.vertical,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(16.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => CGPA()));
                  },
                  child: Container(
                      width: 115.0,
                      height: 115.0,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blue,
                            blurRadius: 5.0, // soften the shadow
                            spreadRadius: 1.0, //extend the shadow
                            offset: Offset(
                              0.5, // Move to right 10  horizontally
                              0.5, // Move to bottom 10 Vertically
                            ),
                          )
                        ],
                        borderRadius: BorderRadius.circular(10.0),
                        color: Colors.white,
                      ),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Container(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    'CGPA CALCULATOR',
                                    style: TextStyle(
                                      fontSize: 15.0,
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10.0),
                                    child: Text(
                                      'Caluculate your cgpa with your course credits and grade points.',
                                      style: TextStyle(
                                        fontSize: 12.0,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              child: ClipRRect(
                                borderRadius: new BorderRadius.circular(10.0),
                                child: Image(
                                  height: 500,
                                  fit: BoxFit.contain,
                                  alignment: Alignment.topRight,
                                  image: AssetImage('images/cgpa.png'),
                                ),
                              ),
                            ),
                          )
                        ],
                      )),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(16.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PendingBooks(list)));
                  },
                  child: Container(
                      width: 115.0,
                      height: 115.0,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blue,
                            blurRadius: 5.0, // soften the shadow
                            spreadRadius: 1.0, //extend the shadow
                            offset: Offset(
                              0.5, // Move to right 10  horizontally
                              0.5, // Move to bottom 10 Vertically
                            ),
                          )
                        ],
                        borderRadius: BorderRadius.circular(10.0),
                        color: Colors.white,
                      ),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Container(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    'PENDING BOOKS',
                                    style: TextStyle(
                                      fontSize: 15.0,
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10.0),
                                    child: Text(
                                      'Add the book taken from library with last date of submission to avoid unnecessary fine.',
                                      style: TextStyle(
                                        fontSize: 12.0,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              child: ClipRRect(
                                borderRadius: new BorderRadius.circular(10.0),
                                child: Padding(
                                  padding: EdgeInsets.only(right: 30.0),
                                  child: Image(
                                    height: 100.0,
                                    fit: BoxFit.contain,
                                    alignment: Alignment.topRight,
                                    image: AssetImage('images/library.jpg'),
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      )),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(16.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Syllabus()));
                  },
                  child: Container(
                      width: 115.0,
                      height: 115.0,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blue,
                            blurRadius: 5.0, // soften the shadow
                            spreadRadius: 1.0, //extend the shadow
                            offset: Offset(
                              0.5, // Move to right 10  horizontally
                              0.5, // Move to bottom 10 Vertically
                            ),
                          )
                        ],
                        borderRadius: BorderRadius.circular(10.0),
                        color: Colors.white,
                      ),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Container(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    'SYLLABUS',
                                    style: TextStyle(
                                      fontSize: 15.0,
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10.0),
                                    child: Text(
                                      'Syllabus of both petroleum and chemical engineering is available.',
                                      style: TextStyle(
                                        fontSize: 12.0,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              child: ClipRRect(
                                borderRadius: new BorderRadius.circular(10.0),
                                child: Padding(
                                  padding: EdgeInsets.only(right: 30.0),
                                  child: Image(
                                    fit: BoxFit.contain,
                                    alignment: Alignment.topRight,
                                    image: AssetImage('images/syllabus.png'),
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      )),
                ),
              ),
            ],
          )),
    ));
  }
}
