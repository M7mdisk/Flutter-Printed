import 'package:flutter/material.dart';

class SnackMessage {
  String title;
  Color color;
  IconData icon;
  GlobalKey<ScaffoldState> scaffold;
  SnackMessage(this.scaffold, this.title, this.color, this.icon) {
    final snackBar = SnackBar(
        backgroundColor: this.color,
        content: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              this.icon,
              size: 32,
            ),
            SizedBox(
              width: 15,
            ),
            Text(
              this.title,
              style: TextStyle(fontSize: 20),
            ),
          ],
        ));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      this.scaffold.currentState.showSnackBar(snackBar);
    });
  }
}
