

import 'package:flutter/cupertino.dart';
import 'package:pets/StartPage.dart';
import 'package:pets/authorization.dart';

import 'BaseAuth.dart';
import 'db/UsersDb.dart';

enum AuthStatus { NOT_DETERMINED, NOT_LOGGED_IN, LOGGED_IN, }

class Router extends StatefulWidget {
  Router({this.auth});
  final BaseAuth auth;

  @override
  State<StatefulWidget> createState() => new _RouterState();
}

class _RouterState extends State<Router> {

  AuthStatus authStatus = AuthStatus.NOT_DETERMINED;
  UsersDb user;

  @override
  Widget build(BuildContext context) {
    switch(authStatus) {
      case AuthStatus.LOGGED_IN:
        return new StartPage(title:"Питомцы");
        break;
      case AuthStatus.NOT_LOGGED_IN:
      case AuthStatus.NOT_DETERMINED:
        return new Authorization( widget.auth, loginCallback);
        break;
    }

  }

  void loginCallback(){
    widget.auth.getUser().then((userC)
    {
      setState(() {
        user=userC;
      });
    });
    setState(() {
      authStatus = AuthStatus.LOGGED_IN;
    });
  }

  @override
  void initState() {
    super.initState();
    widget.auth.getUser().then((userC) {
      setState(() {
        if (userC != null) {
          user = userC;
        }
        authStatus = userC == null ? AuthStatus.NOT_LOGGED_IN : AuthStatus.LOGGED_IN;
      });
    });
  }



}