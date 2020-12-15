import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pets/db/ListPets.dart';
import 'package:image_picker/image_picker.dart';

import 'db/HelperDb.dart';
import 'db/ShelterDb.dart';

class PetFindClaim extends StatefulWidget {
  PetFindClaim(
      {Key key, this.title, this.listPet, this.isUpdating, this.isFoundPage})
      : super(key: key);

  bool isUpdating;
  bool isFoundPage;
  ListPets listPet;
  String title;

  @override
  State<StatefulWidget> createState() {
    return PetFindClaimForm(title, listPet, isUpdating, isFoundPage);
  }
}

class PetFindClaimForm extends State<PetFindClaim> {
  final String title;
  int id;
  String namePet;
  String colorPet;
  String viewPet;
  String photoPet;
  bool isUpdating;
  ListPets listPet;
  bool isFound;
  bool isFoundPage;
  Future<List<ListPets>> listPets;
  File _image;
  final namePetController = TextEditingController();
  final colorPetController = TextEditingController();

  PetFindClaimForm(this.title, this.listPet, this.isUpdating, this.isFoundPage);

  List<DropdownMenuItem> shelterList = [];
  ShelterDb shelterDb;

  final formKey = new GlobalKey<FormState>();
  var dbHelper;

  final picker = ImagePicker();
  Uint8List _bytesImage;
  String base64Image;

  Future getImage() async {
    var image2 = await picker.getImage(
      source: ImageSource.gallery,
    );
    File image3 = File(image2.path);
    List<int> imageBytes = image3.readAsBytesSync();
    print(imageBytes);
    base64Image = base64Encode(imageBytes);
    setState(() {
      _image = File(image2.path);
      if (listPet != null) {
        listPet.image = base64Image;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    dbHelper = HelperDb();
    isFound = isFound == null ? false : listPet.isFound;
    namePetController.text =
        listPet == null ? namePet == null ? "" : namePet : listPet.namePet;
    colorPetController.text = listPet == null ? "" : listPet.colorPet;
    List<DropdownMenuItem> _shelterList = [];

    dbHelper.getShelter().then((row) {
      row.map((map) {
        return getDropDownWidgetAccounts(map);
      }).forEach((dropDownItems) {
        _shelterList.add(dropDownItems);
      });
      setState(() {
        shelterList = _shelterList;
      });
    });
  }

  DropdownMenuItem getDropDownWidgetAccounts(ShelterDb map) {
    return DropdownMenuItem(
      value: map,
      child: Text(map.nameShelter),
    );
  }

  refreshList() {
    setState(() {});
  }

  validate() {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      if (isUpdating) {
        dbHelper.updateListPets(listPet);
        setState(() {
          isUpdating = false;
        });
      } else {
        ListPets e = ListPets(null, namePet, colorPet, viewPet, isFoundPage,
            base64Image, shelterDb);
        dbHelper.saveListPets(e);
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
                      controller: namePetController,
                      decoration: InputDecoration(labelText: 'Имя питомца'),
                      onSaved: (val) => {
                        namePet = val,
                        if (listPet != null) {listPet.namePet = val}
                      },
                    ),
                    TextFormField(
                      controller: colorPetController,
                      decoration: InputDecoration(labelText: 'Окрас питомца'),
                      onSaved: (val) => {
                        colorPet = val,
                        if (listPet != null) listPet.colorPet = val
                      },
                    ),
                    DropdownButtonFormField(
                      value: listPet == null ? null : listPet.viewPet,
                      onChanged: (value) {},
                      onSaved: (val) => {
                        viewPet = val,
                        if (listPet != null) {listPet.viewPet = val}
                      },
                      validator: (val) =>
                          val == null ? 'Выберите вид питомца' : null,
                      decoration: InputDecoration(
                        hintText: 'Выберите вид питомца',
                        suffixIcon: IconButton(
                          icon: Icon(Icons.clear),
                          onPressed: () {
                            formKey.currentState.reset();
                          },
                        ),
                      ),
                      items: ['Кошка', 'Собака', 'Птица']
                          .map((label) => DropdownMenuItem(
                                child: Text(label.toString()),
                                value: label,
                              ))
                          .toList(),
                    ),
                    SizedBox(
                      width: 250,
                      height: 200,
                      child: (listPet == null || listPet.image == null)
                          ? _image == null
                              ? Text('Нет изображения')
                              : Image.file(_image)
                          : Image.memory(
                              Base64Decoder().convert(listPet.image)),
                    ),
                    RaisedButton(
                      onPressed: getImage,
                      textColor: Colors.white,
                      color: Colors.white,
                      padding: const EdgeInsets.all(0.0),
                      child: Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: <Color>[
                              Color(0xFF0D47A1),
                              Color(0xFF1976D2),
                              Color(0xFF42A5F5),
                            ],
                          ),
                        ),
                        padding: const EdgeInsets.all(10.0),
                        child: Icon(Icons.add_a_photo),
                      ),
                    ),
                    DropdownButtonFormField(
                      onChanged: (value) {},
                      onSaved: (val) => shelterDb = val,
                      validator: (val) => val == null ? 'Выберите приют' : null,
                      decoration: InputDecoration(
                        hintText: 'В каком приюте? ',
                        suffixIcon: IconButton(
                          icon: Icon(Icons.clear),
                          onPressed: () {
                            formKey.currentState.reset();
                          },
                        ),
                      ),
                      items: shelterList,
                      // value: listPet.shelter.nameShelter.isNotEmpty
                      //     ? listPet.shelter.nameShelter
                      //     : null,
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
