import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pets/PetFindClaim.dart';
import 'package:pets/PetLossClaim.dart';
import 'package:pets/db/ListPets.dart';
import 'db/HelperDb.dart';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
class FoundAnimals extends StatefulWidget {
  FoundAnimals({Key key, this.title,this.isFoundPage,this.similar}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return FoundAnimalsForm(title,isFoundPage,similar);
  }

  final String title;
  final bool isFoundPage;
  bool similar;

}

class FoundAnimalsForm extends State<FoundAnimals> {
  Future<List<ListPets>> lisPets;
  String namePet;
  String title;
  int accountId;
  ListPets listPet;
  bool similar;
  Uint8List _bytesImage;

  FoundAnimalsForm(this.title,this.isFoundPage,this.similar);

  final formKey = new GlobalKey<FormState>();
  var dbHelper;
  bool isUpdating;
  bool isFoundPage;

  @override
  void initState() {
    super.initState();
    dbHelper = HelperDb();
    isUpdating = false;
    refreshList();
  }

  refreshList() {
    setState(() {
      lisPets = dbHelper.getListPets(isFoundPage);
    });
  }

  list() {
    return FutureBuilder<List<ListPets>>(
        future: lisPets,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                ListPets item = snapshot.data[index];
                return Card(
                    child: ListTile(
                      leading: item.image==null ? Icon(
                        Icons.pets,
                        color: Colors.pink,
                        size: 50,
                      ) :
                      Image.memory(Base64Decoder().convert(item.image)),
                      title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[Text(item.namePet)]),
                      subtitle: Text('Вид: ' + item.viewPet +  ', цвет:' + item.colorPet + ", приют:"+item.shelter.nameShelter),
                      trailing: new PopupMenuButton(
                        itemBuilder: (_) => <PopupMenuItem<String>>[
                          // new PopupMenuItem<String>(
                          //     child: const Text('Редактировать'), value: '0'),
                          new PopupMenuItem<String>(
                              child: const Text('Удалить'), value: '1'),
                          // new PopupMenuItem<String>(
                          //     child: const Text('Поиск похожих'), value: '2'),
                        ],
                        onSelected: (val) async {
                          // if (val == '0') {
                          //   Object refresh = await Navigator.push(
                          //       context,
                          //       MaterialPageRoute(
                          //           builder: (context) =>
                          //               PetFindClaim(
                          //             title: "Обновить питомца",
                          //             isUpdating: true,
                          //             listPet:item,
                          //             isFoundPage:true,
                          //           ))
                          //   );
                          //   if (refresh != null) refreshList();
                          // }
                          if (val == '1') {
                            dbHelper.deleteListPets(item.id);
                            refreshList();
                          }
                          // if (val == '2') {
                          //   Object refresh = await Navigator.push(
                          //       context,
                          //       MaterialPageRoute(
                          //           builder: (context) => ListLost(
                          //               title: "Похожие на питомца "+item.namePet,
                          //               isFoundPage:true,
                          //               similar:true
                          //           ))
                          //   );
                          // }
                        },
                      ),
                    ));
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
      // ),
    );
  }
}
