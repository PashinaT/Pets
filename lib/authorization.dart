import 'package:flutter/material.dart';

import 'BaseAuth.dart';

class Authorization extends StatefulWidget {
  final BaseAuth auth;
  final VoidCallback voidCallback;
  Authorization(this.auth, this.voidCallback);

  String password;
  String login;

  @override
  State<StatefulWidget> createState() {
    new AuthorizationForm(login, password);
  }
}
class AuthorizationForm extends State<Authorization> {
  String login;
  String password;
  AuthorizationForm(login, password);
  final _formalKey =GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {

    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Вход в приложение'),
      ),
      body: Stack(
        children: <Widget>[
          new Container(
            padding: EdgeInsets.all(10.0),
            child: new Form (
              key: _formalKey,
              child:
                new ListView(
                  shrinkWrap: true,
                  children: <Widget>[
                    new Text('Введите логин и пароль'),
                    new Padding(padding: const EdgeInsets.fromLTRB(0.0, 100.0, 0.0, 0.0),
                    child: new TextFormField(
                      maxLines: 1,
                      keyboardType: TextInputType.name,
                      autofocus: false,
                      decoration:  new InputDecoration(
                        hintText: 'Login'
                      ),
                      validator: (value)=>value.isEmpty? "Enter your login":null,
                      onSaved: (value)=> login= value.trim(),
                    )),
                    new Padding(padding: const EdgeInsets.fromLTRB(0.0, 100.0, 0.0, 0.0),
                        child: new TextFormField(
                          maxLines: 1,
                          keyboardType: TextInputType.name,
                          autofocus: false,
                          decoration:  new InputDecoration(
                              hintText: 'Password'
                          ),
                          validator: (value)=>value.isEmpty? "Enter password":null,
                          onSaved: (value)=> password= value.trim(),
                        )),

                    new Padding(padding: const EdgeInsets.fromLTRB(0.0, 45.0, 0.0, 0.0),
                        child: SizedBox(
                          height:50.0,
                          child: new RaisedButton(elevation:5.0,
                              shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(30.0)),
                                color: Colors.pink,
                                child: new Text('Войти',
                                style: new TextStyle(fontSize: 24.0, color:Colors.white))

                              ,onPressed: validate)
                        )),
                  ],
                )
            )
          )
        ],
      )
    );
  }

  validate() async{

  }
}
