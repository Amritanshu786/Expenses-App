import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../models/transaction.dart'as tx;

class DatabaseHelper {
  static DatabaseHelper _databaseHelper; // Singleton DatabaseHelper
  static Database _database; // Singleton Database

  String expensesTable = 'expenses';
  String colId = 'id';
  String colTitle = 'title';
  String colAmount = 'amount';
  String colDate = 'date';

  DatabaseHelper._createInstance(); // Named constructor to create instance of DatabaseHelper

  factory DatabaseHelper() {
    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper
          ._createInstance(); // This is executed only once, singleton object
    }
    return _databaseHelper;
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await initializeDatabase();
    }
    return _database;
  }

  Future<Database> initializeDatabase() async {
    // Get the directory path for both Android and iOS to store database.
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'expenses.db';

    // Open/create the database at a given path
    var notesDatabase =
        await openDatabase(path, version: 1, onCreate: _createDb);
    return notesDatabase;
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute('CREATE TABLE $expensesTable($colId TEXT, $colTitle TEXT, $colAmount REAL, $colDate TEXT)');
  }

  // Fetch Operation: Get all note objects from database
  Future<List<Map<String, dynamic>>> getNoteMapList() async {
    Database db = await this.database;

//		var result = await db.rawQuery('SELECT * FROM $noteTable order by $colPriority ASC');
    var result = await db.query(expensesTable);
    return result;
  }

  // Insert Operation: Insert a Note object to database
  Future<void> insertNote(tx.Transaction note) async {
    Database db = await this.database;
    await db.insert(expensesTable, note.toMap());
  }

  // Update Operation: Update a Note object and save it to database
  Future<int> updateNote(tx.Transaction note) async {
    var db = await this.database;
    var result = await db.update(expensesTable, note.toMap());
    return result;
  }

  // Delete Operation: Delete a Note object from database
  Future<int> deleteNote(tx.Transaction note) async {
    //print('Id in database_helper');
    var db = await this.database;
    //String deletethis = "DELETE FROM $expensesTable WHERE id = ${note.id}";
    //int result = await db.rawDelete(deletethis);
		//return result;
    return await db.delete(expensesTable, where: '$colId = ?', whereArgs: [note.id]);

  }

  // Get the 'Map List' [ List<Map> ] and convert it to 'Transaction List' [ List<Transaction> ]
  Future<List<tx.Transaction>> getNoteList() async {
    var noteMapList = await getNoteMapList(); // Get 'Map List' from database
    int count =
        noteMapList.length; // Count the number of map entries in db table

    List<tx.Transaction> noteList = List<tx.Transaction>();
    // For loop to create a 'Note List' from a 'Map List'
    for (int i = 0; i < count; i++) {
      noteList.add(tx.Transaction.fromMapObject(noteMapList[i]));
    }

    return noteList;
  }
}
