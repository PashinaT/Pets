import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'AddShelter.dart';
import 'db/HelperDb.dart';
import 'db/ShelterDb.dart';

class Shelter extends StatefulWidget {
  Shelter({Key key, this.title}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ShelterForm(title);
  }

  final String title;
}

class ShelterForm extends State<Shelter> {
  Future<List<ShelterDb>> shelterDb;
  String nameCategory;
  String title;
  int accountId;

  ShelterForm(this.title);

  final formKey = new GlobalKey<FormState>();
  var dbHelper;
  bool isUpdating;

  @override
  void initState() {
    super.initState();
    dbHelper = HelperDb();
    isUpdating = false;
    refreshList();
  }

  refreshList() {
    setState(() {
      shelterDb = dbHelper.getShelter();
    });
  }

  list() {
    return FutureBuilder<List<ShelterDb>>(
        future: shelterDb,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                ShelterDb item = snapshot.data[index];
                return ListTile(
                  title: Text('Название '+ item.nameShelter +', адрес: ' + item.addressShelter)
                );
              },
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
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
      body: list(),
      floatingActionButton: new FloatingActionButton(
        backgroundColor: Colors.pink,
        onPressed: () async {
          Object refresh = await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AddShelter(
                      title: "Добавить приют", isUpdating: false,)));
          if (refresh != null) refreshList();
        },
        child: new Icon(Icons.add),
      ),
    );
  }
}
