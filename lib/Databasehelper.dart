import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'UserModelClass.dart';

class DatabaseHelper {
  static final _databaseName = "mydatabase.db";
  static final _databaseVersion = 1;

  static final table = 'userss_table';

  static final columnID = 'id';
  static final columnName = 'name';
  static final columnEmail = 'email';
  static final columnPhoneNumber = 'phone';
  static final columnPassword = 'password';
  static final columnProfilePic = 'profilePic';
  static final columnisDeleted = 'isDeleted';

  // make this a singleton class
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  // open the database
  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  // create the table
  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $table (
            $columnID TEXT PRIMARY KEY,
            $columnName TEXT,
            $columnEmail TEXT NOT NULL UNIQUE,
            $columnPhoneNumber TEXT NOT NULL UNIQUE,
            $columnPassword TEXT NOT NULL,
            $columnProfilePic TEXT NOT NULL,
            $columnisDeleted INTEGER NOT NULL
          )
          ''');
  }

  // insert a user into the database
  Future<int> insert(User user) async {
    Database db = await instance.database;
    return await db.insert(
      table,
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<User>> getAllUsers(int isDelete) async {
    final db = await database;
    final result = await db
        .query(table, where: '$columnisDeleted = ?', whereArgs: [isDelete]);
    print(result.toString());
    return result.map((json) => User.fromMap(json)).toList();
  }

  Future<int> updateUser(User user) async {
    final db = await database;
    return await db.update(table, user.toMap(),
        where: '$columnID = ?', whereArgs: [user.id]);
  }

  Future<int> deleteUser(User user) async {
    final db = await database;
    return await db.delete(table, where: '$columnID = ?', whereArgs: [user.id]);
  }

  // query a user from the database
  Future<User?> queryUser(String emailOrPhoneNumber, String password) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> maps = await db.query(table,
        where:
            '$columnPassword = ? AND ($columnEmail = ? OR $columnPhoneNumber = ?) AND $columnisDeleted = ?',
        whereArgs: [password, emailOrPhoneNumber, emailOrPhoneNumber, 0]);
    if (maps.isNotEmpty) {
      return User.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<User?> queryUserDetails(String userId, int isDeleted) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> maps = await db.query(table,
        where: '$columnID = ? AND $columnisDeleted = ?',
        whereArgs: [userId, isDeleted]);
    if (maps.isNotEmpty) {
      return User.fromMap(maps.first);
    } else {
      return null;
    }
  }
}
