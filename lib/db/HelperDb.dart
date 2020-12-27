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
  static const String TABLE_USERS = 'Users';
  static const String LOGIN = 'login';
  static const String PASSWORD = 'password';
  static const String ID_USER  ='user_id';
  static String TOKEN = '';

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
    await deleteDatabase(path);
       var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  Future<String> getToken() async {
    if (TOKEN.length == 0) {
      var response = await http
          .post('http://10.0.2.2:8080/app/rest/v2/oauth/token', headers: {
        "Authorization": "Basic Y2xpZW50OnNlY3JldA==",
        "Content-type": "application/x-www-form-urlencoded"
      }, body: {
        "grant_type": "password",
        "username": "admin",
        "password": "admin"
      }).timeout(const Duration(seconds: 3));
      TOKEN = jsonDecode(response.body)["access_token"];
      return TOKEN;
    } else {
      return TOKEN;
    }
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

    await db.execute(
        "CREATE TABLE $TABLE_USERS ($ID_USER INTEGER PRIMARY KEY,"
            " $LOGIN TEXT,"
            " $PASSWORD TEXT"
            ")");
    await db.rawInsert(
      "Insert into $TABLE_USERS($PASSWORD,$LOGIN) values (1,'1');"
    );
  }

  void saveListPets(ListPets listPets) async {
    var dbClient = await db;
    await dbClient.insert(TABLE_LIST_PETS, listPets.toMap());
  }

  Future<List<ListPets>> getListPets(bool isFound) async {

      http.Response response;
      var queryParameters = {
        "conditions": [
          {"property": "isFound", "operator": "=", "value": isFound},
        ]
      };
      var param = Uri.encodeComponent(jsonEncode(queryParameters));
      print(param);
      try {
      response = await http.get(
          'http://10.0.2.2:8080/app/rest/v2/entities/pets_TableListPets2/search?view=tableListPets-view&filter=' +
              param,
            headers: {
              "Authorization": "Bearer " + await getToken()
            }).timeout(const Duration(seconds: 6));
    } on TimeoutException catch (e) {
      var dbClient = await db;
      List<ListPets> listPets = [];
      int isFoundInt = isFound == true ? 1 : 0;
      List<Map> maps = [];
      if (isFound == false) {
        maps = await dbClient.rawQuery(
            "SELECT * FROM $TABLE_LIST_PETS  where $IS_FOUND=" +
                isFoundInt.toString());
      } else {
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

    List<ListPets> pets = (json.decode(response.body) as List)
        .map((i) => ListPets.fromJson(i))
        .toList();
    String data = response.body;
    print("Cервера" + data);
    return pets;
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

    http.Response response;
    try {
      response = await http.get(
          'http://10.0.2.2:8080/app/rest/v2/entities/pets_TableShelter?view=tableShelter-view',
          headers: {
            "Authorization": "Bearer " + await getToken()
          }).timeout(const Duration(seconds: 3));
    } on TimeoutException catch (e) {
      print('Timeout');
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
    on Error catch (e) {
      print('Error: $e');
    }
    List<ShelterDb> shelters = (json.decode(response.body) as List)
        .map((i) => ShelterDb.fromJson(i))
        .toList();
    String data = response.body;
    print("Cервер" + data);
    return shelters;
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
    var queryParameters = {
      "conditions": [
        {"property": "login", "operator": "=", "value": login},
        {"property": "password", "operator": "=", "value": password},
      ]
    };
    var param = Uri.encodeComponent(jsonEncode(queryParameters));
    http.Response response;

    try {
      response = await http.get(
          'http://10.0.2.2:8080/app/rest/v2/entities/pets_Users/search?view=users-view&filter=' +
              param,
          headers: {
            "Authorization": "Bearer " + await getToken()
          }).timeout(const Duration(seconds: 3));
    } on TimeoutException catch (e) {
      print('Timeout');
      var dbClient = await db;
      List<Map> maps = await dbClient.rawQuery("SELECT * FROM $TABLE_USERS "
          "where $LOGIN=" +
          login +
          " and $PASSWORD=" +
          password);
      user = new UsersDb(-1, "", "");
      if (maps.length > 0) {
        user = UsersDb.fromMap(maps[0]);
      }
      return user;
    } on Error catch (e) {
      print('Error: $e');
    }
    List<UsersDb> users = (json.decode(response.body) as List)
        .map((i) => UsersDb.fromJson(i))
        .toList();
    String data = response.body;
    print("Cервер" + data);
    return users.single;
  }
}
