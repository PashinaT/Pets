import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'CreateAppeal.dart';
import 'FoundAnimals.dart';
import 'LostAnimals.dart';
import 'Shelter.dart';

class StartPage extends StatelessWidget {
  StartPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            title,
            style: TextStyle(
              fontFamily: 'Comic',
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Colors.pink,
        ),
        body: Center(
            child: Container(
                decoration: BoxDecoration(color: Colors.white),
                child: ListView(children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left: 10.0, top: 10.0),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _getIconSurveys('Создать заявку', context,
                          (context) => CreateAppeal(title: "Создать заявку")),
                      _getIconSurveys(
                          'Список приютов', context, (context) => Shelter(title:'Приюты')),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _getIconSurveys(
                          'Потеряшки',
                          context,
                          (context) =>
                              LostAnimals(title: "Потеряшки", isFoundPage: false)),
                      _getIconSurveys(
                          'Найденыши',
                          context,
                          (context) =>
                              FoundAnimals(title: "Найденыши", isFoundPage: true))
                    ],
                  ),
                ]))));
  }
}

Widget _getIconSurveys(String name, BuildContext context, Function nextPage) {
  return Container(
      padding: EdgeInsets.only(top: 20.0),
      height: 80,
      child: Row(children: <Widget>[
        Container(
          width: 170.0,
          child: OutlineButton(
            padding: EdgeInsets.only(left: 10.0),
            child: Center(
                child: Container(
                    child: Text(
              name,
              style: TextStyle(
                color: Colors.black,
                fontSize: 18.0,
                fontFamily: '',
              ),
              textAlign: TextAlign.center,
            ))),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: nextPage));
            },
            borderSide: BorderSide(width: 2, color: Colors.pink),
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(10.0)),
          ),
        ),
      ]));
}
