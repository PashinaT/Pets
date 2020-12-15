import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pets/db/ListPets.dart';
import 'package:pets/db/ShelterDb.dart';

import 'db/HelperDb.dart';

class AddShelter extends StatefulWidget {
  AddShelter(
      {Key key, this.title, this.listPet, this.isUpdating, this.isFoundPage})
      : super(key: key);

  bool isUpdating;
  bool isFoundPage;
  ListPets listPet;
  String title;

  @override
  State<StatefulWidget> createState() {
    return AddShelterForm(title, isUpdating);
  }
}

class AddShelterForm extends State<AddShelter> {
  final String title;
  int id;
  String nameShelter;
  String addressShelter;
  bool isUpdating;
  Future<List<ListPets>> listPets;
  ShelterDb shelterDb;

  AddShelterForm(this.title, this.isUpdating);

  final formKey = new GlobalKey<FormState>();
  var dbHelper;

  @override
  void initState() {
    super.initState();
    dbHelper = HelperDb();
    refreshList();
  }

  refreshList() {
    setState(() {});
  }

  validate() {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      if (isUpdating) {
        dbHelper.updateShelter(shelterDb);
        setState(() {
          isUpdating = false;
        });
      } else {
        ShelterDb e = ShelterDb(null, nameShelter, addressShelter);
        dbHelper.saveShelter(e);
      }
      Navigator.pop(context, true);
    }
  }

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
      body: Form(
          key: formKey,
          child: Padding(
              padding: EdgeInsets.only(left: 15, right: 15.0),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  verticalDirection: VerticalDirection.down,
                  children: <Widget>[
                    TextFormField(
                      controller: TextEditingController(
                          text: shelterDb == null ? "" : shelterDb.nameShelter),
                      decoration: InputDecoration(labelText: 'Название приюта'),
                      onSaved: (val) => {
                        nameShelter = val,
                        if (shelterDb != null) {shelterDb.nameShelter = val}
                      },
                    ),
                    TextFormField(
                      controller: TextEditingController(
                          text: shelterDb == null
                              ? ""
                              : shelterDb.addressShelter),
                      decoration: InputDecoration(labelText: 'Адресс приюта'),
                      onSaved: (val) => {
                        addressShelter = val,
                        if (shelterDb != null) {shelterDb.addressShelter = val}
                      },
                    ),
                    // TextFormField(
                    //   controller: TextEditingController(
                    //       text: namePet == null ? "" : namePet),
                    //   decoration: InputDecoration(labelText: 'Фото'),
                    //   onSaved: (val) => namePet = val,
                    // ),
                    SizedBox(
                      width: double.infinity, // match_parent
                      child: RaisedButton.icon(
                        onPressed: validate,
                        color: Colors.pink,
                        textColor: Colors.white,
                        icon: Icon(Icons.save),
                        label: Text('Сохранить'),
                      ),
                    )
                  ]))),
    );
  }
}
