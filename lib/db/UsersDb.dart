class UsersDb {
  int id;
  String login;
  String password;

  UsersDb(this.id, this.login,this.password);

  UsersDb.fromMap(Map<String, dynamic> map) {
    id = map['user_id'];
    login = map['login'];
    password = map['password'];
  }

  UsersDb.fromJson(Map<String, dynamic> map) {
    id = int.parse(map['id']);
    login = map['login'];
    password = map['password'];
  }
}