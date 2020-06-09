import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:easy_dialog/easy_dialog.dart';

class AboutUs extends StatefulWidget {
  @override
  _AboutUs createState() => _AboutUs();
}

class _AboutUs extends State<AboutUs> {
  @override
  void initState() {
    // TODO: implement initState
    final fbm = FirebaseMessaging();
    fbm.requestNotificationPermissions();
    fbm.configure(onMessage: (msg) {
      EasyDialog(
              title: Text(
                msg['notification']['title'],
              ),
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

  _launchURL() async {
    const url =
        'mailto:rohitkumarbindal@iipe.ac.in?subject=News&body=New%20plugin';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back,
          ),
        ),
        backgroundColor: Colors.blueAccent,
        title: Text('About Us'),
      ),
      backgroundColor: Colors.blueAccent,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Image(
            width: 150.0,
            height: 150.0,
            image: AssetImage('images/iipe.png'),
          ),
          SizedBox(
            height: 10.0,
          ),
          Text(
            'iipe App',
            style: TextStyle(
              fontSize: 25.0,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 5.0, left: 36.0, right: 36.0),
            child: Text(
              'This app is developed by Rohit Bindal (Student of IIPE from 2018-2022) in 2020.',
              style: TextStyle(
                color: Colors.white,
                fontSize: 15.0,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 5.0, left: 25.0, right: 25.0),
            child: Text(
              'All rights are reserved.',
              style: TextStyle(
                color: Colors.white,
                fontSize: 15.0,
              ),
            ),
          ),
          SizedBox(
            height: 45.0,
          ),
          Text(
            'In case you find any bug, contact Rohit',
            style: TextStyle(
              color: Colors.white,
              fontSize: 13.0,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 3.0),
            child: GestureDetector(
              onTap: () {
                _launchURL();
              },
              child: Text(
                'rohitkumarbindal@iipe.ac.in',
                style: TextStyle(
                  decoration: TextDecoration.underline,
                  color: Colors.white,
                  fontSize: 13.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
