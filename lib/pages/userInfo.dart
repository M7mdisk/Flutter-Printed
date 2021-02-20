import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:printed/auth/auth.dart';
import 'package:printed/models/User.dart';

class UserInfo extends StatefulWidget {
  @override
  _UserInfoState createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInfo> {
  Future<User> futureUser;

  @override
  void initState() {
    super.initState();
    futureUser = fetchUserData();
  }

  Future<User> fetchUserData() async {
    final resp = await authRequest("myaccount");
    if (resp.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return User.fromJson(jsonDecode(resp.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to lfoad album');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          elevation: 0,
          title: Center(
              child: Text(
            "User Info",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
          )),
        ),
        body: FutureBuilder<User>(
            future: futureUser,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 20.0, horizontal: 15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    // mainAxisAlignment: ,
                    children: [
                      Center(
                        child: CircleAvatar(
                          radius: 120,
                          backgroundImage:
                              Image.network(snapshot.data.avatarUrl).image,
                        ),
                      ),
                      SizedBox(height: 30),
                      Text(
                        "NAME",
                        style: TextStyle(
                            fontSize: 25.0,
                            letterSpacing: 1,
                            fontWeight: FontWeight.w300),
                      ),
                      SizedBox(height: 10),
                      Center(
                        child: Text(
                          "${snapshot.data.firstName} ${snapshot.data.lastName}",
                          style: TextStyle(
                              fontSize: 30.0,
                              letterSpacing: 1,
                              fontWeight: FontWeight.w800),
                        ),
                      ),
                      SizedBox(height: 30),
                      Text(
                        "EMAIL",
                        style: TextStyle(
                            fontSize: 25.0,
                            letterSpacing: 1,
                            fontWeight: FontWeight.w300),
                      ),
                      SizedBox(height: 10),
                      Center(
                        child: Text(
                          snapshot.data.email,
                          style: TextStyle(
                              fontSize: 30.0,
                              letterSpacing: 1,
                              fontWeight: FontWeight.w800),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          ElevatedButton(
                            child: Text(
                              "Logout",
                              style: TextStyle(fontSize: 20),
                            ),
                            onPressed: () {
                              logoutUser(context);
                            },
                          )
                        ],
                      )
                    ],
                  ),
                );
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }

              // By default, show a loading spinner.
              return Center(child: CircularProgressIndicator());
            }));
  }
}
