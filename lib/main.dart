import 'package:flutter/material.dart';
import 'package:printed/pages/login.dart';
import 'package:printed/pages/register.dart';
import 'package:printed/pages/userInfo.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Printed Login',
      theme: ThemeData(
          primarySwatch: Colors.purple, accentColor: Colors.purple[900]),
      home: Login(),
      routes: <String, WidgetBuilder>{
        '/userinfo': (BuildContext context) => UserInfo(),
        '/register': (BuildContext context) => Register(),
      },
    );
  }
}
