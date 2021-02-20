import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert' show ascii, base64, json, jsonDecode;

final storage = FlutterSecureStorage();
const BASE_URL = "http://192.168.8.103:8000";

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  Future<String> attemptLogIn(String username, String password) async {
    var res = await http.post("${BASE_URL}/api/token/both/", body: {
      "username": username,
      "password": password
    }).timeout(Duration(seconds: 5));

    if (res.statusCode == 200) return res.body;
    return null;
  }

  void fetchshit() async {
    var username = _usernameController.text;
    var password = _passwordController.text;
    try {
      var jwt = await attemptLogIn(username, password);
      if (jwt != null) {
        Map<String, dynamic> data = jsonDecode(jwt);
        storage.write(key: "access_token", value: data["access"]);
        storage.write(key: "refresh_token", value: data["refresh"]);
        // print(jwt);
        // Navigator.push(context,
        //     MaterialPageRoute(builder: (context) => HomePage.fromBase64(jwt)));
      } else {
        print("Username or password incorrect");
      }
    } catch (e) {
      print(e);
    }
  }

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
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
                                    ..shader = LinearGradient(
                                      colors: <Color>[
                                        Colors.purple[900],
                                        Colors.purple[600]
                                      ],
                                    ).createShader(
                                        Rect.fromLTWH(0.0, 0.0, 200.0, 70.0))))
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
                      fetchshit();
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
                              color: Colors.blue, fontWeight: FontWeight.bold),
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
    );
  }
}
