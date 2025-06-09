import 'package:newsapp/login_signup/JsonModels/users.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  final databaseName = "news.db";
  String users =
      "create table users (usrId INTEGER PRIMARY KEY AUTOINCREMENT, usrName TEXT UNIQUE, usrPassword TEXT)";

  Future<Database> initDB() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, databaseName);

    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute(users);
      },
    );
  }

  //Login Method
  Future<bool> login(Users user) async {
    final Database db = await initDB();

    var result = await db.rawQuery(
      "select * from users where usrName = '${user.usrName}' AND usrPassword = '${user.usrPassword}'",
    );
    if (result.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  //Sign up
  Future<int> signup(Users user) async {
    final Database db = await initDB();

    return db.insert('users', user.toMap());
  }

  //Get User
  Future<Users?> getUser(String usrName) async {
    final Database db = await initDB();

    var res = await db.query(
      "users",
      where: "usrName = ?",
      whereArgs: [usrName],
    );
    return res.isNotEmpty ? Users.fromMap(res.first) : null;
  }
}
