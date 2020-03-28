import 'dart:io';
import 'package:path/path.dart';
import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:beer_app/beer_model.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = new DatabaseHelper.internal();
  factory DatabaseHelper() => _instance;
  static Database _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();
    return _db;
  }

  DatabaseHelper.internal();

  initDb() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, "main.db");
    var ourDb = await openDatabase(path, version: 1, onCreate: _onCreate);
    return ourDb;
  }

  void _onCreate(Database db, int version) async {
    await db.execute(
        "CREATE TABLE Favourites(id INTEGER PRIMARY KEY, name TEXT, tagline TEXT)");
    print("Table is created");
  }

//insertion
  Future<int> saveBeer(TheBeers beer) async {
    var dbClient = await db;
    int res = await dbClient.insert("Favourites", beer.toMap());
    print("BEER Saved");
    return res;
  }

// Get Users
  Future<List> getAll() async{
    var dbClient = await db;
    var res = await dbClient.rawQuery("SELECT * FROM Favourites");
    print("given list");
    return res.toList();
  }

// Get Count
  Future<int> getCount() async{
    var dbClient = await db;
    return Sqflite.firstIntValue(
      await dbClient.rawQuery("SELECT COUNT(*) FROM Favourites")
    );
  }

// delete
  Future<int> deleteBeer(String _name) async{
    var dbClient = await db;
    // ? Below says that delete the row where Id == [id](which is passed in the argument)
    int res = await dbClient.delete("Favourites",where: "name = ?",whereArgs: [_name]);
    print("BEER del");
    return res;
  }


  Future close() async{
    var dbClient = await db;
    return dbClient.close();
  }

}