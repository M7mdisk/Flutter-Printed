import 'dart:convert';

import 'package:http/http.dart' as http;

const BASE_URL = "192.168.8.103:8000";

Future<http.Response> registerUser(
    String username, String password, String email) async {
  // var res = await http.post(Uri.http(BASE_URL, 'api/token/both/'), body: {
  //   "username": username,
  //   "password": password
  // }).timeout(Duration(seconds: 5));
  // Map<String, dynamic> data = jsonDecode(res.body);
  // return res;
}

Future<bool> fetchuserExists(String username) async {
  var res = await http
      .read(Uri.http(BASE_URL, '/api/userexists/', {"username": username}))
      .timeout(Duration(seconds: 5));
  Map<String, dynamic> data = jsonDecode(res);
  return Future<bool>.value(data["message"]);
}
