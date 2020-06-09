import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iipe/registration_screen.dart';
import 'package:iipe/user_profile.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'reset_password.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:easy_dialog/easy_dialog.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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

  bool showSpinner = false;
  String email;
  String password;
  var _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: MaterialApp(
          home: SafeArea(
            child: Scaffold(
              body: Builder(builder: (context) {
                return ModalProgressHUD(
                  inAsyncCall: showSpinner,
                  child: Center(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          TypewriterAnimatedTextKit(
                            text: ['INDIAN INSTITUTE OF PETROLEUM AND ENERGY'],
                            textStyle: TextStyle(
                              fontSize: 15.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Hero(
                            tag: 'logo',
                            child: Image(
                              image: AssetImage('images/iipe.png'),
                              width: 150.0,
                              height: 150.0,
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
                                if (value.isEmpty)
                                  return "Please enter your email";
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
                            height: 10.0,
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 20.0, right: 20.0),
                            child: TextFormField(
                              keyboardType: TextInputType.text,
                              validator: (String value) {
                                if (value.isEmpty)
                                  return "Please enter your password";
                              },
                              obscureText: true,
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
                            height: 12.0,
                          ),
                          Container(
                            alignment: Alignment(0.9, 0.0),
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    new MaterialPageRoute(
                                        builder: (context) => ResetPassword()));
                              },
                              child: Text(
                                'Forgot password?',
                                style: TextStyle(
                                  color: Colors.red,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: Padding(
                                  padding:
                                      EdgeInsets.only(left: 30.0, right: 30.0),
                                  child: RaisedButton(
                                    color: Colors.blue,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    onPressed: () async {
                                      if (_formKey.currentState.validate()) {
                                        setState(() {
                                          showSpinner = true;
                                        });
                                        try {
                                          final user = await _auth
                                              .signInWithEmailAndPassword(
                                                  email: email,
                                                  password: password);
                                          if (user != null) {
                                            Navigator.push(
                                                context,
                                                new MaterialPageRoute(
                                                    builder: (context) =>
                                                        UserProfile()));
                                          }
                                          setState(() {
                                            showSpinner = false;
                                          });
                                        } catch (e) {
                                          setState(() {
                                            showSpinner = false;
                                          });
                                          SnackBar mySnackbar = SnackBar(
                                            content: Text(
                                                'Incorrect email id or password.'),
                                          );
                                          Scaffold.of(context)
                                              .showSnackBar(mySnackbar);
                                        }
                                      }
                                    },
                                    child: Text(
                                      'Login',
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
                            height: 50.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                "Don't have an account?",
                              ),
                              SizedBox(
                                width: 5.0,
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      new MaterialPageRoute(
                                          builder: (context) =>
                                              new RegistrationScreen()));
                                },
                                child: Text(
                                  'Register',
                                  style: TextStyle(
                                    fontSize: 15.0,
                                    color: Colors.green,
                                  ),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ));
  }
}
