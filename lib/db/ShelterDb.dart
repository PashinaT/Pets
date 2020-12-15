import 'package:pets/db/ListPets.dart';

class ShelterDb {
  int id;
  String nameShelter;
  String addressShelter;
  List<ListPets> _listPets;

  ShelterDb(this.id, this.nameShelter, this.addressShelter);

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id_shelter': id,
      'name_shelter': nameShelter,
      'name_address': addressShelter,
    };
    return map;
  }

  ShelterDb.fromMap(Map<String, dynamic> map) {
    id = map['id_shelter'];
    nameShelter = map['name_shelter'];
    addressShelter = map['name_address'];
  }
}
