import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

import 'package:printed/auth/auth.dart';
import 'package:printed/models/snackMessage.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

final _scaffoldKey = GlobalKey<ScaffoldState>();

class _LoginState extends State<Login> {
  Future jwt;
  void onLoginSubmit(context) async {
    String username = _usernameController.text;
    String password = _passwordController.text;
    jwt = loginUser(username, password);
    Response resp = await jwt;
    if (resp.statusCode == 401) {
      SnackMessage(_scaffoldKey, "Invalid Username or password.", Colors.red,
          Icons.mood_bad_rounded);
    }
    if (resp.statusCode == 200) {
      Future.delayed(Duration.zero, () {
        Navigator.pushReplacementNamed(context, "/userinfo");
      });
    }
  }

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Stack(alignment: Alignment.center, children: [
        Center(
          child: Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 155.0,
                    child: Text.rich(
                      TextSpan(
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 65,
                              fontWeight: FontWeight.w600),
                          children: [
                            TextSpan(text: "Welcome to "),
                            TextSpan(
                                text: "Printed.",
                                style: TextStyle(
                                    fontWeight: FontWeight.w900,
                                    foreground: Paint()
                                      ..shader = LinearGradient(colors: <Color>[
                                        Colors.purple[900],
                                        Colors.indigo[700]
                                      ]).createShader(Rect.fromLTWH(
                                          0.0, 0.0, 200.0, 70.0))))
                          ]),
                    ),
                  ),
                  SizedBox(height: 45.0),
                  TextField(
                    controller: _usernameController,
                    obscureText: false,
                    style: TextStyle(fontFamily: 'Montserrat', fontSize: 20.0),
                    decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                        hintText: "Username",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32.0))),
                  ),
                  SizedBox(height: 25.0),
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    style: TextStyle(fontFamily: 'Montserrat', fontSize: 20.0),
                    decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                        hintText: "Password",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32.0))),
                  ),
                  SizedBox(
                    height: 35.0,
                  ),
                  Material(
                    elevation: 5.0,
                    borderRadius: BorderRadius.circular(30.0),
                    color: Colors.purple[800],
                    child: MaterialButton(
                      minWidth: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                      onPressed: () {
                        onLoginSubmit(context);
                        setState(() {}); // to update the UI
                      },
                      child: Text("Login",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 20.0,
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  Text.rich(
                    TextSpan(
                      style: TextStyle(fontSize: 15),
                      children: <TextSpan>[
                        TextSpan(text: "Don't have an account?"),
                        TextSpan(
                            text: ' Register.',
                            style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () => print('click')),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        FutureBuilder(
          future: jwt,
          builder: (context, snapshot) {
            print(snapshot.connectionState);
            if (snapshot.connectionState == ConnectionState.waiting) {
              // TODO: Replace Stack with AlertDialog (didnt know it existed)
              return Stack(
                alignment: Alignment.center,
                children: [
                  Opacity(
                      opacity: 0.7,
                      child: Container(
                        decoration: BoxDecoration(color: Colors.black),
                      )),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white),
                    height: 100,
                    width: MediaQuery.of(context).size.width / 1.5,
                    child: Center(
                        child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(
                          width: 15,
                        ),
                        Text("Loading")
                      ],
                    )),
                  )
                ],
              );
            }
            if (snapshot.hasData) {
            } else if (snapshot.hasError) {
              // Update the snackbar in the next frame after binding. needed to stop set state build conflict
              SnackMessage(_scaffoldKey, "Something Went Wrong!", Colors.red,
                  Icons.mood_bad_rounded);
            }
            return Container();
          },
        ),
      ]),
    );
  }
}
