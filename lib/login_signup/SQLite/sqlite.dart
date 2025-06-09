import 'package:bcrypt/bcrypt.dart';
import 'package:newsapp/login_signup/JsonModels/users.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  final databaseName = "news.db";
  String users =
      "CREATE TABLE users (usrId INTEGER PRIMARY KEY AUTOINCREMENT, usrName TEXT UNIQUE, usrPassword TEXT)";

  // Fungsi untuk menginisialisasi database
  Future<Database> initDB() async {
    // Mendapatkan path penyimpanan eksternal yang aman
    final directory =
        await getExternalStorageDirectory(); // Direkomendasikan untuk Android 10+
    final path = join(
      directory!.path,
      databaseName,
    ); // Menyimpan di folder aplikasi di penyimpanan eksternal

    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute(users);
      },
    );
  }

  // Login Method
  Future<bool> login(Users user) async {
    final Database db = await initDB();

    var result = await db.rawQuery(
      "SELECT * FROM users WHERE usrName = ?",
      [user.usrName], // Parameterized query untuk menghindari SQL Injection
    );

    if (result.isNotEmpty) {
      String storedHash = result.first['usrPassword'] as String;
      if (BCrypt.checkpw(user.usrPassword, storedHash)) {
        return true; // Login berhasil
      }
    }
    return false; // Login gagal
  }

  // Sign up Method
  Future<int> signup(Users user) async {
    final Database db = await initDB();

    // Cek apakah username sudah ada
    var existingUser = await getUser(user.usrName);
    if (existingUser != null) {
      throw Exception('Username already taken');
    }

    // Hash password sebelum disimpan
    String hashedPassword = BCrypt.hashpw(user.usrPassword, BCrypt.gensalt());
    user = Users(usrName: user.usrName, usrPassword: hashedPassword);

    return db.insert('users', user.toMap());
  }

  // Get User Method
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
