import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'assets/contact.dart';

class DatabaseHelper {
  // static Future<Database> initDB() async{
  //   var dbPath = await getDatabasesPath();
  //   String path = join(dbPath,'contacts.db');
  //   // this is to create database
  //   return await openDatabase(path,version: 1,onCreate: _onCreate);
  // }
  //
  // static Future _onCreate(Database db , int version) async{
  //   final sql = '''CREATE TABLE contacts(
  //       id INTEGER PRIMARY KEY AUTOINCREMENT,
  //       name TEXT,
  //       imgPath TEXT,
  //       numbers TEXT,
  //       info TEXT,
  //       isFavorite INTEGER
  //     )''';
  //
  //   await db.execute(sql);
  // }
  //
  // static Future<int> createContacts(Contact contact) async {
  //   Database db = await DatabaseHelper.initDB();
  //   return await db.insert('contacts', {
  //     'name': contact.name,
  //     'imgPath': contact.imgPath,
  //     'numbers': json.encode(contact.numbers),  // Convert numbers to JSON string
  //     'info': contact.info,
  //     'isFavorite': contact.isFavorite ? 1 : 0,
  //   });
  // }
  //
  // static Future<List<Contact>> readContacts() async{
  //   Database db = await DatabaseHelper.initDB();
  //   var contact = await db.query('contacts',orderBy: 'name');
  //   List<Contact> contactList = contact.isNotEmpty ? contact.map((details) => Contact.fromJSON(details)).toList(): [];
  //   return contactList;
  // }
  //
  // static Future<int> updateContact(Contact contact) async{
  //   Database db = await DatabaseHelper.initDB();
  //   return await db.update('contacts', contact.toJson(),where: 'id = ?',whereArgs: [contact.id]);
  // }
  //
  // static Future<int> deleteContact(int id) async{
  //   Database db = await DatabaseHelper.initDB();
  //   return await db.delete('contacts',where: 'id = ?',whereArgs: [id]);
  // }

  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('contacts.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
    CREATE TABLE contacts(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT,
      imgPath TEXT,
      numbers TEXT,
      info TEXT,
      isFavorite INTEGER
    )
    ''');
  }

  Future<int> insertContact(Contact contact) async {
    Database db = await instance.database;
    return await db.insert('contacts', {
      'name': contact.name,
      'imgPath': contact.imgPath,
      'numbers': json.encode(contact.numbers),  // Assuming numbers is a Map
      'info': contact.info,
      'isFavorite': contact.isFavorite ? 1 : 0,
    });
  }

  Future<List<Contact>> getContacts() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('contacts');
    return List.generate(maps.length, (i) {
      return Contact.fromMap(maps[i]);
    });
  }

  Future<int> updateContact(Contact contact) async {
    final db = await database;
    return await db.update(
      'contacts',
      contact.toMap(),
      where: 'id = ?',
      whereArgs: [contact.id],
    );
  }

  Future<int> deleteContact(Contact contact) async {
    Database db = await instance.database;
    return await db.delete(
      'contacts',
      where: 'id = ?',
      whereArgs: [contact.id],
    );
  }
}