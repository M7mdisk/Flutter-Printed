import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:printed/api/api.dart';

import 'package:printed/auth/auth.dart';
import 'package:printed/models/snackMessage.dart';

class Register extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Register> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  Future jwt;

  void onRegisterSubmit(context) async {
    String username = _usernameController.text;
    String email = _emailController.text;
    String password = _passwordController.text;

    jwt = loginUser(username, password);
    Response resp = await jwt;
    if (resp.statusCode == 401) {
      SnackMessage(_scaffoldKey, "Invalid Username or password.", Colors.red,
          Icons.mood_bad_rounded);
    }
    if (resp.statusCode == 400) {
      SnackMessage(_scaffoldKey, "Something Went Wrong!", Colors.red,
          Icons.mood_bad_rounded);
    }
    if (resp.statusCode == 200) {
      Future.delayed(Duration.zero, () {
        Navigator.pushReplacementNamed(context, "/");
      });
    }
  }

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _password2Controller = TextEditingController();
  bool _userExists = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        body: Stack(alignment: Alignment.center, children: [
          ListView(padding: EdgeInsets.only(top: 90), children: [
            Form(
              key: _formKey,
              child: Center(
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
                                            ..shader =
                                                LinearGradient(colors: <Color>[
                                              Colors.purple[900],
                                              Colors.purple[700],
                                            ]).createShader(Rect.fromLTWH(
                                                    0.0, 0.0, 200.0, 70.0))))
                                ]),
                          ),
                        ),
                        SizedBox(height: 35.0),
                        TextFormField(
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter a Username';
                            }
                            return null;
                          },
                          controller: _usernameController,
                          obscureText: false,
                          style: TextStyle(
                              fontFamily: 'Montserrat', fontSize: 20.0),
                          decoration: InputDecoration(
                              labelText: 'Username',
                              errorText:
                                  _userExists ? "User already exists" : null,
                              contentPadding:
                                  EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(32.0))),
                        ),
                        SizedBox(height: 25.0),
                        TextFormField(
                          validator: (value) {
                            RegExp emailRegExp = new RegExp(
                                r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");
                            if (!emailRegExp.hasMatch(value)) {
                              return "Invalid Email adress.";
                            }
                            if (value.isEmpty) {
                              return 'Please enter your email';
                            }
                            return null;
                          },
                          controller: _emailController,
                          obscureText: false,
                          style: TextStyle(
                              fontFamily: 'Montserrat', fontSize: 20.0),
                          decoration: InputDecoration(
                              labelText: 'Email',
                              contentPadding:
                                  EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(32.0))),
                        ),
                        SizedBox(height: 25.0),
                        TextFormField(
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter a password.';
                            }
                            if (value.length < 8) {
                              return 'password must have at least 8 characters';
                            }
                            return null;
                          },
                          controller: _passwordController,
                          obscureText: true,
                          style: TextStyle(
                              fontFamily: 'Montserrat', fontSize: 20.0),
                          decoration: InputDecoration(
                              labelText: 'Password',
                              contentPadding:
                                  EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                              hintText: "Password",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(32.0))),
                        ),
                        SizedBox(height: 25.0),
                        TextFormField(
                          validator: (value) {
                            if (_passwordController.text !=
                                _password2Controller.text) {
                              return 'The passwords are not the same.';
                            }
                            if (value.isEmpty) {
                              return 'Please Repeat Your password.';
                            }
                            return null;
                          },
                          controller: _password2Controller,
                          obscureText: true,
                          style: TextStyle(
                              fontFamily: 'Montserrat', fontSize: 20.0),
                          decoration: InputDecoration(
                              labelText: 'Repeat Password',
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
                            padding:
                                EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                            onPressed: () async {
                              // to update the UI
                              _userExists = await fetchuserExists(
                                  _usernameController.text);
                              if (_userExists) {}
                              setState(() {});
                              if (_formKey.currentState.validate()) {
                                onRegisterSubmit(context);
                              }
                            },
                            child: Text("Register",
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
                              TextSpan(text: "Already Have an account?"),
                              TextSpan(
                                  text: ' Login.',
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
            ),
            FutureBuilder(
              future: jwt,
              builder: (context, snapshot) {
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
                  SnackMessage(_scaffoldKey, "Something Went Wrong!",
                      Colors.red, Icons.mood_bad_rounded);
                }
                return Container();
              },
            ),
          ]),
        ]));
  }
}
