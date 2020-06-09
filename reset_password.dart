import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iipe/change_password.dart';
import 'change_password.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:easy_dialog/easy_dialog.dart';

class ResetPassword extends StatefulWidget {
  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  bool show = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  var _formKey = GlobalKey<FormState>();
  bool showSpinner = false;
  String email;
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
    return Form(
      key: _formKey,
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.blueAccent,
            leading: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(
                Icons.arrow_back,
              ),
            ),
          ),
          body: Builder(builder: (context) {
            return ModalProgressHUD(
              inAsyncCall: show,
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Image(
                        image: AssetImage('images/forgot-password.png'),
                      ),
                      SizedBox(
                        height: 30.0,
                      ),
                      Text(
                        'Forgot Your Password?',
                        style: TextStyle(
                            fontSize: 25.0, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 45.0, right: 25.0),
                        child: Text(
                          'Enter your email address and we will send you instructions to reset your password.',
                          style: TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 40.0,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 25.0, right: 25.0),
                        child: TextFormField(
                          validator: (String value) {
                            if (value.isEmpty) return 'Please enter your email';
                          },
                          keyboardType: TextInputType.emailAddress,
                          obscureText: false,
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.email,
                              color: Colors.black,
                            ),
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
                        height: 30.0,
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
                                      await _auth.sendPasswordResetEmail(
                                          email: email);

                                      Navigator.push(
                                          context,
                                          new MaterialPageRoute(
                                              builder: (context) =>
                                                  ChangePassword()));

                                      setState(() {
                                        show = false;
                                      });
                                    } catch (e) {
                                      setState(() {
                                        show = false;
                                      });
                                      SnackBar mySnackbar = SnackBar(
                                        content: Text('Invalid Email Id.'),
                                      );
                                      Scaffold.of(context)
                                          .showSnackBar(mySnackbar);
                                    }
                                  }
                                },
                                child: Text(
                                  'Continue',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          })),
    );
  }
}
