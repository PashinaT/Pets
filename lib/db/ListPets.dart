import 'dart:io';

import 'ShelterDb.dart';

class ListPets {
  int id;
  bool isFound;
  String namePet;
  String colorPet;
  String viewPet;
  String image;
  ShelterDb shelter;

  ListPets(this.id, this.namePet, this.colorPet, this.viewPet, this.isFound,
      this.image, this.shelter);

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id_list_pets': id,
      'is_found_list_pets': isFound == true ? 1 :0,
      'name_list_pets': namePet,
      'color_list_pets': colorPet,
      'view_list_pets': viewPet,
      'image_list_pets': image,
      'pets_id_shelter': shelter == null ? -1 : shelter.id,
    };
    return map;
  }

  ListPets.fromMap(Map<String, dynamic> map) {
    id = map['id_list_pets'];
    namePet = map['name_list_pets'];
    viewPet = map['view_list_pets'];
    colorPet = map['color_list_pets'];
    isFound = map['is_found_list_pets'] == 1 ? true : false;
    image = map['image_list_pets'];
    if (map['id_shelter'] != null) {
      shelter = new ShelterDb(
          map['id_shelter'], map['name_shelter'], map['name_address']);
    }
  }
}
