import 'package:flutter/material.dart';
import 'package:iipe/login_screen.dart';
import 'registration_screen.dart';
import 'user_profile.dart';
import 'chat_screen.dart';

void main() {
  runApp(iipe());
}

class iipe extends StatefulWidget {
  @override
  _iipeState createState() => _iipeState();
}

class _iipeState extends State<iipe> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: 'login_screen',
      routes: {
        'login_screen': (context) => LoginScreen(),
        'registration_screen': (context) => RegistrationScreen(),
        'user_profile': (context) => UserProfile(),
        'chat_screen': (context) => ChatScreen(),
      },
    );
  }
}
