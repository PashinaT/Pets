import 'dart:async';
import 'dart:convert';
import 'dart:io' as io;
import 'dart:io';
import 'package:kinfolk/kinfolk.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pets/db/ShelterDb.dart';
import 'package:sqflite/sqflite.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

import 'ListPets.dart';
import 'UsersDb.dart';

class HelperDb {
  static Database _db;
  static const String TABLE_LIST_PETS = 'table_list_pets';
  static const String TABLE_SHELTER = 'table_shelter';
  static const String ID_LIST_PETS = 'id_list_pets';
  static const String ID_SHELTER = 'id_shelter';
  static const String PETS_ID_SHELTER = 'pets_id_shelter';
  static const String NAME_LIST_PETS = 'name_list_pets';
  static const String NAME_SHELTER = 'name_shelter';
  static const String ADDRESS_SHELTER = 'name_address';
  static const String VIEW_LIST_PETS = 'view_list_pets';
  static const String COLOR_LIST_PETS = 'color_list_pets';
  static const String IS_FOUND = 'is_found_list_pets';
  static const String IMAGE = 'image_list_pets';
  static const String DB_NAME = 'pets';

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();
    return _db;
  }

  Database getDatabase() {
    return _db;
  }

  initDb() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, DB_NAME);
       var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  _onCreate(Database db, int version) async {
    await db.execute(
        "CREATE TABLE $TABLE_LIST_PETS ($ID_LIST_PETS INTEGER PRIMARY KEY,"
        " $NAME_LIST_PETS TEXT,"
        " $VIEW_LIST_PETS TEXT,"
        " $PETS_ID_SHELTER INTEGER,"
        " $COLOR_LIST_PETS TEXT,"
        " $IS_FOUND INTEGER,"
        " $IMAGE TEXT,"
        "FOREIGN KEY ($PETS_ID_SHELTER) REFERENCES $TABLE_SHELTER ($ID_SHELTER)"
        ")");

    await db.execute(
        "CREATE TABLE $TABLE_SHELTER ($ID_SHELTER INTEGER PRIMARY KEY,"
            " $NAME_SHELTER TEXT,"
            " $ADDRESS_SHELTER TEXT"
            ")");
  }

  void saveListPets(ListPets listPets) async {
    var dbClient = await db;
    await dbClient.insert(TABLE_LIST_PETS, listPets.toMap());
  }

  Future<List<ListPets>> getListPets(bool isFound) async {
    var dbClient = await db;
    List<ListPets> listPets = [];
    int isFoundInt = isFound == true ? 1 : 0;
    List<Map> maps = [];
    if (isFound == false){
      maps = await dbClient.rawQuery(
          "SELECT * FROM $TABLE_LIST_PETS  where $IS_FOUND=" +
              isFoundInt.toString());
    } else{
      maps = await dbClient.rawQuery(
          "SELECT * FROM $TABLE_LIST_PETS join $TABLE_SHELTER  on"
              " $TABLE_LIST_PETS.$PETS_ID_SHELTER = $TABLE_SHELTER.$ID_SHELTER where $IS_FOUND=" +
              isFoundInt.toString());
    }


    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        listPets.add(ListPets.fromMap(maps[i]));
      }
    }
    return listPets;
  }

  Future<int> deleteListPets(int id) async {
    var dbClient = await db;
    return await dbClient
        .delete(TABLE_LIST_PETS, where: '$ID_LIST_PETS = ?', whereArgs: [id]);
  }

  Future<int> updateListPets(ListPets listPets) async {
    var dbClient = await db;
    return await dbClient.update(TABLE_LIST_PETS, listPets.toMap(),
        where: '$ID_LIST_PETS = ?', whereArgs: [listPets.id]);
  }

  void saveShelter(ShelterDb shelterDb) async {
    var dbClient = await db;
    await dbClient.insert(TABLE_SHELTER, shelterDb.toMap());
  }

  Future<List<ShelterDb>> getShelter() async {
    var dbClient = await db;
    List<ShelterDb> shelterList = [];
    List<Map> maps = await dbClient.rawQuery("SELECT * FROM $TABLE_SHELTER");
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        shelterList.add(ShelterDb.fromMap(maps[i]));
      }
    }
    return shelterList;
  }

  Future<int> deleteShelter(int id) async {
    var dbClient = await db;
    return await dbClient
        .delete(TABLE_SHELTER, where: '$ID_SHELTER = ?', whereArgs: [id]);
  }

  Future<int> updateShelter(ShelterDb shelterDb) async {
    var dbClient = await db;
    return await dbClient.update(TABLE_SHELTER, shelterDb.toMap(),
        where: '$ID_SHELTER = ?', whereArgs: [shelterDb.id]);
  }

  Future<UsersDb> getUserByLoginAndPassword (String login, String password) async{
    UsersDb user;
    return user;
  }
}
