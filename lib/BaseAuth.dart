



import 'package:pets/db/HelperDb.dart';

import 'db/UsersDb.dart';

abstract class BaseAuth{
  Future<int> signIn(String login, String password);
  Future<UsersDb> getUser();
}
class Auth implements  BaseAuth {

  HelperDb helperDb = new HelperDb();
  Future<UsersDb> user;

  Future<int> signIn(String login, String password) async {
    Future<UsersDb> user =helperDb.getUserByLoginAndPassword(login,password);
    this.user = user;
    return user.then((value) => value.id);
  }

  Future<UsersDb> getUser() async{
    return this.user;
  }

}