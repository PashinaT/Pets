import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'PetFindClaim.dart';
import 'PetLossClaim.dart';

class CreateAppeal extends StatelessWidget {
  CreateAppeal({Key key, this.title}) : super(key: key);

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
                    padding: EdgeInsets.only(right: 15.0),
                  child:                  Hero(
                    tag: "icon/logo.jpg",
                    child: Image(
                      image: AssetImage("icon/logo.jpg")
                    ),
                  )),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _getIconSurveys(
                          'Потерял питомца', context, (context) =>
                          PetLossClaim(title:'Пропал питомец',isFoundPage: false,isUpdating:false),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _getIconSurveys('Нашел питомца', context, (context) => PetFindClaim(
                              title: 'Найден питомец',isFoundPage: true,isUpdating:false),
                        ),
                    ]
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
          width: 350.0,
          child: OutlineButton(
            padding: EdgeInsets.only(left: 10.0),
            child: Center(
                child: Container(
                    child:Text(name,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18.0,
                        fontFamily: '',
                      ),
                      textAlign: TextAlign.center,
                    )
                )),
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
