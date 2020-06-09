import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iipe/login_screen.dart';
import 'package:iipe/user_profile.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:easy_dialog/easy_dialog.dart';

class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
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

  String email;
  String password;
  String fullname;
  String mobileNumber;
  String rollNumber;
  bool show = false;
  var _formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  final _firestore = Firestore.instance;
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: MaterialApp(home: SafeArea(
        child: Scaffold(body: Builder(builder: (context) {
          return ModalProgressHUD(
            inAsyncCall: show,
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    TypewriterAnimatedTextKit(
                      text: ['REGISTRATION'],
                      textStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                      ),
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    Hero(
                      tag: 'logo',
                      child: Image(
                        image: AssetImage('images/iipe.png'),
                        height: 150.0,
                        width: 150.0,
                      ),
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 20.0, right: 20.0),
                      child: TextFormField(
                        keyboardType: TextInputType.text,
                        validator: (String value) {
                          if (value.isEmpty) {
                            String msg = "Please enter your full name";
                            return msg;
                          }
                        },
                        obscureText: false,
                        decoration: InputDecoration(
                          hintText: 'Full Name',
                          hintStyle: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                        style: TextStyle(
                          color: Colors.black,
                        ),
                        onChanged: (value) {
                          fullname = value;
                        },
                      ),
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 20.0, right: 20.0),
                      child: TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        obscureText: false,
                        validator: (String value) {
                          if (value.isEmpty) return "Please enter your email";
                        },
                        decoration: InputDecoration(
                          hintText: 'IIPE Email',
                          hintStyle: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                        style: TextStyle(
                          color: Colors.black,
                        ),
                        onChanged: (value) {
                          email = value;
                        },
                      ),
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 20.0, right: 20.0),
                      child: TextFormField(
                        keyboardType: TextInputType.text,
                        obscureText: false,
                        validator: (String value) {
                          if (value.isEmpty)
                            return "Please enter your roll number";
                        },
                        decoration: InputDecoration(
                          hintText: 'Roll Number',
                          hintStyle: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                        style: TextStyle(
                          color: Colors.black,
                        ),
                        onChanged: (value) {
                          rollNumber = value;
                        },
                      ),
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 20.0, right: 20.0),
                      child: TextFormField(
                        keyboardType: TextInputType.text,
                        obscureText: true,
                        validator: (String value) {
                          if (value.isEmpty)
                            return "please enter your password";
                        },
                        decoration: InputDecoration(
                          hintText: 'Password',
                          hintStyle: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                        style: TextStyle(
                          color: Colors.black,
                        ),
                        onChanged: (value) {
                          password = value;
                        },
                      ),
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 20.0, right: 20.0),
                      child: TextFormField(
                        keyboardType: TextInputType.phone,
                        obscureText: false,
                        validator: (String value) {
                          if (value.isEmpty)
                            return "Please enter your mobile number";
                        },
                        decoration: InputDecoration(
                          hintText: 'Mobile Number',
                          hintStyle: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                        style: TextStyle(
                          color: Colors.black,
                        ),
                        onChanged: (value) {
                          mobileNumber = value;
                        },
                      ),
                    ),
                    SizedBox(
                      height: 25.0,
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(left: 30.0, right: 30.0),
                            child: RaisedButton(
                              color: Colors.blue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              onPressed: () async {
                                if (_formKey.currentState.validate()) {
                                  setState(() {
                                    show = true;
                                  });
                                  try {
                                    final newUser = await _auth
                                        .createUserWithEmailAndPassword(
                                            email: email, password: password);
                                    _firestore.collection('users').add({
                                      'Full Name': fullname,
                                      'IIPE Email': email,
                                      'Mobile Number': mobileNumber,
                                      'Password': password,
                                      'Roll Number': rollNumber,
                                    });
                                    if (newUser != null) {
                                      Navigator.push(
                                          context,
                                          new MaterialPageRoute(
                                              builder: (context) =>
                                                  UserProfile()));
                                    }
                                    setState(() {
                                      show = false;
                                    });
                                  } catch (e) {
                                    setState(() {
                                      show = false;
                                    });
                                    SnackBar mySnackbar = SnackBar(
                                      content: Text(
                                          'Inavlid Email or Password is too short.'),
                                    );
                                    Scaffold.of(context)
                                        .showSnackBar((mySnackbar));
                                  }
                                }
                              },
                              child: Text(
                                'Register',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 40.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "Already Registered?",
                        ),
                        SizedBox(
                          width: 5.0,
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                new MaterialPageRoute(
                                    builder: (context) => new LoginScreen()));
                          },
                          child: Text(
                            'Login Here',
                            style: TextStyle(
                              fontSize: 15.0,
                              color: Colors.green,
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        })),
      )),
    );
  }
}
