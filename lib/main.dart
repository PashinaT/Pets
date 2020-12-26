import 'package:flutter/material.dart';
import 'package:pets/BaseAuth.dart';
import 'Router.dart';
import 'StartPage.dart';
import 'authorization.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: new Router(auth: new Auth()),
    );
  }
}
