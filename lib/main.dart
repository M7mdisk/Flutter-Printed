import 'package:flutter/material.dart';
import 'package:printed/pages/login.dart';
import 'package:printed/pages/register.dart';

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
    );
  }
}

// class MyHomePage extends StatefulWidget {
//   MyHomePage({Key key}) : super(key: key);

//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   @override
//   Widget build(BuildContext context) {
//     return Login();
//   }
// }
