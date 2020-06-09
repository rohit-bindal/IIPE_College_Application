import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:iipe/chat_screen.dart';
import 'package:iipe/login_screen.dart';
import 'chat_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'about_us.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:easy_dialog/easy_dialog.dart';

class MyDrawer extends StatefulWidget {
  @override
  _MyDrawerState createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
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

  final FirebaseAuth _auth = FirebaseAuth.instance;

  _launchURL() async {
    const url = 'http://www.iipe.ac.in/';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(20),
            color: Theme.of(context).primaryColor,
            child: Center(
              child: Column(
                children: <Widget>[
                  Container(
                    width: 150.0,
                    height: 150.0,
                    margin: EdgeInsets.only(top: 20, bottom: 20),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: AssetImage('images/iipe.png'),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  Text('Rohit Bindal',
                      style: TextStyle(fontSize: 22, color: Colors.white))
                ],
              ),
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (context) => new ChatScreen()));
            },
            leading: Icon(Icons.chat),
            title: Text(
              'Chat Boot',
              style: TextStyle(
                fontSize: 18.0,
              ),
            ),
          ),
          ListTile(
            onTap: () async {
              Navigator.pop(context);
              _launchURL();
            },
            leading: Icon(Icons.link),
            title: Text(
              'www.iipe.ac.in',
              style: TextStyle(
                fontSize: 18.0,
              ),
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => AboutUs()));
            },
            leading: Icon(Icons.info),
            title: Text(
              'About Us',
              style: TextStyle(
                fontSize: 18.0,
              ),
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.pop(context);
              _auth.signOut();
              Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (context) => new LoginScreen()));
            },
            leading: Icon(Icons.arrow_back),
            title: Text(
              'Logout',
              style: TextStyle(
                fontSize: 18.0,
              ),
            ),
          )
        ],
      ),
    );
  }
}
