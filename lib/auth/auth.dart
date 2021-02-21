import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' show jsonDecode;

final storage = FlutterSecureStorage();
const BASE_URL = "192.168.8.103:8000";

Future<http.Response> loginUser(String username, String password) async {
  var res = await http.post(Uri.http(BASE_URL, 'api/token/both/'), body: {
    "username": username,
    "password": password
  }).timeout(Duration(seconds: 5));
  Map<String, dynamic> data = jsonDecode(res.body);
  storage.write(key: "access_token", value: data["access"]);
  storage.write(key: "refresh_token", value: data["refresh"]);
  return res;
}

Future<bool> isLoggedIn() async {
  return (await storage.read(key: "access_token")) != null;
}

void refreshToken() async {
  String refreshToken = await storage.read(key: "refresh_token");
  http.Response res =
      await http.post(Uri.http(BASE_URL, 'api/token/access/'), body: {
    "refresh": refreshToken,
  }).timeout(Duration(seconds: 5));
  Map<String, dynamic> data = jsonDecode(res.body);
  storage.write(key: "access_token", value: data["access"]);
}

void logoutUser(context) async {
  storage.deleteAll();
  Future.delayed(Duration.zero, () {
    Navigator.pushNamedAndRemoveUntil(context, "/", (r) => false);
  });
}

// void authenticatedRequest(String )
Future<http.Response> authRequest(String endPoint) async {
  String accessToken = await storage.read(key: "access_token");
  var res = await http.get((Uri.http(BASE_URL, 'api/$endPoint/')),
      headers: {"Authorization": "Bearer $accessToken"});

  // TODO: If result is 401 (Unauthorized) try refreshing the token and trying the request again.
  return res;
}

void printTokens() async {
  print(await storage.read(key: "access_token"));
  print(await storage.read(key: "refreshtoken"));
}
