import 'dart:async';
import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:brainfit/shared/models/user.model.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = new DatabaseHelper.internal();

  factory DatabaseHelper() => _instance;

  static Database? _db;
  static Database? _assessmentDb;

  Future<Database> get db async => _db ??= await initDb();
  Future<Database> get assessmentDb async => _assessmentDb ??= await initDb();

  DatabaseHelper.internal();

  initDb() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "brainfit.db");
    var theDb = await openDatabase(path, version: 1, onCreate: _onCreate);
    return theDb;
  }

  void _onCreate(Database db, int version) async {
    // When creating the db, create the table
    await db.execute(
        "CREATE TABLE User(id INTEGER PRIMARY KEY AUTOINCREMENT, userId TEXT NOT NULL, email TEXT NOT NULL, password TEXT, authToken TEXT NOT NULL, gId TEXT, fbId TEXT, appleId TEXT, loginType TEXT NOT NULL, name TEXT NOT NULL)");
    print("User table created");

    // When creating the db, create the table
    await db.execute(
        "CREATE TABLE Assessment(id INTEGER PRIMARY KEY AUTOINCREMENT, userId TEXT NOT NULL, email TEXT NOT NULL, password TEXT, authToken TEXT NOT NULL, gId TEXT, fbId TEXT, appleId TEXT, loginType TEXT NOT NULL, name TEXT NOT NULL)");
    print("User table created");
  }

  Future<int> saveUser() async {
    var dbClient = await db;
    var existingUsers = await dbClient.query("User");
    if (existingUsers.length > 0) {
      int res = await dbClient.delete("User");
      return res;
    }
    int res = await dbClient.insert("User", User.toMap());
    return res;
  }

  Future<int> updateUserNumber(String number) async {
    var dbClient = await db;
    int res =
        await dbClient.rawUpdate('UPDATE USER SET phoneNumber = ?', [number]);
    print("Updated [$res]");
    return res;
  }

  Future<int> deleteUsers() async {
    var dbClient = await db;
    User.deleteUser();
    int res = await dbClient.delete("User");
    return res;
  }

  Future<bool> isLoggedIn() async {
    var dbClient = await db;
    var res = await dbClient.query("User");
    return res.length > 0 ? true : false;
  }

  Future<List<Map<String, dynamic>>> getLoggedInUser() async {
    var dbClient = await db;
    var res = await dbClient.query("User");

    /// Save data to User class
    if (res.length > 0) {
      User.saveUserParamsFromDatabase(res[0]);
    }
    return res;
  }
}
